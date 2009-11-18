$(document).ready(function(){
  $('li.date input').datepicker({
    showOn: 'both',
    buttonImage: 'images/calendar.png',
    buttonImageOnly: true,
    changeMonth: true,
		changeYear: true
    });
});