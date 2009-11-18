$(document).ready(function() {
  
  // Facebox
  $('a[rel*=facebox]').facebox();
    
  // Check all programs
  $('a#check_all').click(function(){
    $('#programs form :checkbox').each(function(){
       $(this).attr('checked', true);
    });
  });

  // Uncheck all programs
  $('a#uncheck_all').click(function(){
    $('#programs form :checkbox').each(function(){
       $(this).attr('checked', false);
    });
  });
  
}); //end document.ready