import { Paddle, EventName } from '@paddle/paddle-node-sdk';
// --- [v1.7 最终修正] ---
// 导入专用于操作 'directus_users' 核心集合的函数
import { createDirectus, rest, staticToken, updateItem, readItem, readUser, updateUser } from '@directus/sdk';
// ----------------------

export const config = {
  api: {
    bodyParser: false,
  },
};

async function getRawBody(req) {
  const chunks = [];
  for await (const chunk of req) {
    chunks.push(typeof chunk === 'string' ? Buffer.from(chunk) : chunk);
  }
  return Buffer.concat(chunks);
}

export default async function handler(req, res) {
  const directus = createDirectus(process.env.DIRECTUS_URL)
    .with(staticToken(process.env.DIRECTUS_STATIC_TOKEN))
    .with(rest());

  const paddle = new Paddle(process.env.PADDLE_API_KEY);

  const signature = req.headers['paddle-signature'];
  const rawRequestBody = await getRawBody(req);

  try {
    const event = paddle.webhooks.unmarshal(rawRequestBody, process.env.PADDLE_WEBHOOK_SECRET, signature);

    if (event.eventType === EventName.TransactionCompleted) {
      console.log(`✅ [SUCCESS] Received and verified 'transaction.completed' event for transaction: ${event.data.id}`);

      const internalPurchaseId = event.data.customData?.internal_purchase_id;
      const bundleId = event.data.customData?.bundle_id;
      if (!internalPurchaseId) {
        console.warn('Webhook missing internal_purchase_id:', event.data.id);
        return res.status(200).send('Event received, but no internal ID to process.');
      }

      const purchase = await directus.request(readItem('purchases', Number(internalPurchaseId), {
        fields: ['id', 'bundle_id', 'user_id', 'status'],
      }));

      await directus.request(updateItem('purchases', Number(internalPurchaseId), {
        status: 'completed',
        price_cents: event.data.details.totals.total,
      }));
      console.log(`Updated purchase ${internalPurchaseId} to completed.`);

      // --- [v1.7 最终修正] ---
      // FIX: 使用 readUser 和 updateUser 来正确操作 'directus_users' 核心集合
      const user = await directus.request(readUser(purchase.user_id, { fields: ['download_limit'] }));
      
      let downloadCount = 1;
      if (purchase.bundle_id || bundleId) {
        const bundle = await directus.request(readItem('bundles', purchase.bundle_id || Number(bundleId), { fields: ['download_count'] }));
        downloadCount = bundle.download_count || 1;
      }

      const oldLimit = user.download_limit || 0;
      const newLimit = oldLimit + downloadCount;
      
      await directus.request(updateUser(purchase.user_id, { download_limit: newLimit }));
      // ----------------------

      console.log(`✅ [SUCCESS] User ${purchase.user_id} download_limit updated from ${oldLimit} to ${newLimit}.`);

      res.status(200).send('Webhook processed successfully.');
    } else {
      console.log(`Ignored event type: ${event.eventType}`);
      res.status(200).send('Event received but ignored.');
    }
  } catch (error) {
    console.error('Paddle webhook error:', error.message);
    res.status(400).send(`Webhook Error: ${error.message}`);
  }
}