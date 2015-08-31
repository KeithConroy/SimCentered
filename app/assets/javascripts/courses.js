$(document).on('page:change', function() {

  $("body").on('click', ".add-student-course", addStudentCourse);
  $("body").on('click', ".remove-student-course", removeStudentCourse);
  $('#course-search').on('keyup', courseSearch);

});

var addStudentCourse = function(){
  event.preventDefault();
  debugger
  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'post'
  }).done(function(data) {
    $('#student-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}

var removeStudentCourse = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'delete'
  }).done(function(data) {
    $('#student-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}

var courseSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('courses/search/'+phrase).success(function(payload) {
      $('#courses-index').html($(payload));
    });
  } else {
    $.get('courses').success(function(payload) {
      $('#courses-index').html($(payload));
    });
  }
}