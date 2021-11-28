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

function isGoogleSearchPage() {
    if (window.location.pathname.includes("search")) {
        return true;
    }
    return false;
}

function rewriteLinksOnSearch() {
//    var xPathResult = document.evaluate('//*[@id="kp-wp-tab-overview"]/div/div/div/div/div/div[2]/div/c-wiz/div/div/div[1]', document);
//    if(xPathResult){
    window.addEventListener('load', function () {
        var elements = document.getElementsByClassName("FFdnyb");
        var element = elements[1];
        console.log(element)
        
        let gmapsPath = element.getAttribute("data-link");
        
        //Parse Google Maps URL into Coordinates
        var firstSplit = gmapsPath.split("dir//");
        var secondSplit = firstSplit[1].split("/");
        var finalPath = secondSplit[0].replace(",+", ",");
        
        const amapsURL = "http://maps.apple.com/?daddr="
        
        // Combine urls
        const finalUrl = amapsURL + finalPath
        
        element.getAttributeNode("data-link").value = finalUrl
        let svgSpan = element.querySelector('.q6AaZ');
        svgSpan.style.padding = "10px";
        svgSpan.innerHTML = '<svg style="margin-right: 2px; margin-top: 2px;" width="18" height="18" viewBox="0 0 24 24" focusable="false" class=" NMm5M"><path d="M12.9230602,23.9921014 C13.230391,23.9633491 13.5229902,23.8468157 13.8008575,23.6425012 C14.0787249,23.4381868 14.307153,23.1413454 14.4861418,22.751977 L23.7193154,2.73955244 C23.949089,2.2389162 24.0377899,1.78947982 23.9854181,1.39124329 C23.9330463,0.993006768 23.7731708,0.671881804 23.5057916,0.427868402 C23.2384123,0.183854999 22.9004105,0.0437655325 22.4917861,0.00760000266 C22.0831616,-0.0285655272 21.6411407,0.0643424719 21.1657232,0.286324 L1.1267722,9.60518338 C0.771002589,9.76079215 0.501553341,9.97390551 0.318424454,10.2445234 C0.135295566,10.5151414 0.031207425,10.8007243 0.00616003005,11.1012724 C-0.0188873649,11.4018204 0.0324494446,11.6878191 0.160170458,11.9592684 C0.287891472,12.2307177 0.487201115,12.4535306 0.758099386,12.6277071 C1.02899766,12.8018837 1.37200207,12.8889719 1.78711261,12.8889719 L10.8780749,12.9263845 C10.9611523,12.9263845 11.0200102,12.9429084 11.0546487,12.9759563 C11.0892873,13.0090041 11.1066066,13.0685525 11.1066066,13.1546015 L11.1306189,22.2225885 C11.1306189,22.6233192 11.2153523,22.9614877 11.3848189,23.237094 C11.5542856,23.5127002 11.7761931,23.7146245 12.0505414,23.8428666 C12.3248898,23.9711087 12.6157293,24.0208537 12.9230602,23.9921014 Z"></path></svg>'
    })
}

// Return true if the current window is viewing Google Maps at all.
function isGoogleMapsPage() {
    if (window.location.pathname.includes("maps")) {
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
        
        if (isGoogleSearchPage()) {
            rewriteLinksOnSearch()
        }
        
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
