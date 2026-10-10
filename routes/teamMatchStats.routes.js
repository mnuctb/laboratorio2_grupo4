const express = require('express');
const router = express.Router();
const statsDao = require('../dao/teamMatchStats.dao');

router.get('/', statsDao.getAll);
router.get('/:id', statsDao.getById);

module.exports = router;