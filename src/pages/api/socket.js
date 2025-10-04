// 文件路径: src/lib/socket.js (最终版本)

import { io } from 'socket.io-client';

// 从环境变量读取 URL，如果不存在则使用生产环境 URL
const SERVER_URL = process.env.NEXT_PUBLIC_API_URL || 'https://api.run-gen.com';

// 关键修正：
// 1. 我们直接连接到根 URL。
// 2. 我们移除了 `path` 选项，因为 Nginx 的 `location /socket.io/` 块会自动处理路径。
//    Socket.IO 客户端默认就会去请求 /socket.io/ 路径。
export const socket = io(SERVER_URL, {
  // 优先使用 WebSocket，如果失败，它会自动降级到 polling
  transports: ['websocket', 'polling']
});

// (可选) 添加诊断日志，方便我们在浏览器控制台查看连接状态
socket.on('connect', () => {
  console.log('✅ Socket.IO connected successfully via dedicated server to:', SERVER_URL);
});

socket.on('connect_error', (err) => {
  console.error('❌ Socket.IO connection error:', err.message, err.cause);
});