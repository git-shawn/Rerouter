// Possible Google Maps hosts to watch for
const filter = {
  url:
  [
   {urlMatches: "(http(s?):\/\/)?((maps\.google\.[a-z]{1,}\/)|((www\.)?google\.[a-z]{1,}\/maps\/)|(goo.gl\/maps\/))+.*"}
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

// Match the URL against the gmaps regex.
function filterTabs(tab) {
    let regex = /^(http(s?):\/\/)?((maps\.google\.[a-z]{1,}\/)|((www\.)?google\.[a-z]{1,}\/maps\/)|(goo.gl\/maps\/))+.*/
    // Ensure this tab is a Google Maps page
    if (regex.test(tab.url)) {
        console.log("regex passed for " + tab.url)
        // Redirect it
        redirectPage(tab)
    }
}

function onError(error) {
    console.log(error)
}

// Called when a user attemps to navigate to a gmaps link.
browser.webNavigation.onBeforeNavigate.addListener(redirectPage, filter);

//Called when a user opens a gmaps link from outside of the browser.
browser.tabs.onCreated.addListener(filterTabs)
