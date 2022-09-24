function toggleExtension() {
    if (document.getElementById("pauseBtn").innerHTML == "Pause") {
        browser.runtime.sendMessage({ action: "pause" }).then((response) => {
            console.log("Received response: ", response);
        });
        document.getElementById("pauseBtn").innerHTML = "Enable";
        document.getElementById("pauseText").innerHTML = "Re-enable Rerouter for this browser session.";
    } else {
        browser.runtime.sendMessage({ action: "unpause" }).then((response) => {
            console.log("Received response: ", response);
        });
        document.getElementById("pauseBtn").innerHTML = "Pause";
        document.getElementById("pauseText").innerHTML = "Temporarily pause Rerouter for this browser session.";
    }
}

window.onload = function() {
    var btn = document.getElementById("pauseBtn");
    btn.onclick = toggleExtension;
    
    browser.runtime.sendMessage({ action: "getPauseStatus" }).then((response) => {
        console.log("Received response: ", response.response);
        if (response.response == "true") {
            btn.innerHTML = "Enable";
            document.getElementById("pauseText").innerHTML = "Re-enable Rerouter for this browser session.";
        }
    });
}
