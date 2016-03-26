$(document).on('items:loaded', function() {
  $('#item-search').on('keyup', itemSearch);
});

$(document).on('items#show:loaded', function() {
  getItemHeatmapData();
});

var itemSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('items/search', { phrase: phrase }).success(function(payload) {
      $('#items-index').html($(payload));
    });
  } else {
    $.get('items').success(function(payload) {
      $('#items-index').html($(payload));
    });
  }
};

var getItemHeatmapData = function(){
  var heatmapData;
  $.get(itemId + '/heatmap').success(function(payload) {
    initializeHeatmap(payload)
  });
};
