'use strict';
const assert = require('node:assert');
const { pageSlice } = require('./paginate');

assert.deepStrictEqual(pageSlice([1, 2, 3, 4], 2, 2), [3, 4]);
