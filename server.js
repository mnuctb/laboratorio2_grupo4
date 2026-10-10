const express = require('express');
const teamRoutes = require('./routes/team.routes');
const matchRoutes = require('./routes/match.routes');
const statsRoutes = require('./routes/teamMatchStats.routes');
const loadRoutes = require('./routes/load.routes');

const PORT = 5000;
const api = express();

api.use(express.json());
api.use(express.static('public'));

api.use('/team', teamRoutes);
api.use('/match', matchRoutes);
api.use('/stats', statsRoutes);
api.use('/load', loadRoutes);

api.listen(PORT, () => {
  console.log('Servidor corriendo en http://localhost:5000');
});