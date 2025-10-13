// src/pages/api/create-payment.js
import { Paddle, Environment } from '@paddle/paddle-node-sdk';
import { createDirectus, rest, createItem, readItem, staticToken, updateItem } from '@directus/sdk';

/**
 * Living Cube - v1.3 支付后端 (最终修正版)
 * API Endpoint: /api/create-payment
 */
export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST');
    return res.status(405).end('Method Not Allowed');
  }

  try {
    const directus = createDirectus(process.env.DIRECTUS_URL)
      .with(staticToken(process.env.DIRECTUS_STATIC_TOKEN))
      .with(rest());

    const paddle = new Paddle(process.env.PADDLE_API_KEY, {
      environment: process.env.PADDLE_ENVIRONMENT === 'sandbox' ? Environment.sandbox : Environment.production,
    });

    const { wallpaper_id, bundle_id, user_id } = req.body;

    if (!user_id) {
        return res.status(400).json({ message: '错误: 必须提供 user_id。' });
    }
    if (!wallpaper_id && !bundle_id) {
        return res.status(400).json({ message: '错误: 必须提供 wallpaper_id 或 bundle_id。' });
    }

    const initialPurchase = await directus.request(createItem('purchases', {
      user_id: user_id,
      wallpaper_id: wallpaper_id || null,
      bundle_id: bundle_id || null,
      status: 'pending',
      type: 'monetary',
      payment_provider: 'paddle',
      price_cents: 0,
    }));
    const internalPurchaseId = initialPurchase.id;

    const transaction = await paddle.transactions.create({
      items: [{
        // 【核心修正】: 修正了致命的拼写错误 PADELE -> PADDLE
        priceId: process.env.PADDLE_PRICE_ID_SINGLE, 
        quantity: 1
      }],
      customData: {
        internal_purchase_id: String(internalPurchaseId), 
      },
    });

    await directus.request(updateItem('purchases', internalPurchaseId, {
        provider_transaction_id: transaction.id, 
    }));
    
    res.status(200).json({
      message: 'Paddle 交易创建成功。',
      paymentUrl: transaction.checkout.url,
      transactionId: transaction.id,
      internalPurchaseId: internalPurchaseId
    });

  } catch (error) {
    console.error('Paddle 支付创建错误:', error);
    if (error.name === 'PaddleSDKError') {
      return res.status(500).json({ message: 'Paddle API 错误', details: error.message });
    }
    if (error.response && error.response.status === 400) {
      return res.status(400).json({ message: '数据库验证错误', details: error.message });
    }
    return res.status(500).json({ message: '内部服务器错误' });
  }
}