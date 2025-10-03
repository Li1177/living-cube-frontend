// src/pages/404.js
// Pages Router 自定义 404 页面，解决未找到路由问题

import Link from 'next/link';

export default function NotFound() {
  return (
    <div style={{ padding: '20px', textAlign: 'center', fontFamily: 'Arial, sans-serif' }}>
      <h1>404 - 页面未找到</h1>
      <p>抱歉，您访问的页面不存在。</p>
      <Link href="/" style={{ color: '#0070f3' }}>返回首页</Link>
    </div>
  );
}