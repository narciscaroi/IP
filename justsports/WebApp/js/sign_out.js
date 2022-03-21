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

function sign_out() {
    document.cookie = String("JWT=");
    if (getCookie("location_id") !== "")
        document.cookie = String("location_id=");
    if (getCookie("sport_name") !== "")
        document.cookie = String("sport_name=");
}