// src/pages/404.js
import Link from 'next/link';

export default function NotFound() {
  return (
    <div style={{ padding: '20px', textAlign: 'center', fontFamily: 'Arial, sans-serif' }}>
      <h1>404 - Page Not Found</h1>
      <p>Sorry, the page you visited does not exist.</p>
      <Link href="/" style={{ color: '#0070f3' }}>Back to Home</Link>
    </div>
  );
}