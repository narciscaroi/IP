function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) === 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

const url = "http://207.154.227.65:5000/get_business_history?";
var cookie = "JWT=";
cookie = cookie.concat(getCookie("JWT"));

//server communication
const server_conn = new XMLHttpRequest();
server_conn.open("GET", url.concat(cookie), false);
server_conn.onload = function () {
    var req_arr = JSON.parse(this.responseText);
    for (var i = 0; i < req_arr.length; i++) {
        var html_insert = document.getElementById("req_list");
        var html_obj = document.createElement("LI");
        html_obj.setAttribute("class", "list-group-item list-group-item-action flex-column align-items-start");
        html_obj.setAttribute("href", "#");
        html_obj.innerText = (String(req_arr[i].location_address).concat(" ",req_arr[i].sport_name, " ", req_arr[i].reservation_start));
        html_insert.appendChild(html_obj);
    }
}
try {
    server_conn.send();
} catch(err) {
    alert(err);
}