window.addEventListener("DOMContentLoaded", (event) => {
    var routeButton = document.getElementById("reroute-manually");
    
    // When the user clicks the "Open in Apple Maps" button, attempt to do that.
    routeButton.addEventListener("click", (event) => {
        console.log("clicked!")
        browser.tabs.query({active: true, currentWindow: true}, function (tabs) {
            browser.tabs.sendMessage(tabs[0].id, { type: "routeThisPageFromPopup" });
        });
    });
});

