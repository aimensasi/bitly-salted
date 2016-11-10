// Highlight form in case of it being in focus
$('.form-control').on("focus", function(){
	$('.form-control').parent().css('border-color', '#ee6123');
});
$('.form-control').on('focusout', function(){
	$('.form-control').parent().css('border-color', 'transparent');
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

//copy to clipboard on click #copy
$('#sub_copy, #copy').on('click', function(e){
		e.preventDefault();
		var short_link = document.getElementById('short_link');
		short_link.focus();
		short_link.setSelectionRange(0, short_link.value.length + 1);

		if (short_link == "" || short_link == null) { return;}

		try{
			var copy = document.execCommand('copy');
				$(this).attr('value', 'COPIED');
		}catch (e){
			console.log("Exception: " + e);
		}
});



