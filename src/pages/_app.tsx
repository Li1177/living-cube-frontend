import '@/styles/globals.css';
import type { AppProps } from 'next/app';
import { useEffect } from 'react';
import { SessionProvider, useSession } from 'next-auth/react';
import { socket } from '../lib/socket';
import { AuthModal } from '../components/AuthModal';

// 我们将 Paddle 初始化逻辑封装在一个独立的组件中，以方便访问 session 数据
function PaddleLoader() {
  const { data: session } = useSession(); // 获取用户信息

  useEffect(() => {
    // 动态加载 Paddle.js 脚本
    const script = document.createElement('script');
    script.src = 'https://cdn.paddle.com/paddle/v2/paddle.js';
    script.async = true;
    
    script.onload = () => {
      // 脚本加载成功后，进行初始化
      if (process.env.NEXT_PUBLIC_PADDLE_CLIENT_SIDE_TOKEN) {
        window.Paddle.Initialize({ 
          token: process.env.NEXT_PUBLIC_PADDLE_CLIENT_SIDE_TOKEN,
        });
        console.log('✅ Paddle.js Initialized');
      } else {
        console.error('❌ PADDLE_CLIENT_SIDE_TOKEN is not defined. Paddle cannot be initialized.');
      }
    };
    
    document.body.appendChild(script);

    return () => {
      // 组件卸载时移除脚本，保持整洁
      document.body.removeChild(script);
    };
  }, [session]);

  return null; // 这个组件不渲染任何 UI
}

export default function App({ Component, pageProps: { session, ...pageProps } }: AppProps) {
  
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

  return (
    <SessionProvider session={session}>
      <PaddleLoader /> {/* <-- 在此处加载 Paddle 初始化器 */}
      <Component {...pageProps} />
      <AuthModal /> {/* <-- [新增 v1.6] 全局渲染 AuthModal */}
    </SessionProvider>
  );
}