// src/pages/api/create-payment.js (生产适配版)
const ALIPAY_GATEWAY = 'https://openapi-sandbox.alipaydev.com/gateway.do';

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST');
    return res.status(405).end('Method Not Allowed');
  }

  // 生产：验证 JSON body
  if (req.headers['content-type'] !== 'application/json') {
    return res.status(400).json({ message: 'Content-Type must be application/json' });
  }

  try {
    // 动态 import SDK (ESLint 合规, 避 top-level require)
    const { Alipay } = await import('alipay-sdk');
    const { createDirectus, rest, readItem, createItem, updateItem, staticToken } = await import('@directus/sdk');

    // 初始化 Alipay SDK
    const alipay = new Alipay({
      appId: process.env.ALIPAY_APP_ID,
      privateKey: process.env.ALIPAY_PRIVATE_KEY,
      alipayPublicKey: process.env.ALIPAY_PUBLIC_KEY,
      gateway: ALIPAY_GATEWAY,
      timeout: 5000,
      camelcase: false,
    });

    const directus = createDirectus(process.env.DIRECTUS_URL)
      .with(staticToken(process.env.DIRECTUS_STATIC_TOKEN))
      .with(rest());
    const { mediaId, userId = 'anonymous' } = req.body;

    if (!mediaId) {
      return res.status(400).json({ message: 'Error: Missing product ID (mediaId)' });
    }

    const wallpaper = await directus.request(readItem('wallpapers', mediaId, {
      fields: ['id', 'price_cents', 'name']
    }));
    
    if (!wallpaper || wallpaper.price_cents === undefined || wallpaper.price_cents === null) {
      return res.status(404).json({ message: `Error: Wallpaper with ID ${mediaId} does not exist or price is not set` });
    }

    const totalAmount = (wallpaper.price_cents / 100).toFixed(2);

    const newPurchase = await directus.request(createItem('purchases', {
      user_id: userId,
      wallpaper_id: wallpaper.id,
      price_cents: wallpaper.price_cents,
      payment_provider: 'alipay',
      status: 'pending',
    }));
    
    const outTradeNo = `LC-${newPurchase.id}-${Date.now()}`;
    
    await directus.request(updateItem('purchases', newPurchase.id, {
      external_order_id: outTradeNo,
    }));
    
    const baseUrl = process.env.NEXT_PUBLIC_BASE_URL || 'https://app.run-gen.com';
    const result = await alipay.pageExecute('alipay.trade.page.pay', 'GET', {
      bizContent: {
        out_trade_no: outTradeNo,
        product_code: 'FAST_INSTANT_TRADE_PAY',
        total_amount: totalAmount,
        subject: `LivingCube: ${wallpaper.name}`,
        quit_url: baseUrl,
        return_url: `${baseUrl}/success`,
      },
    });

    res.status(200).json({ 
      message: 'Alipay payment URL generated',
      paymentUrl: result,
      outTradeNo: outTradeNo
    });

  } catch (error) {
    console.error('Payment creation error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
}