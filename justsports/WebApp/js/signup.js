//Problem: Hints are shown even when form is valid
//Solution: Hide and show them at appropriate times
var $password = $("#password");
var $confirmPassword = $("#confirm_password");
var $business_id = $("#business_id");
var $business_name = $("#business_name");
var $phone_number = $("#phone_number");
var $email= $("#email");
var $address = $("#address");

//Hide hints
$("form span").hide();

function isPasswordValid() {
  return $password.val().length > 8;
}

function arePasswordsMatching() {
  return $password.val() === $confirmPassword.val();
}

function canSubmit() {
  return isPasswordValid() && arePasswordsMatching();
}

function passwordEvent(){
    //Find out if password is valid  
    if(isPasswordValid()) {
      //Hide hint if valid
      $password.next().hide();
    } else {
      //else show hint
      $password.next().show();
    }
}

function confirmPasswordEvent() {
  //Find out if password and confirmation match
  if(arePasswordsMatching()) {
    //Hide hint if match
    $confirmPassword.next().hide();
  } else {
    //else show hint 
    $confirmPassword.next().show();
  }
}

function enableSubmitEvent() {
  $("#submit").prop("disabled", !canSubmit());
}

//When event happens on password input
$password.focus(passwordEvent).keyup(passwordEvent).keyup(confirmPasswordEvent).keyup(enableSubmitEvent);

//When event happens on confirmation input
$confirmPassword.focus(confirmPasswordEvent).keyup(confirmPasswordEvent).keyup(enableSubmitEvent);

enableSubmitEvent();

//hash the message with SHA-256
function get_hash_digest(message) {
	const encoder = new TextEncoder();
	const data = encoder.encode(message);
	const hash = crypto.subtle.digest('SHA-256', data);
	return hash;
}

async function register() {
	//make the message to be sent to server
	const hash_digest = await get_hash_digest($password.val());
	const hash_array = Array.from(new Uint8Array(hash_digest));
	const hash_string = hash_array.map(b => b.toString(16).padStart(2, '0')).join('');

	var to_send = "business_id=";
	to_send = to_send.concat($business_id.val(),
		"&business_name=", $business_name.val(),
		"&password=", hash_string, 
		"&phone_number=", $phone_number.val(),
		"&email=", $email.val(),
		"&address=", $address.val());
	const url = "http://207.154.227.65:5000/business_create?" + to_send;

	//server communication
	const server_conn = new XMLHttpRequest();
	server_conn.open("POST", url, false);
	server_conn.onload = function () {
		switch (this.responseText) {
			case "success":
				alert("Account was created successfully");
				window.location = "start.html";
				break;
			case "username already exists":
				alert("An account with the same username already exists");
				break;
			default:
				alert("An error occurred");
		}
	}
	try {
		server_conn.send();
	} catch(err) {
		alert(err);
	}
}
