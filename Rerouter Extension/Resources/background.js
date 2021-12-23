const filter = {
  url:
  [
    {urlContains: "google.com/maps"}
  ]
}

// Intercept Google Maps links before they are handled, then redirect them.
function redirectPage(details) {
    console.log(`onBeforeNavigate to: ${details.url}`);
    var redirectUrl = ""

    if ((details.url).includes('dir')) {
        var address = (details.url).split('/maps/').pop();
        address = address.split("/")[2];
        redirectUrl = "http://maps.apple.com/?daddr="+address

    } else if ((details.url).includes('place') || (details.url).includes('search')) {
        var place = (details.url).split('/maps/').pop();

        let coordinates = (place.split("@").pop()).split("/")[0];

        let lat = coordinates.split(",")[0];
        let long = coordinates.split(",")[1];
        let zoom = (coordinates.split(",")[2]).replace('z','');

        place = place.split("/")[1];

        redirectUrl = "http://maps.apple.com/?q="+place+"&sll="+lat+","+long+"&z="+zoom

    } else {
      let coordinates = ((details.url).split("@").pop()).split("/")[0];

      let lat = coordinates.split(",")[0];
      let long = coordinates.split(",")[1];
      let zoom = (coordinates.split(",")[2]).replace('z','');

      redirectUrl = "http://maps.apple.com/?ll="+lat+","+long+"&z="+zoom;
    }

    browser.tabs.update({url: redirectUrl});
}

browser.webNavigation.onBeforeNavigate.addListener(redirectPage, filter);
