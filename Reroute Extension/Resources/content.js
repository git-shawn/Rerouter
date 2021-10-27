browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type == "routeThisPageFromPopup") {
        if (isGoogleMapsDirectionsPage()) {
            rerouteDirectionsToMaps()
        } else if (isGoogleMapsSearchPage()) {
            rerouteSearchToMaps()
        } else if (isGoogleMapsPage()) {
            rerouteToMaps()
        }
    }
});

function isGoogleMapsDirectionsPage() {
    if (window.location.pathname.includes("maps") && window.location.pathname.includes("dir//")) {
        console.log("is directions")
        return true;
    }
    return false;
}

function isGoogleMapsSearchPage() {
    if (window.location.pathname.includes("maps") && window.location.pathname.includes("search/")) {
        console.log("is search")
        return true;
    }
    return false;
}

function isGoogleMapsPage() {
    console.log("Testing if maps!")
    if (window.location.pathname.includes("maps")) {
        console.log("is general")
        return true;
    }
    return false;
}

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
      console.error("This was a fiasco :", runtime.lastError.message)
    } else {
        console.log(message)
    }
    
    let automatic = message.response.automatic;
    let openableLinks = message.response.openableLinks;
    
    // This isn't possible, so we can assume that the defaults just haven't been initiated.
    if (automatic == false && openableLinks == 0) {
        automatic = true
    }
    
    console.log(automatic)
    console.log(openableLinks)
    
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

var sending = browser.runtime.sendMessage({ type: "getDefaults" });
sending.then(handleResponse, handleError);
