// 文件路径: D:\Projects\living-cube-frontend\src\components\DanmakuOverlay.js
import React, { useState } from 'react';

// 这是一个独立的 CSS 样式块，专门用于弹幕的滚动动画
// 我们将它直接放在文件里，方便您复制
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
const DanmakuTrackItem = ({ message }) => {
  // 每条弹幕的持续时间随机，看起来更自然
  const duration = Math.random() * 5 + 8; // 8到13秒
  // 每条弹幕的垂直位置随机
  const topPosition = Math.random() * 70 + 5; // 5% 到 75% 之间

  return (
    <div
      className="absolute whitespace-nowrap text-white text-2xl font-bold"
      style={{
        top: `${topPosition}%`,
        right: 0, // 从右边开始
        // 应用 CSS 动画
        animation: `danmaku-scroll ${duration}s linear`,
        // 描边效果，增强可读性
        textShadow: '1px 1px 2px black, -1px -1px 2px black, 1px -1px 2px black, -1px 1px 2px black',
      }}
    >
      {message}
    </div>
  );
};

// 整个 2D 界面的主组件
export const DanmakuOverlay = ({ mediaItem, danmakuList, onDanmakuSubmit }) => {
  const [danmakuInput, setDanmakuInput] = useState('');
  const [purchaseState, setPurchaseState] = useState('idle');
    
  const handlePurchase = async () => {
      setPurchaseState('pending');
      try {
          const response = await fetch('/api/create-payment', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ mediaId: mediaItem.id }),
          });
          const data = await response.json();
          if (!response.ok) throw new Error(data.message || 'Failed to create payment');
          if (data.paymentUrl) window.location.href = data.paymentUrl;
      } catch (error) {
          setPurchaseState('error');
      }
  };

  const handleSubmit = (e) => {
      e.preventDefault();
      if (!danmakuInput.trim()) return;
      onDanmakuSubmit(danmakuInput);
      setDanmakuInput('');
  };
  
  const buttonText = {
      idle: 'Unlock for $0.99',
      pending: 'Redirecting...',
      error: 'Payment Failed, Retry'
  }[purchaseState];

  return (
    // 这个主容器是我们的“玻璃”，它覆盖整个屏幕
    // pointer-events-none 确保它不会拦截对底下 3D Canvas 的鼠标操作
    <div className="absolute top-0 left-0 w-full h-full pointer-events-none">
      {/* 注入我们定义的动画 */}
      <style>{danmakuAnimation}</style>
      
      {/* 这是弹幕滚动的轨道区域 */}
      <div className="relative w-full h-full overflow-hidden">
        {danmakuList.map((danmaku) => (
          <DanmakuTrackItem key={danmaku.id} message={danmaku.message} />
        ))}
      </div>

      {/* 这是底部的操作 UI 区域 */}
      {/* pointer-events-auto 让这个区域可以响应鼠标点击 */}
      <div className="absolute bottom-5 left-1/2 -translate-x-1/2 z-50 flex flex-col items-center gap-4 pointer-events-auto">
          <button
              onClick={handlePurchase}
              disabled={purchaseState !== 'idle' && purchaseState !== 'error'}
              className="px-6 py-2 bg-blue-600 text-white font-bold rounded-lg shadow-lg hover:bg-blue-500 active:bg-blue-700 transition-colors disabled:opacity-50"
          >
              {buttonText}
          </button>
          <form onSubmit={handleSubmit} className="flex gap-2">
              <input
                  type="text"
                  value={danmakuInput}
                  onChange={(e) => setDanmakuInput(e.target.value)}
                  placeholder="Post a comment..."
                  className="w-64 px-4 py-2 bg-gray-800 bg-opacity-80 text-white rounded-lg border border-gray-600 focus:outline-none focus:border-blue-500"
              />
              <button type="submit" className="px-4 py-2 bg-green-600 text-white font-bold rounded-lg hover:bg-green-500">
                  Send
              </button>
          </form>
      </div>
    </div>
  );
};