$(document).on('courses:loaded', function() {

  $("body").on('click', ".add-student-course", addStudentCourse);
  $("body").on('click', ".remove-student-course", removeStudentCourse);

  $('#course-search').on('keyup', courseSearch);

  $('.modify-course-search').on('keyup', modifyCourseSearch);
  $('.modify-course-search').focusout(hideResults);

});

var addStudentCourse = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var studentId = $(this).attr('data-student-id');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    data: { student_id: studentId },
    type: 'post'
  }).done(function(data) {
    $('#scheduled-students').append($(data));
  }).fail(function() {
    console.log('error');
  });
};

var removeStudentCourse = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var studentId = $(this).attr('data-student-id');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    data: { student_id: studentId },
    type: 'delete'
  }).done(function(data) {
    // $('#student-count').text(data.count);
  }).fail(function() {
    console.log('error');
  });
};

var courseSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('courses/search', { phrase: phrase }).success(function(payload) {
      $('#courses-index').html($(payload));
    });
  } else {
    $.get('courses').success(function(payload) {
      $('#courses-index').html($(payload));
    });
  }
};

var modifyCourseSearch = function(event){
  var phrase = $(this).val().toLowerCase();
  var courseId = $(this).attr('id');

  if(event.keyCode == 13){
    $('.search-results a:first').click();
  }

  if (phrase) {
    $.get(courseId + '/modify_search', { phrase: phrase }).success(function(payload) {
      $('.search-results table').html($(payload));
      showResults();
      // $('.search-results tr:first')
      // add hover to first element
    });
  } else {
    $('.search-results table').empty();
    hideResults();
  }
};

var showResults = function() {
  $('.search-results').fadeIn(200);
};

var hideResults = function() {
  $('.search-results').fadeOut(200);
};