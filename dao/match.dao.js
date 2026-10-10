const db = require('../services/mysql.service');

const insertMatch = async ({ season, homeTeamId, awayTeamId }) => {
  const [res] = await db.query(
    'INSERT INTO `match` (season, home_team_id, away_team_id) VALUES (?, ?, ?)',
    [season, homeTeamId, awayTeamId]
  );
  return res.insertId;
};

const getAll = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM `match`');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getById = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM `match` WHERE id = ?', [req.params.id]);
    if (!rows[0]) return res.status(404).json({ error: 'No encontrado' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = { insertMatch, getAll, getById };