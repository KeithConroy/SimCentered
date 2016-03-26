$(document).on('welcome:loaded', function() {
  $('body').scrollspy({ target: '.navbar-custom' });

  $(window).scroll(function(){
    var fromTopPx = $(window).height(); // distance to trigger
    var scrolledFromtop = $(window).scrollTop();
    if(scrolledFromtop > fromTopPx && scrolledFromtop < fromTopPx*4){
      $('#welcome').removeClass();
      $('#welcome').addClass('middle');
    }else if(scrolledFromtop > fromTopPx*4){
      $('#welcome').removeClass();
      $('#welcome').addClass('vitals');
    }else{
      $('#welcome').removeClass();
      $('#welcome').addClass('doctor');
    }
  });
});
