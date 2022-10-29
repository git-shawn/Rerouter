browser.runtime.onMessage.addListener(function(request, sender, respond) {
    if (request.hasOwnProperty("redirect")) {
        redirectPage(request.redirect);
        return true;
    } else if (request.hasOwnProperty("openApp")) {
        browser.tabs.executeScript({code: "document.location.href = 'rerouter://';"});
    }
});

function redirectPage(url) {
    browser.runtime.sendNativeMessage("shwndvs.Rerouter", {message: "getDefaults"}, function(response) {
        if (url != "") {
            if (!response.manual && localStorage.getItem('rerouter-state') == "on") {
                browser.tabs.executeScript({code: "document.location.href = '" + url + "';"});
            } else {
                injectManualBanner(url);
            }
        }
    });
}

function injectManualBanner(redirectUrl) {
    let rawOverlay = `<div> <input type="checkbox" id="ZMuZ56ike8SHPaLOKQTg" /> <div style=" height: 100%; width: 100%; position: absolute; top: 0; left: 0; z-index: 99998; background-color: rgba(0, 0, 0, 0.3); " class="X1YxgoTaI02WAB7ukaIM9A" > <style> #ZMuZ56ike8SHPaLOKQTg { opacity: 0; } label { cursor: pointer; } input[type="checkbox"]:checked ~ .X1YxgoTaI02WAB7ukaIM9A { display: none; } </style> <div style=" font-family: -apple-system, BlinkMacSystemFont !important; background-color: #fff; position: absolute; margin-left: auto; margin-right: auto; bottom: 0; left: 0; right: 0; z-index: 99999; text-align: center; width: 100%; max-width: 450px; border-radius: 2rem 2rem 0px 0px; box-shadow: rgba(0, 0, 0, 0.16) 0px 10px 36px 0px, rgba(0, 0, 0, 0.06) 0px 0px 0px 1px; " > <div style=" height: 90%; display: flex; flex: no-wrap; flex-direction: column; align-items: center; justify-content: space-between; gap: 40px!important; padding: 20px; " > <div> <p style=" color: #1c212f; font-size: 42px; font-weight: 700; margin: 0; font-family: -apple-system, BlinkMacSystemFont !important; " > Rerouter! </p> <p style="color: #515866; padding: 5px 30px"> To perform this automatically, disable "Manual" mode in the Rerouter app. </p> </div> <div> <a style=" text-decoration: none; font-size: 20px; font-weight: 500; padding: 15px 64px; background-color: #3a93ff; color: #fff; border-radius: 8px; " onmouseover="this.style.backgroundColor='#0073d7'" onmouseout="this.style.backgroundColor='#3a93ff'" href="$APMAPLINK" >Open in Maps</a > <br /> <br /> <br /> <label id="rW0M0GnaNUmb5xL1J6jM5A" for="ZMuZ56ike8SHPaLOKQTg" style=" text-decoration: none; font-size: 20px; color: #515866; background: none; border: none; margin: 0; padding: 0; cursor: pointer; " > Cancel </label> </div> </div> </div> </div> </div>`
    
    var formattedOverlay = rawOverlay.replace("$APMAPLINK", redirectUrl);
    
    browser.tabs.executeScript({code: "if (!document.body.contains(document.getElementById('ZMuZ56ike8SHPaLOKQTg'))) { document.body.insertAdjacentHTML('beforeEnd',` "+formattedOverlay+"`);}"});
}

browser.runtime.sendNativeMessage("shwndvs.Rerouter", {message: "getDefaults"}, function(response) {
    if (response.manual) {
        localStorage.setItem('rerouting-app-mode', 'manual');
    } else {
        localStorage.setItem('rerouting-app-mode', 'auto');
    }
});
