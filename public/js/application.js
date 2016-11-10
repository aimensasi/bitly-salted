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
function copyToClipBoard(){
		var url = document.getElementById('short-url');
		console.log(url);
		url.focus();
		url.setSelectionRange(0, url.value.length + 1);

		if (url == "" || url == null) { return;}

		try{
			var copy = document.execCommand('copy');
				$(this).attr('value', 'COPIED');
		}catch (e){
			console.log("Exception: " + e);
		}
}

function populateForm(data){
	$urlInput = $('#short-url').val(data['short_form']);
	$submit = $('#submit').val('COPIED');
	$copyBtn = $('#copy');
	$shortUrl = $('#url').text(data['url']);
	$SubshortUrl = $('#sub-short-url').text(data['short_form']); //This Belongs to small panels that appears on success
	$counter = $('#counter').text(data['counter']);

	$('#result-panel').css('opacity', '1');
	$copyBtn.on('click', function(){
		copyToClipBoard();
		$copyBtn.val('COPIED');
	});
}

function displayError(data){

}


function sendRequest(url){
	$.ajax({
					url: '/urls/create',
					type: 'POST',
					dataType: 'json',
					cache: false,
					data: url,
					success: function(data){
						console.log(data);
						switch(data.status){
							case '208': //Url Already exist
								console.log(data);
								populateForm(data);
							break;
							case '200': //url was created and saved successfully
								populateForm(data);
							break;
							case '400': //invalid or blank input 
								displayError(data);
						}

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
	$submit = $('#submit');

	if ($submit.val() == "COPY" || $submit.val() == "COPIED") {
		copyToClipBoard();
	}else if ($submit.val() == "SHORTEN") {
		sendRequest(url);
	}
});



















