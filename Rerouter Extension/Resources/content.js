var url = document.location.href;
var shouldPause = false;
const mapsRegex = /https?:\/\/(((www|maps)\.)?(google\.).*(\/maps)|maps\.(google\.).*)/;

handleMaps();

// Excellent href change observer by Leonardo Ciaccio
// https://stackoverflow.com/a/46428962
window.onload = function() {
    var bodyList = document.querySelector("body");
    
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            console.log("Similarity: " + similarity(url, document.location.href));
            if (similarity(url, document.location.href) < 0.5) {
                url = document.location.href;
                handleMaps();
            }
        });
    });
    
    var config = {
    childList: true,
    subtree: true
    };
    
    observer.observe(bodyList, config);
};

function handleMaps() {
    if (mapsRegex.test(url) && !shouldPause) {
        var rURL = url;
        var aURL = "";
        var coords = [];
        let params = (new URL(url)).searchParams;
        
        if (params.has('daddr')) {
            aURL = "http://maps.apple.com/?daddr=" + params.get('daddr');
            if (params.has('saddr')) {
                aURL += "&saddr=" + params.get('saddr');
            }
        } else if (rURL.length > 0) {
            rURL = rURL.replace(mapsRegex, "");
            rURL = rURL.split("/data=!")[0];
            rURL = rURL.split("/");
            rURL.shift();
            
            console.log(rURL);
            
            // Pop should theoretically always reveal the important coordinates.
            if (rURL[rURL.length - 1].includes("@")) {
                coords = rURL.pop();
                coords = coords.split(",");
                coords[0] = coords[0].substring(1);
                coords[2] = coords[2].slice(0, -1);
                console.log(coords);
                console.log(rURL);
            }
            
            if (rURL.length == 0) {
                console.log("just coordinates");
                aURL = "http://maps.apple.com/?ll=" + coords[0] + "," + coords[1] + "&z=" + coords[2];
            } else if (rURL[0].includes("dir")) {
                console.log("directions!");
                aURL = "http://maps.apple.com/?daddr=" + rURL[2];
            } else if (rURL[0].includes("place") || rURL[0].includes("search")) {
                console.log("a place!");
                aURL = "http://maps.apple.com/?q=" + rURL[1] + "&sll=" + coords[0] + "," + coords[1] + "&z=" + coords[2];
            } else {
                // Not sure yet...
            }
        }
        
        console.log("Apple maps url: " + aURL);
        browser.runtime.sendMessage({redirect: aURL});
    }
}

browser.runtime.onMessage.addListener(action => {
    if (action.pause == "true") {
        shouldPause = true;
    } else {
        shouldPause = false;
    }
});

// Similarity coefficient between two Strings based on Levenshtein distance.
// SO: https://stackoverflow.com/a/36566052
function similarity(s1, s2) {
    var longer = s1;
    var shorter = s2;
    if (s1.length < s2.length) {
        longer = s2;
        shorter = s1;
    }
    var longerLength = longer.length;
    if (longerLength == 0) {
        return 1.0;
    }
    return (longerLength - editDistance(longer, shorter)) / parseFloat(longerLength);
}

function editDistance(s1, s2) {
    s1 = s1.toLowerCase();
    s2 = s2.toLowerCase();
    
    var costs = new Array();
    for (var i = 0; i <= s1.length; i++) {
        var lastValue = i;
        for (var j = 0; j <= s2.length; j++) {
            if (i == 0)
                costs[j] = j;
            else {
                if (j > 0) {
                    var newValue = costs[j - 1];
                    if (s1.charAt(i - 1) != s2.charAt(j - 1))
                        newValue = Math.min(Math.min(newValue, lastValue),
                                            costs[j]) + 1;
                    costs[j - 1] = lastValue;
                    lastValue = newValue;
                }
            }
        }
        if (i > 0)
            costs[s2.length] = lastValue;
    }
    return costs[s2.length];
}
