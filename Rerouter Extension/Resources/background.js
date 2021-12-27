// Possible Google Maps hosts to watch for
const filter = {
  url:
  [
    {urlPrefix: "https://www.google.com/maps"},
    {urlPrefix: "http://www.google.com/maps"},
    {urlPrefix: "https://maps.google.com"},
    {urlPrefix: "http://maps.google.com"}
  ]
}

// Intercept Google Maps links before they are handled, then redirect them.
function redirectPage(details) {
    // Check if the user has enabled automatic or manual mode.
    console.log(details)
    browser.runtime.sendNativeMessage("shwndvs.Rerouter", {message: "getDefaults"}, function(response) {
        var redirectUrl = ""

        // If the link is for map directions, parse it.
        if ((details.url).includes('dir')) {
            var address = (details.url).split('/maps/').pop();
            address = address.split("/")[2];
            redirectUrl = "http://maps.apple.com/?daddr="+address

        // If the link is for a place or search query, parse it.
        } else if ((details.url).includes('place') || (details.url).includes('search')) {
            var place = (details.url).split('/maps/').pop();

            let coordinates = (place.split("@").pop()).split("/")[0];

            let lat = coordinates.split(",")[0];
            let long = coordinates.split(",")[1];
            let zoom = (coordinates.split(",")[2]).replace('z','');

            place = place.split("/")[1];

            redirectUrl = "http://maps.apple.com/?q="+place+"&sll="+lat+","+long+"&z="+zoom
        
        // If the link is just loose coordinates, parse it.
        } else {
          let coordinates = ((details.url).split("@").pop()).split("/")[0];

          let lat = coordinates.split(",")[0];
          let long = coordinates.split(",")[1];
          let zoom = (coordinates.split(",")[2]).replace('z','');

          redirectUrl = "http://maps.apple.com/?ll="+lat+","+long+"&z="+zoom;
        }

        if (!response.manual) {
            // If automatic mode, update the tab to the new Apple Mapss link.
            browser.tabs.update({url: redirectUrl});
        } else {
            // If manual mode, pass the parsed links to Rerouter's landing page then navigate.
            if (details.url.includes("reroute=true") == false) {
                var landingURL = browser.runtime.getURL("landing.html");
                landingURL = landingURL + "?aLink=" + redirectUrl + "&gLink=" + details.url + "&reroute=true";
                console.log(landingURL)
                browser.tabs.update({url: landingURL});
            }
        }
    });
}

function filterTabs(tab) {
    // Ensure this tab is a Google Maps page
    if (tab.url.startsWith("https://www.google.com/maps") || tab.url.startsWith("http://www.google.com/maps") || "https://maps.google.com") {
        // Redirect it
          redirectPage(tab)
    }
}

// Called when a user attemps to navigate to a gmaps link.
browser.webNavigation.onBeforeNavigate.addListener(redirectPage, filter);

//Called when a user opens a gmaps link externally.
browser.tabs.onCreated.addListener(filterTabs);
