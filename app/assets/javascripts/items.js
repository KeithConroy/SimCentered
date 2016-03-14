$(document).on('page:change', function() {

  $('#item-search').on('keyup', itemSearch);
  initializeHeatMap();
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

var initializeHeatMap = function(){
  var heatmapData;
  $.get('items/heatmap', { item_id: itemId }).success(function(payload) {
    heatmapData = payload;
  });
  var cal = new CalHeatMap();
  cal.init({
    data: heatmapData,
  });
};