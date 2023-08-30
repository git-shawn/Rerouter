# Rerouter 🗺

Rerouter is an unobtrusive Safari Extension made to do just one thing—open Google Maps links in Apple Maps. Setup is easy and rerouting happens privately and automatically. Next time you search for "hikes near me" you can get to the trail quicker than ever before.

Available for iOS and macOS.

[**Download Here**](https://apps.apple.com/us/app/id1589151155)

<a href="https://testflight.apple.com/join/gQHgloIz"><img alt="Join TestFlight Beta" src="https://raw.githubusercontent.com/git-shawn/QR-Pop/main/GitHubResources/TestflightButton.png" width="180"></a>

## Privacy 🕵️

Rerouter performs all processing directly on your device and does not collect any user data. 

[**Privacy Policy**](https://www.fromshawn.dev/rerouter/privacy-policy)

## How it Works 🛠️
Rerouter starts by testing the page's URL against this regex defined by Google:

```
(http(s?)://)?
((maps\.google\.{TLD}/)|
 ((www\.)?google\.{TLD}/maps/)|
 (goo.gl/maps/))
.*
```

If there's a match, Rerouter will then begin to parse the `data=` parameter of the Google Maps URL. Occasionally, the data parameter may contain encoded values representing coordinates that can be extracted and sent to Apple Maps. More often, however, the data portion only contains a proprietary "Place ID."

If no useful information can be extracted, Rerouter will then begin examining the path for indicators that can be converted. This includes parameters such as `dir/`, `/@Lat,Long,Z`, etc. 
If no useful information can be found in the path, Rerouting fails. To avoid this, Rerouter will attempt to expand the link via an ephemeral `URLSession` to hopefully fetch a viable path.

As a single page application, Google Maps is constantly and silently changing the path of its URL. Rerouter observes all changes in the DOM tree while the user is navigating a Google Maps webpage in an attempt to find a URL that can be successfully converted. When one is found, observing ends and the user is prompted to open Apple Maps.

Due to the server-side nature of Apple's [Universal Links](https://developer.apple.com/ios/universal-links/) system, it is unlikely that Rerouter can redirect a link *before* the user is sent to the Google Maps app. Because of this, Rerouter may not work with Google Maps installed.
