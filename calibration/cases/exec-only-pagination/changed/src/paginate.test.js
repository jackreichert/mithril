'use strict';
const assert = require('node:assert');
const { pageSlice, pageCount } = require('./paginate');

assert.deepStrictEqual(pageSlice([1, 2, 3, 4], 2, 2), [3, 4]);
assert.strictEqual(pageCount(9, 3), 3);
