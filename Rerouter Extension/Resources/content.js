browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log(request)
    window.location.assign(request.redirect);
    return true;
});
