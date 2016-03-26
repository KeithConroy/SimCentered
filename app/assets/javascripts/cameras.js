$(document).on('cameras:loaded', function() {
  $('#camera-search').on('keyup', cameraSearch);
});

var cameraSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('cameras/search', { phrase: phrase }).success(function(payload) {
      $('#cameras-index').html($(payload));
    });
  } else {
    $.get('cameras').success(function(payload) {
      $('#cameras-index').html($(payload));
    });
  }
};