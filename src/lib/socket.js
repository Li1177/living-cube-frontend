// 文件路径: src/lib/socket.js (生产适配版)
import { io } from 'socket.io-client';

// 从环境变量读取 URL，如果不存在则使用生产环境 URL。
const SERVER_URL = process.env.NEXT_PUBLIC_API_URL || 'https://api.run-gen.com';

// Socket.IO 客户端自动连接到 'https://api.run-gen.com/socket.io/'，Nginx 代理到 3001。
export const socket = io(SERVER_URL, {
  // 优先使用 WebSocket
  transports: ['websocket', 'polling']
});

// 诊断日志
socket.on('connect', () => {
  console.log('✅ Socket.IO connected successfully via dedicated server to:', SERVER_URL);
});

socket.on('connect_error', (err) => {
  console.error('❌ Socket.IO connection error:', err.message, err.cause ? err.cause : '');
});