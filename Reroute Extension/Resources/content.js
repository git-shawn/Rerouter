browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    // Called when the user presses "Open in Apple Maps" in the pop-up.
    if (request.type == "routeThisPageFromPopup") {
        // By default, we'll try to open any kind of Maps page in Apple Maps.
        // If unsuccessful, we just won't do anything.
        if (isGoogleMapsDirectionsPage()) {
            rerouteDirectionsToMaps()
        } else if (isGoogleMapsSearchPage()) {
            rerouteSearchToMaps()
        } else if (isGoogleMapsPage()) {
            rerouteToMaps()
        } else {
            alert("Rerouter couldn't open this page in Apple Maps.")
        }
    }
});

// Return true if the current window is viewing Google Maps directions.
function isGoogleMapsDirectionsPage() {
    if (window.location.pathname.includes("maps") && window.location.pathname.includes("dir//")) {
        console.log("is directions")
        return true;
    }
    return false;
}

// Return true if the current window is viewing Google Maps search results.
function isGoogleMapsSearchPage() {
    if (window.location.pathname.includes("maps") && window.location.pathname.includes("search/")) {
        console.log("is search")
        return true;
    }
    return false;
}

// Return true if the current window is viewing Google Maps at all.
function isGoogleMapsPage() {
    console.log("Testing if maps!")
    if (window.location.pathname.includes("maps")) {
        console.log("is general")
        return true;
    }
    return false;
}

// Convert the Google Map's URL to an Apple Map's URL, then replace the window.
// This function works with navigation directions.
function rerouteDirectionsToMaps() {
    // Get the path from the Google Maps URL
    var gmapsPath = window.location.pathname;

    //Parse Google Maps URL into Coordinates
    var firstSplit = gmapsPath.split("dir//")
    var secondSplit = firstSplit[1].split("/")
    var finalPath = secondSplit[0].replace(",+", ",")
    
    const amapsURL = "http://maps.apple.com/?daddr="
    
    // Combine urls
    const finalUrl = amapsURL + finalPath
        
    console.log("Initial path: " + gmapsPath)
    console.log("Directions: " + finalUrl)
    
    // Redirect the page
    window.location.replace(finalUrl);
}

// Convert the Google Map's URL to an Apple Map's URL, then replace the window.
// This function works with search results.
function rerouteSearchToMaps() {
    // Get the path from the Google Maps URL
    var gmapsPath = window.location.pathname;

    //Parse Google Maps URL into Coordinates
    var firstSplit = gmapsPath.split("search/")
    var secondSplit = firstSplit[1].split("/")
    var searchQuery = secondSplit[0]
    var coordinates = secondSplit[1].replace("@", "").split(",")
    
    const amapsURL = "http://maps.apple.com/?q="
    
    // Combine urls
    const finalUrl = amapsURL + searchQuery + "&sll=" + coordinates[0] + "," + coordinates[1]
    
    console.log("Initial path: " + gmapsPath)
    console.log("Search: " + finalUrl)
        
    // Redirect the page
    window.location.replace(finalUrl);
}

// Convert the Google Map's URL to an Apple Map's URL, then replace the window.
// This function works with most Google Maps webpages.
function rerouteToMaps() {
    // Get the path from the Google Maps URL
    var gmapsPath = window.location.pathname;

    //Parse Google Maps URL into Coordinates
    var firstSplit = gmapsPath.split("@")
    var secondSplit = firstSplit[1].split("/")
    var coordinates = secondSplit[0].split(",")
    var zoomLevel = coordinates[2].replace("z", "")
    
    console.log("Initial path: " + gmapsPath)
    const amapsURL = "http://maps.apple.com/?ll="
    
    // Combine urls
    const finalUrl = amapsURL + coordinates[0] + "," + coordinates[1] + "&z=" + zoomLevel
        
    console.log("General: " + finalUrl)
    
    // Redirect the page
    window.location.replace(finalUrl);
}

function handleResponse(message) {
    if (!message) {
      console.error("Uh oh :", runtime.lastError.message)
    }
    
    let automatic = message.response.automatic;
    let openableLinks = message.response.openableLinks;
    
    // This isn't possible, so we can assume that the defaults just haven't been initiated.
    if (automatic == false && openableLinks == 0) {
        automatic = true
    }
    
    // If the user enabled automatic mode (on by default) we'll go ahead and redirect the webpage.
    // openableLinks == 0 means only redirect navigation directions.
    // openableLinks == 1 means redirect navigation directions and search results.
    // openableLinks == 2 means try to redirect anything.
    if (automatic == true) {
        browser.runtime.sendMessage({ type: "rerouteAuto" });
        if (openableLinks == 0) {
            if (isGoogleMapsDirectionsPage()) {
                rerouteDirectionsToMaps()
            }
        } else if (openableLinks == 1) {
            if (isGoogleMapsDirectionsPage()) {
                rerouteDirectionsToMaps()
            } else if (isGoogleMapsSearchPage()) {
                rerouteSearchToMaps()
            }
        } else if (openableLinks == 2) {
            if (isGoogleMapsDirectionsPage()) {
                rerouteDirectionsToMaps()
            } else if (isGoogleMapsSearchPage()) {
                rerouteSearchToMaps()
            } else if (isGoogleMapsPage()) {
                rerouteToMaps()
            }
        }
    }
}

function handleError(error) {
    console.log(`Error: ${error}`);
}

// Request user preferences from the main app.
var sending = browser.runtime.sendMessage({ type: "getDefaults" });
sending.then(handleResponse, handleError);
