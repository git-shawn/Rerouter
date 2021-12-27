function readyButtons() {
    const url = window.location.href;
    console.log(url)
    const noHost = url.split("?aLink=")[1]
    const params = noHost.split("&gLink=")
    console.log(params)
    document.getElementById("amapslink").href = params[0];
    document.getElementById("gmaps").onclick = function() {
        window.location.replace(params[1]);
    };
}
readyButtons()
