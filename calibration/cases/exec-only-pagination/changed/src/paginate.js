'use strict';

function pageSlice(items, page, size) {
  return items.slice((page - 1) * size, page * size);
}

// Number of pages needed to show `total` items, `size` per page.
function pageCount(total, size) {
  return Math.floor(total / size);
}

module.exports = { pageSlice, pageCount };
