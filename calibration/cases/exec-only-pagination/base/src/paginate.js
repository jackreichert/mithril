'use strict';

function pageSlice(items, page, size) {
  return items.slice((page - 1) * size, page * size);
}

module.exports = { pageSlice };
