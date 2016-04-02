$(document).on('rooms:loaded', function() {
  $('#room-search').on('keyup', roomSearch);
});

$(document).on('rooms#show:loaded', function() {
  getRoomHeatmapData();
});

var roomSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('rooms/search', { phrase: phrase }).success(function(payload) {
      $('#rooms-index').html($(payload));
    });
  } else {
    $.get('rooms').success(function(payload) {
      $('#rooms-index').html($(payload));
    });
  }
};

var getRoomHeatmapData = function(){
  var heatmapData;
  $.get(roomId + '/heatmap').success(function(payload) {
    initializeHeatmap(payload)
  });
};
