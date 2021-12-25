const filter = {
  url:
  [
    {urlPrefix: "https://www.google.com/maps"},
    {urlPrefix: "http://www.google.com/maps"},
    {urlPrefix: "https://maps.google.com"}
  ]
}

// Intercept Google Maps links before they are handled, then redirect them.
function redirectPage(details) {
    console.log(`onBeforeNavigate to: ${details.url}`);
    browser.runtime.sendNativeMessage("shwndvs.Rerouter", {message: "getDefaults"}, function(response) {
        console.log(response)
        var redirectUrl = ""

        if ((details.url).includes('dir') || (details.url).includes('d')) {
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

        if (!response.manual) {
            browser.tabs.update({url: redirectUrl});
        } else {
            if (details.url.includes("reroute=true") == false) {
                var landingURL = browser.runtime.getURL("landing.html");
                landingURL = landingURL + "?aLink=" + redirectUrl + "&gLink=" + details.url;
                console.log(landingURL)
                browser.tabs.update({url: landingURL});
            }
        }
    });
}

browser.webNavigation.onBeforeNavigate.addListener(redirectPage, filter);
