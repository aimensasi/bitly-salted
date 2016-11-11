// Highlight form in case of it being in focus
$('.form-control').on("focus", function(){
	$('.form-control').parent().css('border-color', '#12504f');
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

//copy to clipboard on click #copy
function copyToClipBoard(){
		var url = document.getElementById('short-url');
		url.focus();
		url.setSelectionRange(0, url.value.length + 1);

		if (url == "" || url == null) { return;}

		try{
			var copy = document.execCommand('copy');
		}catch (e){
			console.log("Exception: " + e);
		}
}

function populateForm(data){
	$('#submit').val('COPY');
	$('#short-url').val(data['short_form']);
	$('#url').text(data['url']);
	$('#short-url-small').text(data['short_form']).attr('href', data['url']); //This Belongs to small panels that appears on success
	$('#counter').text(data['counter']);

	$('#result-panel').css('opacity', '1');
	
	$('#submit, #copy').on('click', function(e){
		copyToClipBoard();
		console.log(e.target.value);
		e.target.value = "COPIED"
	});
}

function displayError(data){
	$alert = $('#notice');
	$alert.find('p').text(data['message']);
	$alert.animate({'top': '0px'}, 1000, function(){
		$alert.delay(2500);
		$alert.animate({'top': '-50px'}, 1000);
	});
}


function sendRequest(url){
	$.ajax({
					url: '/urls/create',
					type: 'POST',
					dataType: 'json',
					cache: false,
					data: url,
					success: function(data){
						switch(data.status){
							case '208': //Url Already exist
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


$('#short-url').on('input', function(e){
	e.preventDefault();
	$('#submit').val('SHORTEN');
});
// Performing An Ajax Call
$('form').on('submit', function(e){
	e.preventDefault();
	var url = $(this).serialize()
	$submit = $('#submit');

	if ($submit.val() == "COPY" || $submit.val() == "COPIED") {
		copyToClipBoard();
	}else if ($submit.val() == "SHORTEN") {
		$('#result-panel').css('opacity', '0');
		sendRequest(url);
	}
});
