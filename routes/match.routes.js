const express = require('express');
const router = express.Router();
const matchDao = require('../dao/match.dao');

router.get('/', matchDao.getAll);
router.get('/:id', matchDao.getById);

module.exports = router;