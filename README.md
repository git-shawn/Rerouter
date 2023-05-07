# Rerouter 🗺

Searching for places, like parks or restaurants, with Google can be a huge pain on iOS if you don't use Google Maps. That's because pressing "directions" traps you in a goofy web-view of Google Maps. This extension solves that headache by automatically opening Google Maps directions in Apple Maps.

Available for iOS and macOS.

[**Download Here!**](https://apps.apple.com/us/app/id1589151155)

## Privacy 🕵️

Rerouter performs all processing directly on your device and contains no trackers, loggers, etc. 

[**Privacy Policy**](https://www.fromshawn.dev/support/rerouter-privacy)

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
If no useful information can be found in the path, Rerouting fails.

As a single page application, Google Maps is constantly and silently changing the path of its URL. Rerouter observes all changes in the DOM tree while the user is navigating a Google Maps webpage in an attempt to find a URL that can be successfully converted. When one is found, observing ends and the user is prompted to open Apple Maps.

Due to the server-side nature of Apple's [Universal Links](https://developer.apple.com/ios/universal-links/) system, it is unlikely that Rerouter can redirect a link *before* the user is sent to the Google Maps app. Because of this, Rerouter may not work with Google Maps installed.

## What's New? 🤩
- Version 3.6
	- Shortcuts support via App Intents.
- Version 3.5
	- Faster and less resource intensive URL observation system
	- Switched to Manifest V3
	- Rerouter now searches the `data=` parameter for coordinates when possible
	- Text input has been added to the main app, allowing the user to reroute an arbitrary link
	- Manual and Automatic mode have been discontinued. Now the user can simply enable and disable Rerouter via the extension popover
	- UI improvements for the main app
