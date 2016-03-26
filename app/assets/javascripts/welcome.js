$(document).on('welcome:loaded', function() {
  $('body').scrollspy({ target: '.navbar-custom' });

  $(window).scroll(function(){
    var fromTopPx = $(window).height(); // distance to trigger
    var scrolledFromtop = $(window).scrollTop();
    if(scrolledFromtop > fromTopPx){
      $('#welcome').addClass('scrolled');
      $('#welcome').removeClass('doctor');
    }else{
      $('#welcome').addClass('doctor');
      $('#welcome').removeClass('scrolled');
    }
  });
});
