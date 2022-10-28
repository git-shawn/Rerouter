window.onload = function() {
    if (localStorage.getItem('rerouter-state') == null) {
        localStorage.setItem('rerouter-state', 'on');
    }
    
    setButtons();
    
    var btn = document.getElementById("pauseBtn");
    btn.onclick = togglePauseState;
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
    
    console.log("Pause state: " + state);
    if (state == 'on') {
        document.getElementById("pauseBtn").innerHTML = "Enable";
        document.getElementById("pauseText").innerHTML = "Re-enable Rerouter for this browser session.";
    } else if (state == 'off') {
        document.getElementById("pauseBtn").innerHTML = "Pause";
        document.getElementById("pauseText").innerHTML = "Temporarily pause Rerouter for this browser session.";
    }
}
