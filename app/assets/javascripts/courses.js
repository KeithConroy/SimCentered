$(document).on('page:change', function() {

  $("body").on('click', ".add-student-course", addStudentCourse);
  $("body").on('click', ".remove-student-course", removeStudentCourse);
  $('#course-search').on('keyup', courseSearch);

  $('.modify-course-search').on('keyup', modifyCourseSearch);
  $('.modify-course-search').focusin(showResults);
  $('.modify-course-search').focusout(hideResults);

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

var modifyCourseSearch = function(event){
  var phrase = $(this).val().toLowerCase();
  var courseId = $(this).attr('id');

  if(event.keyCode == 13){
    $('.search-results a:first').click();
    // $(this).val('');
  };

  if (phrase) {
    $.get(courseId + '/modify_search/' + phrase).success(function(payload) {
      $('.search-results table').html($(payload));
      // $('.search-results tr:first')
      // add hover to first element
    });
  } else {
    $('.search-results table').empty();
  };
}

var showResults = function() {
  $('.search-results').fadeIn(200);
}

var hideResults = function() {
  $('.search-results').fadeOut(200);
}