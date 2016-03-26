$(document).on('home:loaded', function() {
  $('body').scrollspy({ target: '.navbar-custom' });

  $(window).scroll(function(){
    var fromTopPx = $(window).height(); // distance to trigger
    var scrolledFromtop = $(window).scrollTop();
    if(scrolledFromtop > fromTopPx && scrolledFromtop < fromTopPx*4){
      $('#home').removeClass();
      $('#home').addClass('middle');
    }else if(scrolledFromtop > fromTopPx*4){
      $('#home').removeClass();
      $('#home').addClass('vitals');
    }else{
      $('#home').removeClass();
      $('#home').addClass('doctor');
    }
  });
});
