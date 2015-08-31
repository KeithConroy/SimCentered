$(document).on('page:change', function() {

  $('#user-search').on('keyup', userSearch);

});

var userSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('users/search/'+phrase).success(function(payload) {
      $('#users-index').html($(payload));
    });
  } else {
    $.get('users').success(function(payload) {
      $('#users-index').html($(payload));
    });
  }
}