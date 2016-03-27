$(document).on('home:loaded', function() {
  $('body').scrollspy({ target: '.navbar-custom' });

  $(window).scroll(function(){
    var fromTopPx = $(window).height(); // distance to trigger
    var scrolledFromtop = $(window).scrollTop();
    if(scrolledFromtop > fromTopPx && scrolledFromtop < fromTopPx*5){
      $('#home').removeClass();
      $('#home').addClass('middle');
    }else if(scrolledFromtop > fromTopPx*5){
      $('#home').removeClass();
      $('#home').addClass('vitals');
    }else{
      $('#home').removeClass();
      $('#home').addClass('doctor');
    }
  });

  $('.centered').hide();
  setTimeout(function() {
    $('.simplify').fadeIn(1000);
  },500);

  setTimeout(function() {
    $('.simplify').fadeOut(1000);
    setTimeout(function(){
      $('.simulation').fadeIn(1000);
    },1000);
    setTimeout(function(){
      $('.simulation').fadeOut(1000);
    },2500);
    setTimeout(function(){
      $('.centered').fadeIn(1000);
    },3500);
  },2000);

});
