// Highlight form in case of it being in focus
$('.form-control').on("focus", function(){
	$('.form-control').parent().css('border-color', '#ee6123');
});

//Open Url In New Tab when Clicked On
$('.t-row').on('dblclick', function(e){
	var url = $(this).find('.link-to').text();
	var win = window.open(url, '_blank');
	// win.focus();
});

//animate the notification bar when an error or success happen during shrtinning the link
if ($('.alert').length) {
	$('.alert').delay(2500).fadeOut(800);	
}



