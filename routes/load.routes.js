const express = require('express');
const path = require('path');
const router = express.Router();
const { runLoad } = require('../services/load.service');

router.post('/', async (req, res) => {
  try {
    const csvPath = path.join(__dirname, '..', 'football_matches.csv');
    const result = await runLoad(csvPath);
    res.json({ mensaje: 'Carga completada', ...result });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;