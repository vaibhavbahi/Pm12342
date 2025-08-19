<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin Panel - Key Manager</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(135deg, #1e3c72, #2a5298);
      color: #fff;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      padding: 20px;
    }

    .container {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(20px);
      border-radius: 20px;
      padding: 30px;
      width: 100%;
      max-width: 600px;
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
      animation: fadeIn 0.5s ease-in-out;
    }

    h2 {
      text-align: center;
      margin-bottom: 25px;
      font-weight: 600;
      font-size: 26px;
    }

    input, select, button {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border-radius: 10px;
      border: none;
      font-size: 16px;
      outline: none;
    }

    input, select {
      background: rgba(255, 255, 255, 0.15);
      color: #fff;
    }

    input::placeholder {
      color: #ccc;
    }

    button {
      background: #ff9800;
      color: white;
      font-weight: 600;
      transition: background 0.3s;
      cursor: pointer;
    }

    button:hover {
      background: #e68900;
    }

    .key-item {
      background: rgba(0, 0, 0, 0.3);
      padding: 15px;
      margin-top: 12px;
      border-radius: 12px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      animation: fadeIn 0.3s ease-in-out;
    }

    .key-item b {
      font-size: 16px;
    }

    .expired {
      color: #ff4c4c;
      font-weight: bold;
    }

    .copy-btn {
      background: #2196F3;
      margin-left: 5px;
    }

    .copy-btn:hover {
      background: #1976D2;
    }

    .key-actions button {
      margin-left: 5px;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 600px) {
      .key-item {
        flex-direction: column;
        align-items: flex-start;
      }
      .key-actions {
        margin-top: 10px;
        width: 100%;
        display: flex;
        justify-content: flex-end;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>🔑 Admin Key Manager</h2>
    <input type="text" id="customKey" placeholder="Enter custom key">
    <select id="duration">
      <option value="30">30 Minutes</option>
      <option value="60">1 Hour</option>
      <option value="180">3 Hours</option>
      <option value="1440">1 Day</option>
      <option value="4320">3 Days</option>
      <option value="10080">7 Days</option>
      <option value="43200">1 Month</option>
      <option value="129600">3 Months</option>
      <option value="0">Permanent</option>
    </select>
    <button onclick="generateKey()">➕ Generate Key</button>

    <h3 style="margin-top: 25px;">🗂️ Generated Keys</h3>
    <div id="keys"></div>
  </div>

  <script>
    function loadKeys() {
      const keys = JSON.parse(localStorage.getItem("keys")) || [];
      const container = document.getElementById("keys");
      container.innerHTML = "";
      const now = Date.now();

      keys.forEach((k, i) => {
        const expired = k.expiry !== 0 && now > k.expiry;
        const expText = k.expiry === 0 ? "Permanent" :
          expired ? "Expired" : new Date(k.expiry).toLocaleString();

        container.innerHTML += `
          <div class="key-item">
            <div>
              <b>${k.key}</b><br>

<small>Expiry: <span class="${expired ? 'expired' : ''}">${expText}</span></small>
            </div>
            <div class="key-actions">
              <button class="copy-btn" onclick="copyKey('${k.key}')">📋</button>
              <button onclick="deleteKey(${i})">❌</button>
            </div>
          </div>
        `;
      });
    }

    function generateKey() {
      const custom = document.getElementById("customKey").value.trim();
      const duration = parseInt(document.getElementById("duration").value);
      const expiry = duration === 0 ? 0 : Date.now() + duration * 60000;
      const newKey = custom || ("KEY-" + Math.random().toString(36).substring(2, 8).toUpperCase());

      let keys = JSON.parse(localStorage.getItem("keys")) || [];

      // Check for duplicates
      if (keys.some(k => k.key === newKey)) {
        alert("Key already exists!");
        return;
      }

      keys.push({ key: newKey, expiry: expiry });
      localStorage.setItem("keys", JSON.stringify(keys));
      document.getElementById("customKey").value = "";
      loadKeys();
    }

    function deleteKey(i) {
      let keys = JSON.parse(localStorage.getItem("keys")) || [];
      keys.splice(i, 1);
      localStorage.setItem("keys", JSON.stringify(keys));
      loadKeys();
    }

    function copyKey(key) {
      navigator.clipboard.writeText(key).then(() => {
        alert("Copied: " + key);
      });
    }

    loadKeys();
  </script>
</body>
</html>
