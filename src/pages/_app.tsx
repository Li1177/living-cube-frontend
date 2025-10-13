import '@/styles/globals.css';
import type { AppProps } from 'next/app';
import { useEffect } from 'react';
import { SessionProvider } from 'next-auth/react'; // <-- 新增导入
import { socket } from '../lib/socket';

export default function App({ Component, pageProps: { session, ...pageProps } }: AppProps) { // <-- 修改函数签名
  
  useEffect(() => {
    socket.connect();

    socket.on('connect', () => {
      console.log('✅ App.tsx: Frontend connected via shared socket! ID:', socket.id);
    });

    return () => {
      console.log('🔌 App.tsx: Disconnecting shared socket...');
      socket.disconnect();
    };
  }, []);

  // 新增 SessionProvider 包裹整个应用
  return (
    <SessionProvider session={session}>
      <Component {...pageProps} />
    </SessionProvider>
  );
}