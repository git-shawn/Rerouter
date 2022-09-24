// Intercept Google Maps links before they are handled, then redirect them.
function redirectPage(details) {
    // Check if the user has enabled automatic or manual mode.
    browser.runtime.sendNativeMessage("shwndvs.Rerouter", {message: "getDefaults"}, function(response) {
        var redirectUrl = ""

        // If the link is for map directions, parse it.
        if ((details.url).includes('dir')) {
            var address = (details.url).split('/maps/').pop();
            
            address = address.split("/")[2];
            redirectUrl = "http://maps.apple.com/?daddr="+address
        
        // If the coordinates have been obscured behind hexadecimal code, try to parse it.
        } else if ((details.url).includes('place//data=!')) {
            var hexCode = (details.url).split(':').pop();
            var hexCode = hexCode.split('?')[0];
            let bigHex = BigInt(hexCode);
            let cid = bigHex.toString(10);
            
            let rerouteNow = "https://google.com/maps?cid=" + cid;
            browser.tabs.update({url: rerouteNow});
            
        // If the link is for a place or search query, parse it.
        } else if ((details.url).includes('place') || (details.url).includes('search')) {
            
            var place = (details.url).split('/maps/').pop();
            if ((details.url).includes('@')) {
                let coordinates = (place.split("@").pop()).split("/")[0];

                let lat = coordinates.split(",")[0];
                let long = coordinates.split(",")[1];
                let zoom = (coordinates.split(",")[2]).replace('z','');

                place = place.split("/")[1];

                redirectUrl = "http://maps.apple.com/?q="+place+"&sll="+lat+","+long+"&z="+zoom
            } else {
                // If a place has no coordinates, just go to the location itself.
                let locTitle = place.split("/")[1];
                redirectUrl = "http://maps.apple.com/?address=" + locTitle;
            }
        
        // If the link is just loose coordinates, parse it.
        } else {
          let coordinates = ((details.url).split("@").pop()).split("/")[0];

          let lat = coordinates.split(",")[0];
          let long = coordinates.split(",")[1];
          let zoom = (coordinates.split(",")[2]).replace('z','');

          redirectUrl = "http://maps.apple.com/?ll="+lat+","+long+"&z="+zoom;
        }
        
        if (!response.manual && redirectUrl != "") {
            // If automatic mode, update the tab to the new Apple Mapss link.
            browser.tabs.update({url: redirectUrl});
        } else {
            // If manual mode, pass the parsed links to Rerouter's landing page then navigate.
            if (details.url.includes("reroute=true") == false && redirectUrl != "") {
                var landingURL = browser.runtime.getURL("landing.html");
                landingURL = landingURL + "?aLink=" + redirectUrl + "&gLink=" + details.url + "&reroute=true";
                browser.tabs.update({url: landingURL});
            }
        }
    });
}

// Store the url to be changed to prevent infinite reloads
var previousURL = "";

// True if the popup requests that the extension pause.
var shouldPause = false;

// Determines if URL valid for Google Maps.
// Based on this answer by fejese on SO: https://stackoverflow.com/a/14834961
const regex = /^https?\:\/\/(www\.|maps\.)?google(\.[a-z]+){1,2}\/maps\//;

// Listen for messages
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Extension request", request.action);
    if (request.action == "getPauseStatus") {
        sendResponse({ response: `${shouldPause}` });
    } else if (request.action == "unpause") {
        shouldPause = false;
    } else if (request.action == "pause") {
        shouldPause = true;
    }
});

browser.tabs.onUpdated.addListener(function(tabid, changeInfo, tab) {
    if ((changeInfo.status || tab.status) == 'complete' && tab.url != undefined && tab.url != previousURL && !shouldPause) {
        previousURL = tab.url;
        if (regex.test(tab.url)) {
            redirectPage(tab);
        }
    }
});
