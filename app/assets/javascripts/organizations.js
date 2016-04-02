$(document).on('page:change', function() {

  var data = $('body').data();
  $(document).trigger(data.controller + ':loaded');
  $(document).trigger(data.controller + '#' + data.action + ':loaded');

});

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
};