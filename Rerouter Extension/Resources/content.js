console.log("Content script installed...");
var previousUrl = '';

// Watch for mutations in the browser's URL
var observer = new MutationObserver(function(mutations) {
    console.log("detecting mutations")
    if (location.href !== previousUrl) {
        previousUrl = location.href;
        let newURL = attemptReroute(previousUrl);
    }
});

// Watch for literally any change at all to the DOM.
// This is a little hacky, but currently there is no way to observe path changes in a SPA.
const config = {subtree: true, childList: true};

// Only initiate the observer if we're on a Google Maps page.
if (mapsRegex.test(location.href)) {
    observer.observe(document, config);
}

// Attempt to redirect the Google Maps URL to Apple Maps using the script within RouteManager.js.
function attemptReroute(url) {
    console.log("Current URL: " + url);
    let newURL = reroute(url);
    
    console.log("Routing attempt: " + newURL);
    if (newURL) {
        let gettingValues = browser.storage.local.get("extState");
        gettingValues.then((val) => {
            if (val.extState.autoMode) {
                location.href = newURL;
                observer.disconnect();
            } else {
                observer.disconnect();
            }
        });
    }
}

