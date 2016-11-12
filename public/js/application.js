
const SHORTEN = "SHORTEN";
const COPY = "COPY";
const COPIED = "COPIED";
const $submit = $('#submit');
const $urlInput = $('#url-input');


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

//On Sunmiting the form
$('#submit').on('click', function(e){
	e.preventDefault();

	if ($submit.val().trim() === SHORTEN) {
		// hide result panel
		$('#result-panel').css('opacity', '0');
		// check if input has value
		if ($.trim($urlInput.val()) === null || $.trim($urlInput.val()) === "") {
			// display error message
			displayError({message: "Url Can't Be Empty"}) 
		}else{
			// send an Ajax Post request
			sendPostRequest($('form').serialize());	
		}
		
	}else{
		if ($submit.val().trim() == COPY) {
			$submit.val(COPIED);
		}
		copyToClipBoard();
	}

});


// triggered when a new input is givien
$urlInput.on('input', function(e){
	e.preventDefault();
	$submit.val(SHORTEN);
});

// triggered When clicking on the small copy button
$('#copy').on('click', function(e){
			e.preventDefault();
			$(this).val(COPIED);
			copyToClipBoard();
	});

//copy to clipboard on click #copy
function copyToClipBoard(){
		var url = $urlInput.get(0);
		url.focus();
		url.setSelectionRange(0, url.value.length + 1);

		if (url == "" || url == null) { return;}

		try{
			var copy = document.execCommand('copy');
		}catch (e){
			console.log("Exception: " + e);
		}
}

// Use the given data to populate the form
function populateForm(data){
	$submit.val(COPY);
	$urlInput.val(data['short_form']);
	$('#url-text').text(data['url']);
	$('#short-url-text').text(data['short_form']).attr('href', data['short_form']); //This Belongs to small panels that appears on success
	$('#counter').text(data['counter']);

	$('#result-panel').css('opacity', '1');
	sendGetRequest();
}


function populateTable(data){
	// console.log(data);
	$tableBody = $('#tbody');
	$tableBody.empty();
	$.each(data, function(index, value){
		var row = '<tr class="t-row">';
				row += '<td>' + (index + 1) + '</td>';
				row += '<td>' + value['url'] + '</td>';
				row += '<td>' + value['short_form'] + '</td>';
				row += '<td>' + value['counter'] + '</td>';
		row += '</tr>';
		$tableBody.append(row);
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

// send A POST Ajax Request
function sendPostRequest(url){
	$.ajax({
					url: '/urls/create',
					type: 'POST',
					dataType: 'json',
					cache: false,
					data: url,
					success: function(data){
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


function sendGetRequest(){

	$.ajax({

		url: '/get_urls',
		type: 'GET',
		dataType: 'json',
		cache: false,
		success: function(data){
			populateTable(data);
		},
		error: function(data){
			console.log("ERROR: ");
			console.log(err);
		}
	});


}





















