// 文件路径: src/components/DanmakuOverlay.js
import React, { useState } from 'react';
import { useAppStore } from '../lib/store';
import { ChoiceModal } from './ChoiceModal';

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

const DanmakuTrackItem = ({ content }) => {
  const duration = Math.random() * 5 + 8;
  const topPosition = Math.random() * 70 + 5;
  return (
    <div
      className="absolute whitespace-nowrap text-white text-xl sm:text-2xl font-bold"
      style={{
        top: `${topPosition}%`, right: 0, animation: `danmaku-scroll ${duration}s linear`,
        textShadow: '1px 1px 2px black, -1px -1px 2px black, 1px -1px 2px black, -1px 1px 2px black',
      }}
    >{content}</div>
  );
};

export const DanmakuOverlay = ({ mediaItem, danmakuList, onDanmakuSubmit }) => {
  const [danmakuInput, setDanmakuInput] = useState('');
  const openChoiceModal = useAppStore((state) => state.openChoiceModal);

  const handlePurchaseClick = () => {
      if (openChoiceModal) {
        openChoiceModal(mediaItem);
      } else {
        console.error("Zustand store has not hydrated the 'openChoiceModal' action yet.");
      }
  };

  const handleSubmit = (e) => {
      e.preventDefault();
      if (!danmakuInput.trim()) return;
      onDanmakuSubmit(danmakuInput);
      setDanmakuInput('');
  };
  
  const priceInDollars = mediaItem?.price_cents ? (mediaItem.price_cents / 100).toFixed(2) : '0.99';

  return (
    <>
      <ChoiceModal />
      <div className="absolute top-0 left-0 w-full h-full pointer-events-none">
        <style>{danmakuAnimation}</style>
        <div className="relative w-full h-full overflow-hidden">
          {danmakuList.map((danmaku, index) => (
            <DanmakuTrackItem key={danmaku.id || index} content={danmaku.content} />
          ))}
        </div>
        <div className="absolute bottom-5 left-1/2 -translate-x-1/2 z-40 flex flex-col items-center gap-4 pointer-events-auto p-2 sm-p-4 w-full max-w-md mx-auto">
            <button
                onClick={handlePurchaseClick}
                disabled={!openChoiceModal}
                className="px-3 py-2 w-full bg-blue-600 text-white font-bold rounded-lg shadow-lg hover:bg-blue-500 active:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-wait text-sm sm-text-base"
            >
                {`Unlock for $${priceInDollars}`}
            </button>
            <form onSubmit={handleSubmit} className="flex flex-col sm:flex-row gap-2 w-full">
                <input
                    type="text"
                    value={danmakuInput}
                    onChange={(e) => setDanmakuInput(e.target.value)}
                    placeholder="Send a comment..."
                    maxLength={50}
                    className="w-full px-2 py-2 bg-gray-800 bg-opacity-80 text-white rounded-lg border border-gray-600 focus:outline-none focus:border-blue-500 text-sm sm:text-base"
                />
                <button type="submit" className="px-3 py-2 bg-green-600 text-white font-bold rounded-lg hover:bg-green-500 text-sm sm:text-base">
                    Send
                </button> 
            </form>
        </div>
      </div>
    </>
  );
};