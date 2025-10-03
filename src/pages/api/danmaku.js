const DIRECTUS_URL = process.env.DIRECTUS_URL;
const DIRECTUS_STATIC_TOKEN = process.env.DIRECTUS_STATIC_TOKEN;

export default async function handler(req, res) {
  const commonHeaders = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${DIRECTUS_STATIC_TOKEN}`,
  };

  if (req.method === 'GET') {
    try {
      const { wallpaper_id } = req.query;

      if (!wallpaper_id) {
        return res.status(400).json({ error: 'wallpaper_id is required' });
      }

      // MODIFIED: Removed the "&sort=date_created" part to avoid permission errors.
      const fetchUrl = `${DIRECTUS_URL}/items/danmaku?filter[wallpaper_id][_eq]=${wallpaper_id}`;

      const response = await fetch(fetchUrl, {
        method: 'GET',
        headers: commonHeaders,
      });

      if (!response.ok) {
        // This block will catch errors if they still happen
        const errorBody = await response.text();
        console.error("Directus Error:", errorBody);
        throw new Error(`Directus responded with status ${response.status}`);
      }

      const result = await response.json();
      res.status(200).json(result.data);

    } catch (error) {
      console.error('Error fetching danmakus:', error);
      res.status(500).json({ error: 'Failed to fetch danmakus' });
    }
  } else if (req.method === 'POST') {
    try {
      const { wallpaper_id, message } = req.body;

      if (!wallpaper_id || !message) {
        return res.status(400).json({ error: 'wallpaper_id and message are required' });
      }

      const fetchUrl = `${DIRECTUS_URL}/items/danmaku`;

      const response = await fetch(fetchUrl, {
        method: 'POST',
        headers: commonHeaders,
        body: JSON.stringify({
          wallpaper_id,
          message,
        }),
      });
      
      if (!response.ok) {
        const errorBody = await response.json();
        console.error('Directus POST Error:', errorBody);
        throw new Error(`Directus responded with status ${response.status}`);
      }

      const newDanmaku = await response.json();
      res.status(201).json(newDanmaku.data);

    } catch (error) {
      console.error('Error creating danmaku:', error);
      res.status(500).json({ error: 'Failed to create danmaku' });
    }
  } else {
    res.setHeader('Allow', ['GET', 'POST']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}