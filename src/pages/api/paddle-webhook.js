// src/pages/api/paddle-webhook.js
// 【生产版本】: 包含 Paddle 签名验证，安全可靠。
import { Paddle, EventName } from '@paddle/paddle-node-sdk';
import { createDirectus, rest, staticToken, updateItem } from '@directus/sdk';

/**
 * Living Cube - v1.3 支付后端 Webhook (生产安全版)
 * 职责:
 * 1. 安全地接收并验证来自 Paddle 的 webhook 事件。
 * 2. 只处理 `transaction.completed` 事件。
 * 3. 从事件的 `custom_data` 中解析出我们的内部 purchase ID。
 * 4. 更新 Directus `purchases` 集合中的对应记录 (status, price_cents)。
 */
export default async function handler(req, res) {
  const directus = createDirectus(process.env.DIRECTUS_URL)
    .with(staticToken(process.env.DIRECTUS_STATIC_TOKEN))
    .with(rest());
  
  const paddle = new Paddle(process.env.PADDLE_API_KEY);

  // 【安全恢复】: 恢复 Webhook 签名验证，这是生产环境的核心安全保障。
  const signature = req.headers['paddle-signature'];
  const rawRequestBody = await getRawBody(req);

  try {
    // 使用 paddle.webhooks.unmarshal() 来安全地验证和解析请求。
    const event = paddle.webhooks.unmarshal(rawRequestBody, process.env.PADDLE_WEBHOOK_SECRET, signature);

    if (event.eventType === EventName.TransactionCompleted) {
      console.log(`接收到【真实】交易完成事件: ${event.data.id}`);

      const internalPurchaseId = event.data.customData?.internal_purchase_id;

      if (!internalPurchaseId) {
        console.warn('Webhook 事件缺少 internal_purchase_id，无法处理:', event.data.id);
        return res.status(200).send('Event received, but no internal ID to process.');
      }

      await directus.request(updateItem('purchases', Number(internalPurchaseId), {
          status: 'completed',
          price_cents: event.data.details.totals.total,
      }));
      
      console.log(`成功更新 Directus purchase ID: ${internalPurchaseId} 的状态为 completed。`);
    }

    res.status(200).send('Webhook processed successfully.');

  } catch (error) {
    console.error('处理 Paddle webhook 时发生错误:', error.message);
    res.status(400).send(`Webhook Error: ${error.message}`);
  }
}

// 辅助函数，用于获取原始请求体以验证签名
async function getRawBody(req) {
    const chunks = [];
    for await (const chunk of req) {
        chunks.push(typeof chunk === 'string' ? Buffer.from(chunk) : chunk);
    }
    return Buffer.concat(chunks);
}