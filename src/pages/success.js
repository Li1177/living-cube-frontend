// src/pages/success.js
// 支付成功回调页面：验证支付并提供下载链接（Pages Router 版本）

import { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import Link from 'next/link';

export default function Success() {
  const router = useRouter();
  const { out_trade_no } = router.query; // 从 URL query 获取 out_trade_no
  const [status, setStatus] = useState('verifying'); // verifying, success, error
  const [downloadUrl, setDownloadUrl] = useState('');
  const [errorMsg, setErrorMsg] = useState('');
  const [wallpaperName, setWallpaperName] = useState('');

  useEffect(() => {
    if (!out_trade_no) {
      setStatus('error');
      setErrorMsg('缺少支付订单号');
      return;
    }

    // 调用后端 API 验证支付
    fetch('/api/verify-payment', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ outTradeNo: out_trade_no }),
    })
      .then(res => res.json())
      .then(data => {
        console.log('验证响应:', data); // F12 Console 检查这个日志
        if (data.message === '支付验证成功，订单已更新') {
          setStatus('success');
          setDownloadUrl(data.downloadUrl);
          setWallpaperName(data.wallpaperName);
        } else {
          setStatus('error');
          setErrorMsg(data.message || '未知验证错误');
        }
      })
      .catch(err => {
        console.error('验证错误:', err);
        setStatus('error');
        setErrorMsg('验证失败: ' + err.message);
      });
  }, [out_trade_no]);

  if (status === 'verifying') {
    return (
      <div style={{ padding: '20px', textAlign: 'center', fontFamily: 'Arial, sans-serif' }}>
        <h1>支付验证中...</h1>
        <p>请稍候，我们正在确认您的支付结果。</p>
      </div>
    );
  }

  if (status === 'success') {
    return (
      <div style={{ padding: '20px', textAlign: 'center', fontFamily: 'Arial, sans-serif' }}>
        <h1>🎉 支付成功！</h1>
        <p>感谢您的购买。您现在可以下载 {wallpaperName} 的原图。</p>
        <a 
          href={downloadUrl} 
          download={wallpaperName ? `${wallpaperName}.jpg` : 'wallpaper.jpg'} // 假设 jpg，可调整
          style={{ 
            display: 'inline-block', 
            padding: '12px 24px', 
            backgroundColor: '#28a745', 
            color: 'white', 
            textDecoration: 'none', 
            borderRadius: '5px', 
            fontSize: '16px',
            margin: '10px'
          }}
        >
          📥 下载原图
        </a>
        <p style={{ marginTop: '20px' }}>
          <Link href="/">返回首页</Link>
        </p>
      </div>
    );
  }

  return (
    <div style={{ padding: '20px', textAlign: 'center', fontFamily: 'Arial, sans-serif' }}>
      <h1>❌ 支付处理失败</h1>
      <p>{errorMsg}</p>
      <p>
        <Link href="/" style={{ color: '#0070f3', marginRight: '10px' }}>返回首页</Link> | 
        <Link href="/products" style={{ color: '#0070f3' }}>重新购买</Link>
      </p>
    </div>
  );
}