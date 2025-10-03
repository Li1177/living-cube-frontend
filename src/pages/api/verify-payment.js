// src/pages/api/verify-payment.js
// 新增 API 路由：验证支付宝支付结果，并更新订单状态，返回下载链接

import AlipaySdk from 'alipay-sdk';
import { createDirectus, rest, readItem } from '@directus/sdk';

const ALIPAY_GATEWAY = 'https://openapi-sandbox.dl.alipaydev.com/gateway.do';

const alipay = new AlipaySdk({
  appId: process.env.ALIPAY_APP_ID,
  privateKey: process.env.ALIPAY_PRIVATE_KEY,
  alipayPublicKey: process.env.ALIPAY_PUBLIC_KEY,
  gateway: ALIPAY_GATEWAY,
  timeout: 5000,
  camelcase: false,
});

const DIRECTUS_TOKEN = process.env.DIRECTUS_STATIC_TOKEN;
const DIRECTUS_URL = 'http://167.234.212.43:8055';

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', ['POST']);
    return res.status(405).end('Method Not Allowed');
  }

  try {
    const { outTradeNo } = req.body;

    if (!outTradeNo) {
      return res.status(400).json({ message: '错误：缺少 outTradeNo' });
    }

    const purchaseIdMatch = outTradeNo.match(/^LC-(\d+)-/);
    if (!purchaseIdMatch) {
      return res.status(400).json({ message: '错误：无效的 outTradeNo 格式' });
    }
    const purchaseId = parseInt(purchaseIdMatch[1], 10);

    if (!DIRECTUS_TOKEN) {
      return res.status(500).json({ message: '服务器配置错误：缺少 Directus 静态 token' });
    }

    const queryResult = await alipay.exec('alipay.trade.query', {
      bizContent: {
        out_trade_no: outTradeNo,
      },
    });

    if (queryResult.code !== '10000') {
      return res.status(400).json({ 
        message: '支付验证失败', 
        alipayResponse: queryResult.msg || '未知错误' 
      });
    }

    if (queryResult.trade_status !== 'TRADE_SUCCESS') {
      return res.status(400).json({ 
        message: '支付尚未完成或失败', 
        tradeStatus: queryResult.trade_status 
      });
    }

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 30000);

    try {
      const updateResponse = await fetch(`${DIRECTUS_URL}/items/purchases/${purchaseId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${DIRECTUS_TOKEN}`,
        },
        body: JSON.stringify({
          status: 'paid',
        }),
        signal: controller.signal,
      });

      if (!updateResponse.ok) {
        const errorText = await updateResponse.text();
        throw new Error(`更新订单失败: ${updateResponse.status} - ${errorText}`);
      }

      const purchaseResponse = await fetch(`${DIRECTUS_URL}/items/purchases/${purchaseId}?fields=wallpaper`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${DIRECTUS_TOKEN}`,
        },
        signal: controller.signal,
      });

      if (!purchaseResponse.ok) {
        const errorText = await purchaseResponse.text();
        throw new Error(`查询订单失败: ${purchaseResponse.status} - ${errorText}`);
      }

      const purchase = await purchaseResponse.json();
      const wallpaperId = purchase.data ? purchase.data.wallpaper : purchase.wallpaper;

      if (!wallpaperId) {
        return res.status(404).json({ message: '订单中未找到壁纸 ID' });
      }

      const wallpaperResponse = await fetch(`${DIRECTUS_URL}/items/wallpapers/${wallpaperId}?fields=name,wallpaper_file`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${DIRECTUS_TOKEN}`,
        },
        signal: controller.signal,
      });

      if (!wallpaperResponse.ok) {
        const errorText = await wallpaperResponse.text();
        throw new Error(`查询壁纸失败: ${wallpaperResponse.status} - ${errorText}`);
      }

      const wallpaper = await wallpaperResponse.json();
      const wallpaperData = wallpaper.data || wallpaper;

      if (!wallpaperData || !wallpaperData.wallpaper_file) {
        return res.status(404).json({ message: '壁纸文件未找到' });
      }

      const fileId = wallpaperData.wallpaper_file;
      const downloadUrl = `${DIRECTUS_URL}/assets/${fileId}?access_token=${DIRECTUS_TOKEN}`;

      clearTimeout(timeoutId);

      res.status(200).json({ 
        message: '支付验证成功，订单已更新',
        downloadUrl: downloadUrl,
        wallpaperName: wallpaperData.name,
        outTradeNo: outTradeNo
      });

    } catch (fetchError) {
      clearTimeout(timeoutId);
      if (fetchError.name === 'AbortError') {
        throw new Error('Directus 查询超时 (30s) - 请检查服务器连接');
      }
      throw fetchError;
    }

  } catch (error) {
    console.error('验证支付错误:', error);
    res.status(500).json({ 
      message: '服务器内部错误', 
      error: error.message 
    });
  }
}