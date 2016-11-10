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


function sendRequest(url){
	$.ajax({
					url: '/urls/create',
					type: 'POST',
					dataType: 'json',
					cache: false,
					data: url,
					success: function(data){
						console.log(data);
						// switch(data.status){
						// 	case '208' //Url Already exist

						// 	break;
						// 	case '200' //url was created and saved successfully
						// 	break;
						// 	case '400' //invalid or blank input 

						// }

					},
					error: function(err){
						console.log("ERROR: ");
						console.log(err);
					}
				});
}

// Performing An Ajax Call
$('form').on('submit', function(e){
	e.preventDefault();
	var url = $(this).serialize()
	$url_input = $('#url');
	$submit = $('#submit');

	if ($submit.val() == "COPY" || $submit.val() == "COPIED") {

	}else if ($submit.val() == "SHORTEN") {
		sendRequest(url);
	}
});



















