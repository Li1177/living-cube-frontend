import { NextPage } from 'next';

const Terms: NextPage = () => (
  <div className="p-8 max-w-4xl mx-auto prose dark:prose-invert">
    <h1>Terms of Service</h1>
    <p>Last updated: October 4, 2025</p>
    <p>By using Living Cube, you agree to these terms. This platform provides interactive 3D digital art wallpapers for download. Payments processed via Paddle. Digital downloads are non-refundable once accessed. We reserve the right to modify terms with notice.</p>
    <h2>1. User Conduct</h2>
    <p>You agree not to misuse the service, including spamming danmaku or uploading harmful content.</p>
    <h2>2. Intellectual Property</h2>
    <p>Downloaded wallpapers are for personal use only. Artists retain rights; do not redistribute.</p>
    <h2>3. Liability</h2>
    <p>We provide the service &quot;as is.&quot; No warranties for interruptions or data loss.</p>  {/* 转义: "as is." → &quot;as is.&quot; */}
    <p>Contact: citywalker1127@gmail.com for questions.</p>
  </div>
);

export default Terms;