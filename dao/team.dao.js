const db = require('../services/mysql.service');

const findOrCreateTeam = async (name) => {
  const [existing] = await db.query('SELECT id FROM team WHERE name = ?', [name]);
  if (existing.length > 0) return existing[0].id;

  const [result] = await db.query('INSERT INTO team (name) VALUES (?)', [name]);
  return result.insertId;
};

const getAll = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM team');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getById = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM team WHERE id = ?', [req.params.id]);
    if (!rows[0]) return res.status(404).json({ error: 'No encontrado' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = { findOrCreateTeam, getAll, getById };