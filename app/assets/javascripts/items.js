$(document).on('page:change', function() {

  $('#item-search').on('keyup', itemSearch);

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