const db = require('../services/mysql.service');

const insertStats = async ({ matchId, teamId, goals, possession, shotsOnTarget, redCards }) => {
  await db.query(
    'INSERT INTO team_match_stats (match_id, team_id, goals, possession, shots_on_target, red_cards) VALUES (?, ?, ?, ?, ?, ?)',
    [matchId, teamId, goals, possession, shotsOnTarget, redCards]
  );
};

const getAll = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM team_match_stats');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getById = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM team_match_stats WHERE id = ?', [req.params.id]);
    if (!rows[0]) return res.status(404).json({ error: 'No encontrado' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = { insertStats, getAll, getById };