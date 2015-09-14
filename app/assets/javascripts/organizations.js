$(document).on('page:change', function() {

  $('.header-edit').on('click', showEditHeaderForm);
  $('form.edit').on('submit', submit);

});

var showEditHeaderForm = function() {
  // debugger
  $('.header-edit').hide();
  var input = $('.header-edit-form').find('input');
  var tmpStr = input.val();
  input.val('');
  input.val(tmpStr);

  $('.header-edit-form').show();
  input.focus();

  input.focusout(function() {
    $('.header-edit-form').hide();
    $('.header-edit').show();
  })
}

var submit = function() {
  event.preventDefault();

  var url = $(this).attr('action');
  var data = $(this).serialize();

  $.ajax({
    url: url,
    type: 'put',
    data: data
  }).done(function(data) {
    $('.header-edit')
      .text(data['title'])
      .show();
    $('.header-edit-form').hide();
  }).fail(function() {
    console.log('error');
  });

}
