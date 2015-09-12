$(document).on('page:change', function() {

  bindEvents();

  // $(".clicker").on("click", function(){
  //   $(this).next().slideToggle();
  // });

  $('#calendar').fullCalendar({
    events: '/organizations/1/events',
    eventLimit: true,
    // timezone: 'local',  #this displays events in the browsers time zone
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    dayClick: function(date, jsEvent, view) {
      $('#newEventModal').modal('show');

      var day = date.format('D');
      var month = date.format('M');
      var year = date.format('YYYY');
      var hour = date.format('HH');
      var minute = date.format('mm');

      $('#event_start_3i option[value="'+ day +'"]').prop('selected', true);
      $('#event_start_2i option[value="'+ month +'"]').prop('selected', true);
      $('#event_start_1i option[value="'+ year +'"]').prop('selected', true);
      $('#event_start_4i option[value="'+ hour +'"]').prop('selected', true);
      $('#event_start_5i option[value="'+ minute +'"]').prop('selected', true);

      $('#event_finish_3i option[value="'+ day +'"]').prop('selected', true);
      $('#event_finish_2i option[value="'+ month +'"]').prop('selected', true);
      $('#event_finish_1i option[value="'+ year +'"]').prop('selected', true);
      $('#event_finish_4i option[value="'+ hour +'"]').prop('selected', true);
      $('#event_finish_5i option[value="'+ minute +'"]').prop('selected', true);
    },
  })

  $(function () {
    $('[data-toggle="tooltip"]').tooltip();
  })

  $('#newEventModal').on('hidden.bs.modal', function(){
    $(this).find('form')[0].reset();
  });

  // $('#deleteEventModal').on('show.bs.modal', function (event) {
  //   var button = $(event.relatedTarget)
  //   var title = button.data('event-title')
  //   var id = button.data('event-id')
  //   var modal = $(this)
  //   // modal.find('.modal-title').text('Delete ' + title)
  //   modal.find('.modal-body').text('Are you sure you want to delete the event: ' + title + '?')
  // });

});

var bindEvents = function(){
  $("body").on('click', ".add-course", addCourse);
  $("body").on('click', ".remove-course", removeCourse);

  $("body").on('click', ".add-student", addStudent);
  $("body").on('click', ".remove-student", removeStudent);

  $("body").on('click', ".add-room", addRoom);
  $("body").on('click', ".remove-room", removeRoom);

  $("body").on('click', ".add-item", addItem);
  $("body").on('click', ".remove-item", removeItem);

  $('#event-search').on('keyup', eventSearch);

  $('.modify-search').on('keyup', modifySearch);
  $('.modify-search').focusin(showResults);
  $('.modify-search').focusout(hideResults);
}

var addStudent = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'post'
  }).done(function(data) {
    $('#scheduled-students').html($(data));
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
    // $('#available-students').html($(data));
    // $('#student-count').text(data.count);
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
    $('#scheduled-rooms').html($(data));
    // $('#room-count').text(data.count);
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
    // $('#available-rooms').html($(data));
    // $('#room-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}

var addItem = function(){
  event.preventDefault();

  alert('Quantity?')

  var url = $(this).attr('href');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'post'
  }).done(function(data) {
    $('#scheduled-items').html($(data));
    // $('#item-count').text(data.count);
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
    // $('#available-items').html($(data));
    // $('#item-count').text(data.count);
  }).fail(function() {
      console.log('error');
  });
}

var addCourse = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  // this.closest("tr").remove();

  $.ajax({
    url: url,
    type: 'post'
  }).done(function(data) {
    $('#scheduled-students').html($(data));
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

var eventSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('events/search/'+phrase).success(function(payload) {
      $('#events-index').html($(payload));
    });
  } else {
    $.get('events/search/`').success(function(payload) {
      $('#events-index').html($(payload));
    });
  }
}

var modifySearch = function(event){
  var phrase = $(this).val().toLowerCase();
  var eventId = $(this).attr('id');

  if(event.keyCode == 13){
    $('.search-results a:first').click();
    // $(this).val('');
  };

  if (phrase) {
    $.get(eventId + '/modify_search/' + phrase).success(function(payload) {
      $('.search-results').html($(payload));
      // $('.search-results tr:first')
      // add hover to first element
    });
  } else {
    $('.search-results').empty();
  };
}

var showResults = function() {
  $('.search-results').fadeIn(200);
}

var hideResults = function() {
  $('.search-results').fadeOut(200);
}