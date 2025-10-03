// 关键修正：确保这里是 'socket.io-client'
import { io } from 'socket.io-client';

const SOCKET_PATH = '/api/socket';

// 创建并导出一个 socket 实例
// 这个实例将在整个应用中共享
export const socket = io({
  path: SOCKET_PATH,
  autoConnect: false, // 保持手动连接，这是一个好习惯
});