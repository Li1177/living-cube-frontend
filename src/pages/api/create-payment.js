// src/pages/api/create-payment.js

import AlipaySdk from 'alipay-sdk';
import { createDirectus, rest, readItem, createItem } from '@directus/sdk';

const ALIPAY_GATEWAY = 'https://openapi-sandbox.dl.alipaydev.com/gateway.do';

// 现在初始化应该成功
const alipay = new AlipaySdk({
  appId: process.env.ALIPAY_APP_ID,
  privateKey: process.env.ALIPAY_PRIVATE_KEY,
  alipayPublicKey: process.env.ALIPAY_PUBLIC_KEY,
  gateway: ALIPAY_GATEWAY,
  timeout: 5000,
  camelcase: false,
});

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST');
    return res.status(405).end('Method Not Allowed');
  }

  try {
    const directus = createDirectus('http://167.234.212.43:8055').with(rest());
    const { mediaId } = req.body;

    if (!mediaId) {
      return res.status(400).json({ message: '错误：缺少商品 ID (mediaId)' });
    }

    const wallpaper = await directus.request(readItem('wallpapers', mediaId, {
      fields: ['id', 'price_cents', 'name']
    }));
    
    if (!wallpaper || wallpaper.price_cents === undefined || wallpaper.price_cents === null) {
      return res.status(404).json({ message: `错误：ID 为 ${mediaId} 的壁纸不存在或价格未设置` });
    }

    const totalAmount = (wallpaper.price_cents / 100).toFixed(2);

    const newPurchase = await directus.request(createItem('purchases', {
      wallpaper: wallpaper.id,
      status: 'pending',
      price_at_purchase_cents: wallpaper.price_cents,
    }));
    
    const outTradeNo = `LC-${newPurchase.id}-${Date.now()}`;
    
    // 修改为 GET 方法，返回直接的支付 URL，便于前端跳转
    const result = await alipay.pageExecute('alipay.trade.page.pay', 'GET', {
      bizContent: {
        out_trade_no: outTradeNo,
        product_code: 'FAST_INSTANT_TRADE_PAY',
        total_amount: totalAmount,
        subject: `LivingCube: ${wallpaper.name}`,
        quit_url: 'http://localhost:3000',
      },
      return_url: 'http://localhost:3000/success',
    });

    res.status(200).json({ 
      message: '支付宝支付URL已生成',
      paymentUrl: result,
      outTradeNo: outTradeNo
    });

  } catch (error) {
    res.status(500).json({ 
      message: '服务器内部错误',
      error: error.message 
    });
  }
}