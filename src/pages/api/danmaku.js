// /api/danmaku.js (终极修复版 - 生产适配)
import { createDirectus, rest, readItems } from '@directus/sdk';  // 改：readItems 替换 query

// 创建一个公开的、不带 Token 的客户端
const directus = createDirectus(process.env.DIRECTUS_URL).with(rest());

export default async function handler(req, res) {
  if (req.method !== 'GET') {
    res.setHeader('Allow', ['GET']);
    return res.status(405).end(`Method ${req.method} Not Allowed`);
  }

  try {
    const { wallpaper_id } = req.query; // 接收前端的 'wallpaper_id'

    if (!wallpaper_id) {
      return res.status(400).json({ error: 'Query parameter "wallpaper_id" is required.' });
    }

    // 使用 'wallpaper_id' 的值去查询数据库的 'video_id' 字段
    const danmakus = await directus.request(readItems('danmaku', {  // 改：readItems 替换 query
        filter: {
            video_id: { _eq: wallpaper_id } 
        },
        sort: ['timestamp'],
        fields: ['id', 'content', 'timestamp', 'color', 'type']
    }));

    res.status(200).json(danmakus);

  } catch (error) {
    console.error('Error fetching danmakus:', error);
    res.status(500).json({ error: 'Failed to fetch danmakus' });
  }
}