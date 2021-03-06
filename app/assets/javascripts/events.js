$(document).on('events:loaded', function() {

  bindEvents();

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

$(document).on('events#index:loaded', function(){
  $('#calendar').fullCalendar({
    events: '/organizations/' + organizationId + '/events',
    eventLimit: true,
    // timezone: 'local',  #this displays events in the browsers time zone
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    fixedWeekCount: false,
    dayClick: function(date, jsEvent, view) {
      $('#newEventModal').modal('show');
      setModalDate(date);
    },
  });
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

  $('body').on('keyup', calendarFlip);

  $('.modify-search').on('keyup', modifySearch);
  $('.modify-search').focusin(modifySearch);
  $('.modify-search').focusout(hideResults);
};

var setModalDate = function(date) {
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
};

var addStudent = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var studentId = $(this).attr('data-student-id');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    data: { student_id: studentId },
    type: 'post'
  }).done(function(data) {
    $('#event-show-students').find('.none-added').parent().hide()
    $('#event-show-students').append($(data));
  }).fail(function() {
      console.log('error');
  });
};

var removeStudent = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var studentId = $(this).attr('data-student-id');

  $.ajax({
    url: url,
    data: { student_id: studentId },
    type: 'delete'
  }).done(function(data) {
    if(data.count === 0){
      $('#event-show-students').find('.none-added').parent().show()
    }
    $("a[data-student-id='" + data.studentId + "']").closest("tr").remove();
  }).fail(function() {
      console.log('error');
  });
};

var addRoom = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var roomId = $(this).attr('data-room-id');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    data: { room_id: roomId },
    type: 'post'
  }).done(function(data) {
    $('#event-show-rooms').find('.none-added').parent().hide()
    $('#event-show-rooms').append($(data));
  }).fail(function() {
      console.log('error');
  });
};

var removeRoom = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var roomId = $(this).attr('data-room-id');

  $.ajax({
    url: url,
    data: { room_id: roomId },
    type: 'delete'
  }).done(function(data) {
    if(data.count === 0){
      $('#event-show-rooms').find('.none-added').parent().show()
    }
    $("a[data-room-id='" + data.roomId + "']").closest("tr").remove();
  }).fail(function() {
      console.log('error');
  });
};

var addItem = function(){
  event.preventDefault();

  var quantity = 1;
  if($(this).attr('data-item-disposable') === "true"){
    quantity = prompt("Quantity?", "1");
  }

  var url = $(this).attr('href');
  var itemId = $(this).attr('data-item-id');
  this.closest("tr").remove();

  $.ajax({
    url: url,
    data: { item_id: itemId, quantity: quantity },
    type: 'post'
  }).done(function(data) {
    $('#event-show-items').find('.none-added').parent().hide()
    $('#event-show-items').append($(data));
  }).fail(function() {
      console.log('error');
  });
};

var removeItem = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var itemId = $(this).attr('data-item-id');

  $.ajax({
    url: url,
    data: { item_id: itemId },
    type: 'delete'
  }).done(function(data) {
    if(data.count === 0){
      $('#event-show-items').find('.none-added').parent().show()
    }
    $("a[data-item-id='" + data.itemId + "']").closest("tr").remove();
  }).fail(function() {
      console.log('error');
  });
};

var addCourse = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var courseId = $(this).attr('data-course-id');

  var studentSource = $('#scheduled_student').html();
  var studentTemplate = Handlebars.compile(studentSource);

  var courseSource = $('#scheduled_course').html();
  var courseTemplate = Handlebars.compile(courseSource);

  $.ajax({
    url: url,
    data: { course_id: courseId },
    type: 'post'
  }).done(function(data) {
    $("a[data-course-id='" + data.course.courseId + "']").closest("tr").remove();
    $('#event-show-courses').find('.none-added').parent().hide()
    $('#event-show-courses').append(courseTemplate(data.course));

    for (var i = 0; i < data.students.length; i++) {
      $('#event-show-students').append(studentTemplate(data.students[i]));
    };
  }).fail(function() {
      console.log('error');
  });
};

var removeCourse = function(){
  event.preventDefault();

  var url = $(this).attr('href');
  var courseId = $(this).attr('data-course-id');

  $.ajax({
    url: url,
    data: { course_id: courseId },
    type: 'delete'
  }).done(function(data) {
    if(data.count === 0){
      $('#event-show-courses').find('.none-added').parent().show()
    }

    $("a[data-course-id='" + data.courseId + "']").closest("tr").remove();

    for (var i = 0; i < data.studentIds.length; i++) {
      $("a[data-student-id='" + data.studentIds[i] + "']").closest("tr").remove();
    };
  }).fail(function() {
      console.log('error');
  });
};

var eventSearch = function(){
  var phrase = $(this).val().toLowerCase();
  if (phrase) {
    $.get('events/search', { phrase: phrase }).success(function(payload) {
      $('#events-index').html($(payload));
    });
  } else {
    $.get('events/search').success(function(payload) {
      $('#events-index').html($(payload));
    });
  }
};

var modifySearch = function(event){
  var phrase = $(this).val().toLowerCase();
  var eventId = $(this).attr('id');
  var $current = $('.force-hover');

  if(event.keyCode == 13){
    if($current.next().length !== 0){
      moveHoverDown($current);
    }else if ($current.prev().length !== 0){
      moveHoverUp($current);
    }
    $current.find('a').click();
  }else if(event.keyCode == 40){ // down
    moveHoverDown($current);
  }else if(event.keyCode == 38){ // up
    moveHoverUp($current);
  }else {
    if (phrase) {
      $.get(eventId + '/modify_search', { phrase: phrase }).success(function(payload) {
        $('.search-results table').html($(payload));
        $('.search-results a:first').closest('tr').addClass('force-hover');
        showResults();
      });
    } else {
      $('.search-results table').empty();
      hideResults();
    }
  }
};

var moveHoverDown = function($current) {
  if($current.next().length !== 0){
    $current.removeClass('force-hover');
    $current.closest('tr').next().addClass('force-hover');
  }
};

var moveHoverUp = function($current) {
  if($current.prev().length !== 0){
    $current.removeClass('force-hover');
    $current.closest('tr').prev().addClass('force-hover');
  }
};

var showResults = function() {
  $('.search-results').fadeIn(200);
};

var hideResults = function() {
  $('.search-results').fadeOut(200);
};

var calendarFlip = function() {
  if(event.keyCode == 37){
    $('#calendar').fullCalendar('prev');
  }
  if(event.keyCode == 39){
    $('#calendar').fullCalendar('next');
  }
};