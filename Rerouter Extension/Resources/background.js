const filter = {
url:
    [{
    urlMatches: "https?:\/\/(((www|maps)\.)?(google\.).*(\/maps)|maps\.(google\.).*)"
    }]
}

browser.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
  if (changeInfo.url) {
      // Request that the system expand the URL
      browser.runtime.sendNativeMessage("application.id", {url: changeInfo.url}, function(response) {
          // Attempt to reroute the expanded URL
          // If expansion failed, the original URL is returned an an error is logged.
          attemptReroute(response.url);
      });
  }
});
