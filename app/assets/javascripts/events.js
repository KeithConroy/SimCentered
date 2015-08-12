$(document).on('page:change', function() {

  bindEvents();

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