$(document).on('page:change', function() {

  var data = $('body').data();
  $(document).trigger(data.controller + ':loaded');
  $(document).trigger(data.controller + '#' + data.action + ':loaded');

});
