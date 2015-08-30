$(document).on('page:change', function() {

  bindEvents();
  $("body").on('click', ".add-course", addCourse);
  $("body").on('click', ".remove-course", removeCourse);

  $("body").on('click', ".add-student", addStudent);
  $("body").on('click', ".remove-student", removeStudent);

  $("body").on('click', ".add-room", addRoom);
  $("body").on('click', ".remove-room", removeRoom);

  $("body").on('click', ".add-item", addItem);
  $("body").on('click', ".remove-item", removeItem);

  $(".clicker").on("click", function(){
    $(this).next().slideToggle();
  });

  $('#calendar').fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    dayClick: function(date, jsEvent, view) {

        alert('Clicked on: ' + date.format() +
          '; Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY +
          '; Current view: ' + view.name);

    },
    eventLimit: true,
        // put your options and callbacks here
    events: '/events'
  })

  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })
});

var bindEvents = function(){
  $('body').on('click', '#schedule-students', showStudentSelector);
  $('body').on('click', '#schedule-rooms', showRoomSelector);
  $('body').on('click', '#schedule-items', showItemSelector);
}

var showStudentSelector = function(){
  event.preventDefault();
  hideAll();
  $('#student-selector').show();
  $('#selected-students').show();
  $('body').on('click', '#schedule-students', showOnlySelected);
}

var showRoomSelector = function(){
  event.preventDefault();
  hideAll();
  $('#room-selector').show();
  $('#selected-rooms').show();
  $('body').on('click', '#schedule-rooms', showOnlySelected);
}

var showItemSelector = function(){
  event.preventDefault();
  hideAll();
  $('#item-selector').show();
  $('#selected-items').show();
  $('body').on('click', '#schedule-items', showOnlySelected);
}

var showOnlySelected = function(){
  event.preventDefault();

  bindEvents();

  $('#student-selector').hide();
  $('#room-selector').hide();
  $('#item-selector').hide();

  $('#selected-students').show();
  $('#selected-rooms').show();
  $('#selected-items').show();
}

var hideAll = function(){
  event.preventDefault();

  $('#student-selector').hide();
  $('#room-selector').hide();
  $('#item-selector').hide();

  $('#selected-students').hide();
  $('#selected-rooms').hide();
  $('#selected-items').hide();
}

var addStudent = function(){
  event.preventDefault();

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

var removeStudent = function(){
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

var addRoom = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'post'
  }).done(function(data) {
    $('#room-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}

var removeRoom = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'delete'
  }).done(function(data) {
    $('#room-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}

var addItem = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'post'
  }).done(function(data) {
    $('#item-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}

var removeItem = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'delete'
  }).done(function(data) {
    $('#item-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}

var addCourse = function(){
  event.preventDefault();

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

var removeCourse = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'delete'
  }).done(function(data) {
    // $('#Course-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}