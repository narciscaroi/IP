//hash the message with SHA-256
function get_hash_digest(message) {
	const encoder = new TextEncoder();
	const data = encoder.encode(message);
	return crypto.subtle.digest('SHA-256', data);
}

async function validation(){
	var input_text = document.querySelector("#input_text");
	var input_password = document.querySelector("#input_password");
	var error_msg = document.querySelector(".error_msg");
  
	if(input_text.value.length <= 0 || input_password.value.length <= 0 ){
		error_msg.style.display = "inline-block";
		input_text.style.border = "1px solid #f74040";
		input_password.style.border = "1px solid #f74040";
		return false;
	}
	else{
		const hash_digest = await get_hash_digest(input_password.value);
		const hash_array = Array.from(new Uint8Array(hash_digest));
		const hash_string = hash_array.map(b => b.toString(16).padStart(2, '0')).join('');

		var to_send = "business_id=";
		to_send = to_send.concat(input_text.value,
			"&password=", hash_string);
		const url = "http://207.154.227.65:5000/business_login?" + to_send;

		//server communication
		const server_conn = new XMLHttpRequest();
		server_conn.open("POST", url, false);
		server_conn.onload = function () {
			switch (this.responseText) {
				case "an error occurred":
					alert("An error occurred");
					return false;
				case "username not found":
					alert("Username not found");
					return false;
				default:
					document.cookie = String("JWT=").concat(this.responseText);
					window.location = "account.html";
					return true;
			}
		}
		try {
			server_conn.send();
		} catch(err) {
			alert(err);
			return false;

		}
	}
	
  }
  
  var input_fields = document.querySelectorAll(".input");
  var login_btn = document.querySelector("#login_btn");
  
  input_fields.forEach(function(input_item){
	input_item.addEventListener("input", function(){
	  if(input_item.value.length > 0){
		login_btn.disabled = false;
		login_btn.className = "btn enabled"
	  }
	})
  })