// 文件路径: src/components/DanmakuOverlay.js (响应式生产适配版)
import React, { useState } from 'react';
import { socket } from '../lib/socket';  // 新增：import socket for userId

// 这是一个独立的 CSS 样式块，专门用于弹幕的滚动动画
const danmakuAnimation = `
  @keyframes danmaku-scroll {
    from {
      transform: translateX(100%);
    }
    to {
      transform: translateX(-100%);
    }
  }
`;

// 弹幕的单个条目组件
const DanmakuTrackItem = ({ content }) => {
  const duration = Math.random() * 5 + 8; // 8到13秒
  const topPosition = Math.random() * 70 + 5; // 5% 到 75% 之间

  return (
    <div
      className="absolute whitespace-nowrap text-white text-xl sm:text-2xl font-bold"  // 响应式：移动小字体
      style={{
        top: `${topPosition}%`,
        right: 0,
        animation: `danmaku-scroll ${duration}s linear`,
        textShadow: '1px 1px 2px black, -1px -1px 2px black, 1px -1px 2px black, -1px 1px 2px black',
      }}
    >
      {content}
    </div>
  );
};

// 整个 2D 界面的主组件
export const DanmakuOverlay = ({ mediaItem, danmakuList, onDanmakuSubmit, purchaseState }) => {
  const [danmakuInput, setDanmakuInput] = useState('');
  const [localPurchaseState, setLocalPurchaseState] = useState('idle');  // 生产：本地状态，同步 props
    
  const handlePurchase = async () => {
      setLocalPurchaseState('pending');
      try {
          const response = await fetch('/api/create-payment', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ mediaId: mediaItem.id, userId: socket.id }),  // 生产：加 userId
          });
          const data = await response.json();
          if (!response.ok) throw new Error(data.message || 'Failed to create payment');
          if (data.paymentUrl) window.location.href = data.paymentUrl;
          else setLocalPurchaseState('success');  // 生产：成功状态
      } catch (error) {
          console.error('Purchase error:', error);  // 生产：log 而非 unused var
          setLocalPurchaseState('error');
      }
  };

  const handleSubmit = (e) => {
      e.preventDefault();
      if (!danmakuInput.trim()) return;
      onDanmakuSubmit(danmakuInput);
      setDanmakuInput('');
  };
  
  // 生产：动态价格
  const priceInDollars = mediaItem?.price_cents ? (mediaItem.price_cents / 100).toFixed(2) : '0.99';
  const buttonText = {
      idle: `Unlock for $${priceInDollars}`,
      pending: 'Redirecting...',
      success: 'Unlocked!',  // 新增：成功状态
      error: 'Payment Failed, Retry'
  }[localPurchaseState || purchaseState];  // 同步 props

  return (
    <div className="absolute top-0 left-0 w-full h-full pointer-events-none">
      <style>{danmakuAnimation}</style>
      
      <div className="relative w-full h-full overflow-hidden">
        {danmakuList.map((danmaku, index) => (
          <DanmakuTrackItem key={danmaku.id || index} content={danmaku.content} />  // 生产：fallback key
        ))}
      </div>

      <div className="absolute bottom-5 left-1/2 -translate-x-1/2 z-50 flex flex-col items-center gap-4 pointer-events-auto p-2 sm:p-4 w-full max-w-md mx-auto">  // 响应式：移动全宽小 padding
          <button
              onClick={handlePurchase}
              disabled={localPurchaseState === 'pending'}
              className="px-3 py-2 w-full bg-blue-600 text-white font-bold rounded-lg shadow-lg hover:bg-blue-500 active:bg-blue-700 transition-colors disabled:opacity-50 text-sm sm:text-base"  // 响应式：移动小 padding/字体
          >
              {buttonText}
          </button>
          <form onSubmit={handleSubmit} className="flex flex-col sm:flex-row gap-2 w-full">
              <input
                  type="text"
                  value={danmakuInput}
                  onChange={(e) => setDanmakuInput(e.target.value)}
                  placeholder="Send a comment..."
                  maxLength={50}  // 生产：限长
                  className="w-full px-2 py-2 bg-gray-800 bg-opacity-80 text-white rounded-lg border border-gray-600 focus:outline-none focus:border-blue-500 text-sm sm:text-base"  // 响应式：移动小 padding/字体
              />
              <button type="submit" className="px-3 py-2 bg-green-600 text-white font-bold rounded-lg hover:bg-green-500 text-sm sm:text-base">  // 响应式：移动小 padding/字体
                  Send
              </button>
          </form>
      </div>
    </div>
  );
};