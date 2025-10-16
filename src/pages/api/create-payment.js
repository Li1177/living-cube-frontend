import { Paddle, Environment } from '@paddle/paddle-node-sdk';
import { createDirectus, rest, staticToken, createItem, readItems, updateItem } from '@directus/sdk';

/**
 * Living Cube - v1.7 Payment API
 * Endpoint: /api/create-payment
 * Responsibilities: Create Paddle transaction, ensure bundle_id for Flow.
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

    const { wallpaper_id, bundle_type, user_id } = req.body;

    if (!user_id) {
      return res.status(400).json({ message: 'Error: user_id is required.' });
    }
    if (!bundle_type) {
      return res.status(400).json({ message: 'Error: bundle_type (single, bundle5, bundle10) is required.' });
    }

    // Query bundles to get bundle_id and price_cents
    const bundles = await directus.request(readItems('bundles', {
      filter: { type: { _eq: bundle_type } },
      limit: 1,
      fields: ['id', 'price_cents', 'download_count'],
    }));

    if (!bundles.length) {
      return res.status(400).json({ message: `Error: No bundle found for type ${bundle_type}.` });
    }

    const bundleItem = bundles[0];
    const bundle_id = bundleItem.id;

    // Select priceId based on bundle_type
    let priceId;
    switch (bundle_type) {
      case 'single':
        priceId = process.env.PADDLE_PRICE_ID_SINGLE;
        break;
      case 'bundle5':
        priceId = process.env.PADDLE_PRICE_ID_BUNDLE_BUNDLE5;
        break;
      case 'bundle10':
        priceId = process.env.PADDLE_PRICE_ID_BUNDLE_BUNDLE10;
        break;
      default:
        return res.status(400).json({ message: 'Error: Invalid bundle_type.' });
    }

    if (!priceId) {
      return res.status(500).json({ message: 'Error: Paddle priceId not configured.' });
    }

    // Create purchase record with bundle_id
    const initialPurchase = await directus.request(createItem('purchases', {
      user_id: user_id,
      wallpaper_id: wallpaper_id || null,
      bundle_id: bundle_id, // Always set bundle_id
      status: 'pending',
      type: 'monetary',
      payment_provider: 'paddle',
      price_cents: bundleItem.price_cents,
    }));
    const internalPurchaseId = initialPurchase.id;

    // Create Paddle transaction
    const transaction = await paddle.transactions.create({
      items: [{
        priceId: priceId,
        quantity: 1,
      }],
      customData: {
        internal_purchase_id: String(internalPurchaseId),
        bundle_id: String(bundle_id), // Add for Flow debugging
      },
    });

    // Update purchase with transaction ID
    await directus.request(updateItem('purchases', internalPurchaseId, {
      provider_transaction_id: transaction.id,
    }));

    res.status(200).json({
      message: 'Paddle transaction created successfully.',
      paymentUrl: transaction.checkout.url,
      transactionId: transaction.id,
      internalPurchaseId: internalPurchaseId,
    });
  } catch (error) {
    console.error('Paddle payment creation error:', error);
    if (error.name === 'PaddleSDKError') {
      return res.status(500).json({ message: 'Paddle API error.', details: error.message });
    }
    if (error.response && error.response.status === 400) {
      return res.status(400).json({ message: 'Database validation error.', details: error.message });
    }
    return res.status(500).json({ message: 'Internal server error.' });
  }
}