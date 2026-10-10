const fs = require('fs');
const csv = require('csv-parser');
const teamDao = require('../dao/team.dao');
const matchDao = require('../dao/match.dao');
const statsDao = require('../dao/teamMatchStats.dao');

const readCsvRows = (path) => {
  return new Promise((resolve, reject) => {
    const rows = [];
    fs.createReadStream(path)
      .pipe(csv())
      .on('data', (row) => rows.push(row))
      .on('end', () => resolve(rows))
      .on('error', reject);
  });
};

const runLoad = async (csvPath) => {
  const rows = await readCsvRows(csvPath);
  console.log(`Leídas ${rows.length} filas del CSV.`);

  let ok = 0;
  let failed = 0;

  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    try {
      const homeTeamId = await teamDao.findOrCreateTeam(row.home_team);
      const awayTeamId = await teamDao.findOrCreateTeam(row.away_team);

     const matchId = await matchDao.insertMatch({
        season: row.season,
        homeTeamId,
        awayTeamId,
      });

      await statsDao.insertStats({
        matchId,
        teamId: homeTeamId,
        goals: parseInt(row.goal_home_ft, 10),
        possession: parseFloat(row.home_possession),
        shotsOnTarget: parseInt(row.home_shots_on_target, 10),
        redCards: parseInt(row.home_red_cards, 10),
      });

      await statsDao.insertStats({
        matchId,
        teamId: awayTeamId,
        goals: parseInt(row.goal_away_ft, 10),
        possession: parseFloat(row.away_possession),
        shotsOnTarget: parseInt(row.away_shots_on_target, 10),
        redCards: parseInt(row.away_red_cards, 10),
      });

      ok++;
    } catch (err) {
      failed++;
      console.error(`Fila ${i} (CSV id=${row.X}) falló: ${err.code || err.message}`);
    }
  }

  console.log(`Carga terminada. OK: ${ok}, fallidas: ${failed}`);
  return { ok, failed };
};

module.exports = { runLoad };