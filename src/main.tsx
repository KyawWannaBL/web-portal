import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

const root = document.getElementById('root');
if (root) {
  try {
    ReactDOM.createRoot(root).render(
      <React.StrictMode>
        <App />
      </React.StrictMode>
    );
  } catch (error) {
    root.innerHTML = `<div style="background:#000;color:#ef4444;padding:40px;font-family:sans-serif;">
      <h1>SYSTEM_BOOT_FAILURE</h1>
      <p>${error}</p>
      <button onclick="location.reload()" style="background:#ef4444;color:#fff;border:none;padding:10px 20px;border-radius:8px;">RETRY_LAUNCH</button>
    </div>`;
  }
}
