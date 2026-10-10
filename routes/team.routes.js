const express = require('express');
const router = express.Router();
const teamDao = require('../dao/team.dao');

router.get('/', teamDao.getAll);
router.get('/:id', teamDao.getById);

module.exports = router;



