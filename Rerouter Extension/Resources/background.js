const filter = {
url:
    [{
    urlMatches: "https?:\/\/(((www|maps)\.)?(google\.).*(\/maps)|maps\.(google\.).*)"
    }]
}

browser.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
  if (changeInfo.url) {
      attemptReroute(changeInfo.url);
  }
});
