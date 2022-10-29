window.onload = function() {
    if (localStorage.getItem('rerouter-state') == null) {
        localStorage.setItem('rerouter-state', 'on');
    }
    
    if (localStorage.getItem('rerouting-app-mode') == 'auto') {
        setButtons();
        
        var btn = document.getElementById("pauseBtn");
        btn.onclick = togglePauseState;
    } else if (localStorage.getItem('rerouting-app-mode') == 'manual') {
        setManual();
        document.getElementById("openAppBtn").onclick = function(){
            browser.runtime.sendMessage({openApp:"popup"});
        }
    }
}

function togglePauseState() {
    let state = localStorage.getItem('rerouter-state');
    if (state == 'on') {
        localStorage.setItem('rerouter-state', 'off');
    } else {
        localStorage.setItem('rerouter-state', 'on');
    }
    setButtons();
}

function setButtons() {
    let state = localStorage.getItem('rerouter-state');
    
    if (state == 'off') {
        document.getElementById("pauseBtn").innerHTML = "Enable";
        document.getElementById("pauseText").innerHTML = "Rerouter is currently off. Google Maps links will open in the browser.";
    } else if (state == 'on') {
        document.getElementById("pauseBtn").innerHTML = "Pause";
        document.getElementById("pauseText").innerHTML = "Rerouter is currently on. Google Maps links will open in the Maps app.";
    }
}

function setManual() {
    document.getElementById("pauseBtn").style.display = "none";
    document.getElementById("openAppBtn").style.display = "inline-block";
    document.getElementById("pauseText").innerHTML = "Rerouter is currently in manual mode. You will be asked each time before Rerouter attempts to open a link in Maps. If you decline, you won't be asked again while on that page.<br><br>You can be disable this in the app."
}
