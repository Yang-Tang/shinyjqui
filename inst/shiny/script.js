$(function(){

  var en = ['shiny:bound', 'shiny:value', 'shiny:recalculating',
  'shiny:recalculated', 'shiny:visualchange'];

  $.each(en, function(i, v){
    $('#p').on(v, function(e){
      console.log(v);
      console.log($('#p').attr('class'));
      console.log($('#p').children());
    });
  });



});
