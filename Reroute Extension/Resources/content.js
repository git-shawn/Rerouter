function isGoogleMapsPage() {
    if (window.location.hostname.includes("google.")) {
        // If true, this is a Google Maps search result
        if (window.location.hostname.includes("google.") && window.location.pathname.includes("/maps/dir//")) {
            return true;
        }
    }
    return false;
}

function rerouteToMaps() {
    // Get the path from the Google Maps URL
    var gmapsPath = window.location.pathname;

    // Get everything after dir// in the path
    const firstRegex = /dir\/\/(.*)/

    // Get everything before /data in the path
    const dataRegex = /^.*(?=(\/data))/
    
    // Get everything before /@ in the path
    const coordRegex = /^.*(?=(\/@))/

    // The initial maps URL that we will attatch our modified path to
    const amapsURL = "http://maps.apple.com/?daddr="
    
    //Perform regex
    var regexedPath = gmapsPath.match(firstRegex)[1]
    
    // Sometimes, maps will include the coordinates. We should check for this, and remove them too.
    if (regexedPath.includes("/@")) {
        regexedPath = regexedPath.match(coordRegex)[0]
    } else {
        regexedPath = regexedPath.match(dataRegex)[0]
    }
    
    // Combine urls
    const finalUrl = amapsURL + regexedPath
    
    // Redirect the page
    window.location.replace(finalUrl);
}

//If the page is a Google Map's page, reroute it to Apple Maps
window.onload = function() {
    if (isGoogleMapsPage()) {
        rerouteToMaps()
    }
}
