$(document).on('page:change', function() {

  $('#room-search').on('keyup', roomSearch);

});

var roomSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('rooms/search/'+phrase).success(function(payload) {
      $('#rooms-index').html($(payload));
    });
  } else {
    $.get('rooms').success(function(payload) {
      $('#rooms-index').html($(payload));
    });
  }
}