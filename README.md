# Rerouter 🗺

Searching for places, like parks or restaurants, with Google can be a huge pain on iOS if you don't use Google Maps. That's because pressing "directions" traps you in a goofy webview of Google Maps. This extension solves that headache by automatically opening Google Maps directions in Apple Maps.

[**Download Here!**](https://apps.apple.com/us/app/id1589151155)

## Privacy 🕵️

Safari extensions require user permission to access website data, and for good reason. Rerouter reads the URL of every webpage it visits on Google's domain so that it can know when to redirect the user.

The code is posted here in the interest of total transparency. All Rerouter processing happens on-device, so information like those URLs never leave the extension. There are also no trackers, loggers, etc. in the app.

[**Privacy Policy**](https://fromshawn.dev/rerouter.html#privacy)

## How it Works ⚙️

By default, Rerouter automatically redirects Google Maps navigation webpages. To do that, Rerouter parses the pathname (everything after the first slash in a website's URL) of every URL the user visits on Google's domain looking for "maps/." If it finds that, it'll next begin searching for "dir//." If both of those things have been found, we can extract the address from the URL and transform it into something Apple Maps can read. Then, we just redirect the webpage. Easy! For other types of Google Maps webpages, the method is largely the same.

Rerouter is based on guidance from [**this guide on Google Maps URL schemes**](https://developers.google.com/maps/documentation/urls/get-started) and [**this guide on Apple Maps URL schemes**](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html).

## License

Rerouter is licensed under GPL-3.0. If you use any of the ideas in here, I'd love to see them!
