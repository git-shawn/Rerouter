//nothing
browser.runtime.sendNativeMessage("shwndvs.Rerouter", {message: "getDefaults"}, function(response) {
    if (!response.manual) {
        document.getElementById("description").innerHTML = "Rerouter is automatically opening Google Maps links in Apple Maps. There's nothing more you need to do."
    } else {
        document.getElementById("description").innerHTML = "Rerouter is in manual mode. You'll be asked if you want to open Apple Maps before you're rerouted."
    }
});
