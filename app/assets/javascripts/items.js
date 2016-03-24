$(document).on('items:loaded', function() {
  $('#item-search').on('keyup', itemSearch);
});

$(document).on('items#show:loaded', function() {
  getHeatmapData();
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

var getHeatmapData = function(){
  var heatmapData;
  $.get(itemId + '/heatmap').success(function(payload) {
    initializeHeatmap(payload)
  });
};

var initializeHeatmap = function(heatmap) {
  var cal = new CalHeatMap();
  var date = new Date();
  date.setMonth(date.getMonth() - 5);
  cal.init({
    domain: "month",
    subDomain: "x_day",
    domainGutter: 15,
    domainDynamicDimension: false,
    weekStartOnMonday: false,
    data: heatmap.data,
    start: date,
    highlight: "now",
    itemName: heatmap.name,
    cellSize: 15,
    cellRadius: 2,
    range: 6,
    legendHorizontalPosition: "right",
    legend: heatmap.legend,
    label: {
      position: "top"
    }
  });
}