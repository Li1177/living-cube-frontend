import { Server } from 'socket.io';
// 关键修正：从 SDK 额外导入 staticToken 函数
import { createDirectus, rest, createItem, staticToken } from '@directus/sdk';

// 1. 初始化 Directus SDK 客户端 (这是本次修正的核心)
const directusClient = createDirectus(process.env.DIRECTUS_URL)
  .with(rest())
  // 关键修正：使用 staticToken() 函数来提供认证，而不是 .with({...})
  .with(staticToken(process.env.DIRECTUS_STATIC_TOKEN));

const ioHandler = (req, res) => {
  if (!res.socket.server.io) {
    console.log('🚀 Initializing Socket.IO server...');
    
    const io = new Server(res.socket.server, {
      path: '/api/socket',
    });

    io.on('connection', (socket) => {
      console.log(`✅ Socket connected: ${socket.id}`);

      socket.on('join_room', (roomId) => {
        if (!roomId) return;
        console.log(`🚪 Socket ${socket.id} joined room: ${roomId}`);
        socket.join(roomId);
      });

      socket.on('leave_room', (roomId) => {
        if (!roomId) return;
        console.log(`🚪 Socket ${socket.id} left room: ${roomId}`);
        socket.leave(roomId);
      });

      socket.on('send_danmaku', async (data) => {
        const { wallpaper_id, message } = data;
        
        if (!wallpaper_id || !message || message.trim() === '') {
          console.error('❌ Invalid danmaku data received:', data);
          return;
        }

        console.log(`💬 Received danmaku for room ${wallpaper_id}: "${message}"`);

        try {
          // 保存到 Directus 的逻辑保持不变，因为 directusClient 现在已经正确配置了
          const newDanmaku = await directusClient.request(
            createItem('danmaku', {
              message: message,
              wallpaper_id: wallpaper_id,
            })
          );
          
          console.log(`💾 Successfully saved danmaku to Directus. ID: ${newDanmaku.id}`);

          // 广播逻辑保持不变
          io.to(wallpaper_id).emit('receive_danmaku', newDanmaku);
          console.log(`📢 Broadcasted new danmaku to room ${wallpaper_id}`);

        } catch (error) {
          console.error('❌ CRITICAL: Failed to save or broadcast danmaku!');
          const errorMessage = error.errors ? error.errors[0].message : error.message;
          console.error('Error Details:', errorMessage);
          socket.emit('danmaku_error', 'Your message could not be sent.');
        }
      });

      socket.on('disconnect', () => {
        console.log(`🔌 Socket disconnected: ${socket.id}`);
      });
    });

    res.socket.server.io = io;
  } else {
    console.log('Socket.IO server already running.');
  }
  res.end();
};

export const config = {
  api: {
    bodyParser: false,
  },
};

export default ioHandler;