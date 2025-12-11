// ~/projects/emc-portal/app/server.js
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.static('public'));

app.get('/api/status', (req, res) => {
  res.json({ service: "EMC Portal", status: "ok", timestamp: new Date().toISOString() });
});

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

app.listen(port, () => {
  console.log(`EMC Portal listening on port ${port}`);
});
