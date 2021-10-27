window.addEventListener("DOMContentLoaded", (event) => {
    var routeButton = document.getElementById("reroute-manually");
    var bodyText = document.getElementById("body-text");
    
    routeButton.addEventListener("click", (event) => {
        console.log("clicked!")
        browser.tabs.query({active: true, currentWindow: true}, function (tabs) {
            browser.tabs.sendMessage(tabs[0].id, { type: "routeThisPageFromPopup" });
        });
    });
});

