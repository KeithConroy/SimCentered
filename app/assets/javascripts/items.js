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
    // heatmapData = payload;
    // console.log(payload);
    initializeHeatmap(payload)
  });
  // var cal = new CalHeatMap();
  // cal.init({
  //   domain: "year",
  //   subDomain: "day",
  //   data: heatmapData,
  //   cellSize: 10,
  //   range: 1,
  //   // legend: [20, 40, 60, 80]
  // });
};

var initializeHeatmap = function(heatmap) {
  var cal = new CalHeatMap();
  cal.init({
    domain: "year",
    subDomain: "day",
    weekStartOnMonday: false,
    data: heatmap.data,
    itemName: heatmap.name,
    cellSize: 10,
    range: 1,
    legendHorizontalPosition: "right",
    legendMargin: [-10, 0, 0, 0],
    // legendColors: {
    //   min: "#E9EAED",
    //   max: "#0096b5",
    //   empty: "white",
    //   base: "white",
    // },
    // legendColors: ["#E9EAED", "#0096b5"],
    // legend: [20, 40, 60, 80]
  });
}