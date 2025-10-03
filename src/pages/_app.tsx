// 文件路径: src/pages/_app.tsx

import '@/styles/globals.css';
import type { AppProps } from 'next/app';
import { useEffect } from 'react';
// 删除了: import { io } from 'socket.io-client';
// 新增: 从我们创建的共享文件中导入 socket 实例
import { socket } from '../lib/socket';

// 删除了: const socketInitializer = async () => { ... };
// 因为新的连接方式不再需要这个函数

export default function App({ Component, pageProps }: AppProps) {
  
  useEffect(() => {
    // 删除了: socketInitializer();
    // 删除了: const socket = io();

    // 修改: 直接使用从外部导入的 socket 实例，并手动连接
    socket.connect();

    // 修改: 为导入的 socket 实例设置监听器，并优化日志
    socket.on('connect', () => {
      console.log('✅ App.tsx: Frontend connected via shared socket! ID:', socket.id);
    });

    // 修改: 为导入的 socket 实例设置清理函数，并优化日志
    return () => {
      console.log('🔌 App.tsx: Disconnecting shared socket...');
      socket.disconnect();
    };
  }, []); // 依赖数组保持不变，确保只运行一次

  return <Component {...pageProps} />;
}