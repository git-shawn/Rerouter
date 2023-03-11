/*
 RouteManager.js
 The code in this document is the primary source of all 'rerouting.'
 The 'reroute' variable is referenced by the main application as well as by the Safari Extension.
 */

var mapsRegex = /https?:\/\/(((www|maps)\.)?(google\.).*(\/maps)|maps\.(google\.).*)/;

// This function does not accept Google Maps short URLs.
// URLs should first be expanded if possible.
var reroute = function(url) {
    if (mapsRegex.test(url)) {
        var coords = new parseCoordsFromDataParam(url);
        
        if (coords.length > 0) {
            if (coords.length/2 > 1) {
                // Multiple coordinates indicate directions, a start and an end.
                return "maps://?saddr=" + coords[1] + "," + coords[0] + "&daddr=" + coords[3] + "," + coords[2];
            } else if (url.includes("dir/")) {
                // Directions that include only one set of coordinates should begin from the device's location.
                return "maps://?daddr=" + coords[1] + "," + coords[0];
            } else {
                // A single set of coordinates indicate a place.
                // Places appear to present long and lat coordinates opposite the way directions do.
                return "maps://?address=" + coords[0] + "," + coords[1];
            }
        } else {
            return handleMapsLinkNoData(url)
        }
    }
}

// Attempt to extract an Apple Maps URL from a Google Maps link that does not have a parsable data parameter.
// This happens primarily on mobile, where 'data=' only contains the Google Place ID.
function handleMapsLinkNoData(url) {
    var rURL = url;
    var aURL = "";
    var coords = [];
    let params = (new URL(url)).searchParams;
    
    if (params.has('daddr')) {
        aURL = "http://maps.apple.com/?daddr=" + params.get('daddr');
        if (params.has('saddr')) {
            aURL += "&saddr=" + params.get('saddr');
        }
    } else {
        rURL = rURL.replace(mapsRegex, "");
        rURL = rURL.split("/data=!")[0];
        rURL = rURL.split("/");
        rURL.shift();
        
        if (rURL.length > 0) {
            // Pop should theoretically always reveal the important coordinates.
            if (rURL[rURL.length - 1].includes("@")) {
                coords = rURL.pop();
                coords = coords.split(",");
                coords[0] = coords[0].substring(1);
                coords[2] = coords[2].slice(0, -1);
            }
            
            if (rURL.length == 0) {
                aURL = "http://maps.apple.com/?ll=" + coords[0] + "," + coords[1] + "&z=" + coords[2];
            } else if (rURL[0].includes("dir")) {
                aURL = "http://maps.apple.com/?daddr=" + rURL[2];
            } else if (rURL[0].includes("place") || rURL[0].includes("search")) {
                aURL = "http://maps.apple.com/?q=" + rURL[1] + "&sll=" + coords[0] + "," + coords[1] + "&z=" + coords[2];
            } else {
                // This is called when a link isn't a place, directions, search, or coordinates. Rather, a mysterious fifth thing.
                console.log("Unexpected URL type. Unable to reroute!")
                console.log(document.location.href);
            }
        }
    }
    
    return aURL;
}

// Based on work by Adam Wallner
// https://gist.github.com/wallneradam/157fbf086bbc45536f113ea250e88df9
function parseCoordsFromDataParam(url) {
    // Isolate the data portion of the URL.
    let dataRegex = /^.+data=/;
    url = url.replace(dataRegex, '');
    
    // Divide the data into known parts.
    var parts = url.split('!').filter(function(s) {
        return s.length > 0;
    }),
    root = [],
    curr = root,
    m_stack = [root, ],
    m_count = [parts.length, ];
    
    // Decode the data portion of the URL, seeking only digits.
    // These digits will always represent coordinates.
    parts.forEach(function(el) {
        var kind = el.substr(1, 1),
        value = el.substr(2);
        
        for (var i = 0; i < m_count.length; i++) {
            m_count[i]--;
        }
        
        // Parts labeled 'm' represent a multileveled container.
        if (kind === 'm') {
            var new_arr = [];
            m_count.push(value);
            curr.push(new_arr);
            m_stack.push(new_arr);
            curr = new_arr;
        } else {
            // Parts labeled 'd' represent digit while 'f' represents float.
            if (kind == 'd' || kind == 'f') {
                curr.push(parseFloat(value));
            }
        }
        
        while (m_count[m_count.length - 1] === 0) {
            m_stack.pop();
            m_count.pop();
            curr = m_stack[m_stack.length - 1];
        }
    });
    
    // Flatten the returned matrix as a bundle of coordinates.
    let coordBundle = root.flat(Infinity);
    return coordBundle;
}
