// src/pages/api/verify-payment.js (生产适配版)
// 新增 API 路由：验证支付宝支付结果，并更新订单状态，返回下载链接

const ALIPAY_GATEWAY = 'https://openapi-sandbox.alipaydev.com/gateway.do';

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', ['POST']);
    return res.status(405).end('Method Not Allowed');
  }

  // 生产：验证 JSON body
  if (req.headers['content-type'] !== 'application/json') {
    return res.status(400).json({ message: 'Content-Type must be application/json' });
  }

  try {
    // 动态 import SDK (ESLint 合规, 避 top-level import 问题)
    const { AlipaySdk } = await import('alipay-sdk');
    const { createDirectus, rest, readItem, updateItem, staticToken } = await import('@directus/sdk');

    // 初始化 Alipay SDK
    const alipay = new AlipaySdk({
      appId: process.env.ALIPAY_APP_ID,
      privateKey: process.env.ALIPAY_PRIVATE_KEY,
      alipayPublicKey: process.env.ALIPAY_PUBLIC_KEY,
      gateway: ALIPAY_GATEWAY,
      timeout: 5000,
      camelcase: false,
    });

    const DIRECTUS_URL = process.env.DIRECTUS_URL || 'https://api.run-gen.com';
    const directus = createDirectus(DIRECTUS_URL)
      .with(staticToken(process.env.DIRECTUS_STATIC_TOKEN))
      .with(rest());

    const { outTradeNo } = req.body;

    if (!outTradeNo) {
      return res.status(400).json({ message: 'Error: Missing outTradeNo' });
    }

    let purchaseId;
    try {
      const purchaseIdMatch = outTradeNo.match(/^LC-(\d+)-/);
      if (!purchaseIdMatch) {
        return res.status(400).json({ message: 'Error: Invalid outTradeNo format' });
      }
      purchaseId = parseInt(purchaseIdMatch[1], 10);
    } catch (parseError) {
      console.error('Parse error:', parseError);  // 生产：log unused var
      return res.status(400).json({ message: 'Error: Invalid purchase ID in outTradeNo' });
    }

    const queryResult = await alipay.exec('alipay.trade.query', {
      bizContent: {
        out_trade_no: outTradeNo,
      },
    });

    if (queryResult.code !== '10000') {
      return res.status(400).json({ 
        message: 'Payment verification failed', 
        alipayResponse: queryResult.msg || 'Unknown error' 
      });
    }

    if (queryResult.trade_status !== 'TRADE_SUCCESS') {
      return res.status(400).json({ 
        message: 'Payment not completed or failed', 
        tradeStatus: queryResult.trade_status 
      });
    }

    await directus.request(updateItem('purchases', purchaseId, {
      status: 'paid',
    }));

    const purchase = await directus.request(readItem('purchases', purchaseId, {
      fields: ['wallpaper_id'],
    }));
    const wallpaperId = purchase.wallpaper_id;

    if (!wallpaperId) {
      return res.status(404).json({ message: 'Wallpaper ID not found in order' });
    }

    const wallpaper = await directus.request(readItem('wallpapers', wallpaperId, {
      fields: ['name', 'wallpaper_file'],
    }));

    if (!wallpaper || !wallpaper.wallpaper_file) {
      return res.status(404).json({ message: 'Wallpaper file not found' });
    }

    const fileId = wallpaper.wallpaper_file;
    const downloadUrl = `${DIRECTUS_URL}/assets/${fileId}`;

    res.status(200).json({ 
      message: 'Payment verified successfully, order updated',
      downloadUrl: downloadUrl,
      wallpaperName: wallpaper.name,
      outTradeNo: outTradeNo
    });

  } catch (error) {
    console.error('Payment verification error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
}