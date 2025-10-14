// 文件路径: src/components/ChoiceModal.tsx
import React, { useState } from 'react';
import { useAppStore } from '../lib/store';
import { useSession } from 'next-auth/react';

export const ChoiceModal = () => {
  const { isChoiceModalOpen, itemToPurchase, closeChoiceModal } = useAppStore();
  const { data: session } = useSession();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!isChoiceModalOpen || !itemToPurchase) {
    return null;
  }

  const handleConfirmPurchase = async () => {
    if (!session?.user?.id) {
      setError('您必须登录才能完成购买。');
      return;
    }
    
    setIsLoading(true);
    setError(null);

    try {
      const response = await fetch('/api/create-payment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          wallpaper_id: itemToPurchase.id,
          user_id: session.user.id,
        }),
      });

      const data = await response.json();
      if (!response.ok) {
        throw new Error(data.message || '创建支付失败。');
      }

      window.Paddle.Checkout.open({
        transactionId: data.transactionId,
      });
      closeChoiceModal();

    } catch (err: any) {
      console.error('Purchase confirmation error:', err);
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  const priceInDollars = itemToPurchase.price_cents ? (itemToPurchase.price_cents / 100).toFixed(2) : '0.99';

  return (
    <div className="fixed inset-0 bg-black bg-opacity-70 z-50 flex justify-center items-center pointer-events-auto">
      <div className="bg-gray-800 rounded-lg shadow-xl p-6 w-11/12 max-w-sm text-white">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-bold">解锁数字艺术品</h2>
          <button onClick={closeChoiceModal} className="text-gray-400 hover:text-white text-2xl">&times;</button>
        </div>
        
        <div className="mb-6">
          <p className="text-gray-300">您即将购买:</p>
          <p className="text-lg font-semibold">{itemToPurchase.name || '高清数字壁纸'}</p>
        </div>

        {error && <p className="text-red-500 text-sm mb-4">{error}</p>}
        
        <button
          onClick={handleConfirmPurchase}
          disabled={isLoading}
          className="w-full px-4 py-3 bg-blue-600 text-white font-bold rounded-lg shadow-lg hover:bg-blue-500 active:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {isLoading ? '处理中...' : `确认支付 $${priceInDollars}`}
        </button>
      </div>
    </div>
  );
};