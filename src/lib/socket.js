// 文件路径: src/lib/socket.js (最终版本)

import { io } from 'socket.io-client';

// 从环境变量读取 URL，如果不存在则使用生产环境 URL。这一部分保持不变。
const SERVER_URL = process.env.NEXT_PUBLIC_API_URL || 'https://api.run-gen.com';

// 关键修正：
// 我们移除了 `path` 选项。
// Socket.IO 客户端现在会自动尝试连接到 'https://api.run-gen.com/socket.io/'
// 这个路径会被我们 Nginx 的 `location /socket.io/` 块精确匹配，并转发到 3001 端口。
export const socket = io(SERVER_URL, {
  // 优先使用 WebSocket
  transports: ['websocket', 'polling']
});

// 诊断日志保持不变，它们依然非常有用
socket.on('connect', () => {
  console.log('✅ Socket.IO connected successfully via dedicated server to:', SERVER_URL);
});

socket.on('connect_error', (err) => {
  // 我们可以打印更详细的错误信息
  console.error('❌ Socket.IO connection error:', err.message, err.cause ? err.cause : '');
});