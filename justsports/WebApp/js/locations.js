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

const url = "http://207.154.227.65:5000/get_business_locations?";
var cookie = "JWT=";
cookie = cookie.concat(getCookie("JWT"));
//server communication
const server_conn = new XMLHttpRequest();
server_conn.open("GET", url.concat(cookie), false);
server_conn.onload = function () {
    var loc_arr = JSON.parse(this.responseText);
    for (var i = 0; i < loc_arr.length; i++) {
        var html_insert = document.getElementById("location_list");
        var html_obj = document.createElement("LI");
        html_obj.setAttribute("class", "list-group-item list-group-item-action flex-column");
        html_obj.setAttribute("href", "#");
        html_obj.setAttribute("data-toggle", "list");
        html_obj.setAttribute("onclick", ("get_sports(" + loc_arr[i].location_id + ");"))
        html_obj.innerText = (loc_arr[i].location_id + "." + loc_arr[i].address);
        html_insert.appendChild(html_obj);
    }
}
try {
    server_conn.send();
} catch(err) {
    alert(err);
}

function get_sports(location_id) {
    const url_sport = "http://207.154.227.65:5000/get_business_sports?";
    //server communication
    const server_conn_sport = new XMLHttpRequest();
    server_conn_sport.open("GET", url_sport.concat(cookie, String("&location_id=").concat(location_id)),
        false);
    server_conn_sport.onload = function () {
        var sport_arr = JSON.parse(this.responseText);
        var html_insert = document.getElementById("sport_list");
        while (html_insert.hasChildNodes())
            html_insert.removeChild(html_insert.firstChild);
        for (var i = 0; i < sport_arr.length; i++) {
            var html_obj = document.createElement("LI");
            html_obj.setAttribute("class", "list-group-item list-group-item-action flex-column");
            html_obj.setAttribute("data-toggle", "list");
            html_obj.setAttribute("onclick", ("go_to_calendar(" + location_id + ", \"" + sport_arr[i].sport_name + "\");"));
            html_obj.innerText = (sport_arr[i].sport_name);
            html_insert.appendChild(html_obj);
        }
    }
    try {
        server_conn_sport.send();
    } catch(err) {
        alert(err);
    }
}

function go_to_calendar(location_id, sport_name) {
    //set cookies for future request
    document.cookie = "location_id=" + location_id;
    document.cookie = "sport_name=" + sport_name;

    //redirect to calendar window
    //TODO
    //window.location = "account.html";
    return true;
}