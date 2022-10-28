browser.runtime.onMessage.addListener(function(request, sender, respond) {
    if (request.hasOwnProperty("redirect")) {
        redirectPage(request.redirect);
        return true;
    }
});

function redirectPage(url) {
    console.log("Attempting redirect for " + url);

    browser.runtime.sendNativeMessage("shwndvs.Rerouter", {message: "getDefaults"}, function(response) {
        console.log(localStorage.getItem('rerouter-state'));
        if (url != "" && localStorage.getItem('rerouter-state') != "on") {
            if (!response.manual) {
                browser.tabs.executeScript({code: "document.location.href = '" + url + "';"});
//                browser.tabs.update({url: url});
            } else {
                injectManualBanner(url);
            }
        }
    });
}

function injectAutoLink(redirectUrl) {
    
}

function injectManualBanner(redirectUrl) {
    // The string '$AMAPLINK' should be replaced with the correct redirect link.
    let manualOverlayTemplate = `<div style=" font-family: -apple-system, BlinkMacSystemFont!important; background-color: #fff; position: absolute; margin-left: auto; margin-right: auto; bottom: 0; left: 0; right: 0; text-align: center; width: 100%; max-width: 450px; border-radius: 2rem 2rem 0px 0px; box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px; z-index: 99999;" id="f4c83fad-b326-483e-946d-1a31bdeed4e5" > <div style=" height: 90%; display: flex; flex: no-wrap; flex-direction: column; align-items: center; justify-content: space-between; padding: 20px; " > <div> <div style="color: #1c212f; font-family: -apple-system, BlinkMacSystemFont!important; font-size: 42px; margin: 0; font-weight: 700;">Rerouter</div> <p style="color: #515866; padding: 1rem 2rem"> To perform this automatically, disable "Manual" mode in the Rerouter app. </p>  <br /> <br /> </div> <div> <a style=" text-decoration: none; font-size: 20px; font-weight: 500; padding: 15px 64px; background-color: #3a93ff; color: #fff; border-radius: 8px; " onmouseover="this.style.backgroundColor='#0073d7'" onmouseout="this.style.backgroundColor='#3a93ff'" href="$APMAPLINK" >Open in Maps</a > <br /> <br /> <br /> <a style="text-decoration: none; font-size: 20px; color: #515866" href="javascript:document.getElementById('f4c83fad-b326-483e-946d-1a31bdeed4e5').style.display = 'none';" onmouseover="this.style.color='#383D47'" onmouseout="this.style.color='#515866'" >Cancel</a > </div> </div> </div>`
    let manualOverlay = manualOverlayTemplate.replace("$APMAPLINK", redirectUrl);
    browser.tabs.executeScript({code: "if (document.body.contains(document.getElementById('f4c83fad-b326-483e-946d-1a31bdeed4e5'))) { document.getElementById.innerHTML =`"+manualOverlay+"` } else { document.body.insertAdjacentHTML('beforeEnd',` "+manualOverlay+"`);}"});
}
