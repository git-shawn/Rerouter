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
    let params = new URLSearchParams(url);
    
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

// url-search-param.min.js Polyfill for JavaScriptCore
/*! (c) Andrea Giammarchi - ISC */
var self=this||{};try{!function(t,e){if(new t("q=%2B").get("q")!==e||new t({q:e}).get("q")!==e||new t([["q",e]]).get("q")!==e||"q=%0A"!==new t("q=\n").toString()||"q=+%26"!==new t({q:" &"}).toString()||"q=%25zx"!==new t({q:"%zx"}).toString())throw t;self.URLSearchParams=t}(URLSearchParams,"+")}catch(t){!function(t,a,o){"use strict";var u=t.create,h=t.defineProperty,e=/[!'\(\)~]|%20|%00/g,n=/%(?![0-9a-fA-F]{2})/g,r=/\+/g,i={"!":"%21","'":"%27","(":"%28",")":"%29","~":"%7E","%20":"+","%00":"\0"},s={append:function(t,e){p(this._ungap,t,e)},delete:function(t){delete this._ungap[t]},get:function(t){return this.has(t)?this._ungap[t][0]:null},getAll:function(t){return this.has(t)?this._ungap[t].slice(0):[]},has:function(t){return t in this._ungap},set:function(t,e){this._ungap[t]=[a(e)]},forEach:function(e,n){var r=this;for(var i in r._ungap)r._ungap[i].forEach(t,i);function t(t){e.call(n,t,a(i),r)}},toJSON:function(){return{}},toString:function(){var t=[];for(var e in this._ungap)for(var n=v(e),r=0,i=this._ungap[e];r<i.length;r++)t.push(n+"="+v(i[r]));return t.join("&")}};for(var c in s)h(f.prototype,c,{configurable:!0,writable:!0,value:s[c]});function f(t){var e=u(null);switch(h(this,"_ungap",{value:e}),!0){case!t:break;case"string"==typeof t:"?"===t.charAt(0)&&(t=t.slice(1));for(var n=t.split("&"),r=0,i=n.length;r<i;r++){var a=(s=n[r]).indexOf("=");-1<a?p(e,g(s.slice(0,a)),g(s.slice(a+1))):s.length&&p(e,g(s),"")}break;case o(t):for(var s,r=0,i=t.length;r<i;r++){p(e,(s=t[r])[0],s[1])}break;case"forEach"in t:t.forEach(l,e);break;default:for(var c in t)p(e,c,t[c])}}function l(t,e){p(this,e,t)}function p(t,e,n){var r=o(n)?n.join(","):n;e in t?t[e].push(r):t[e]=[r]}function g(t){return decodeURIComponent(t.replace(n,"%25").replace(r," "))}function v(t){return encodeURIComponent(t).replace(e,d)}function d(t){return i[t]}self.URLSearchParams=f}(Object,String,Array.isArray)}!function(d){var r=!1;try{r=!!Symbol.iterator}catch(t){}function t(t,e){var n=[];return t.forEach(e,n),r?n[Symbol.iterator]():{next:function(){var t=n.shift();return{done:void 0===t,value:t}}}}"forEach"in d||(d.forEach=function(n,r){var i=this,t=Object.create(null);this.toString().replace(/=[\s\S]*?(?:&|$)/g,"=").split("=").forEach(function(e){!e.length||e in t||(t[e]=i.getAll(e)).forEach(function(t){n.call(r,t,e,i)})})}),"keys"in d||(d.keys=function(){return t(this,function(t,e){this.push(e)})}),"values"in d||(d.values=function(){return t(this,function(t,e){this.push(t)})}),"entries"in d||(d.entries=function(){return t(this,function(t,e){this.push([e,t])})}),!r||Symbol.iterator in d||(d[Symbol.iterator]=d.entries),"sort"in d||(d.sort=function(){for(var t,e,n,r=this.entries(),i=r.next(),a=i.done,s=[],c=Object.create(null);!a;)e=(n=i.value)[0],s.push(e),e in c||(c[e]=[]),c[e].push(n[1]),a=(i=r.next()).done;for(s.sort(),t=0;t<s.length;t++)this.delete(s[t]);for(t=0;t<s.length;t++)e=s[t],this.append(e,c[e].shift())}),function(f){function l(t){var e=t.append;t.append=d.append,URLSearchParams.call(t,t._usp.search.slice(1)),t.append=e}function p(t,e){if(!(t instanceof e))throw new TypeError("'searchParams' accessed on an object that does not implement interface "+e.name)}function t(e){var n,r,i,t=e.prototype,a=v(t,"searchParams"),s=v(t,"href"),c=v(t,"search");function o(t,e){d.append.call(this,t,e),t=this.toString(),i.set.call(this._usp,t?"?"+t:"")}function u(t){d.delete.call(this,t),t=this.toString(),i.set.call(this._usp,t?"?"+t:"")}function h(t,e){d.set.call(this,t,e),t=this.toString(),i.set.call(this._usp,t?"?"+t:"")}!a&&c&&c.set&&(i=c,r=function(t,e){return t.append=o,t.delete=u,t.set=h,g(t,"_usp",{configurable:!0,writable:!0,value:e})},n=function(t,e){return g(t,"_searchParams",{configurable:!0,writable:!0,value:r(e,t)}),e},f.defineProperties(t,{href:{get:function(){return s.get.call(this)},set:function(t){var e=this._searchParams;s.set.call(this,t),e&&l(e)}},search:{get:function(){return c.get.call(this)},set:function(t){var e=this._searchParams;c.set.call(this,t),e&&l(e)}},searchParams:{get:function(){return p(this,e),this._searchParams||n(this,new URLSearchParams(this.search.slice(1)))},set:function(t){p(this,e),n(this,t)}}}))}var g=f.defineProperty,v=f.getOwnPropertyDescriptor;try{t(HTMLAnchorElement),/^function|object$/.test(typeof URL)&&URL.prototype&&t(URL)}catch(t){}}(Object)}(self.URLSearchParams.prototype,Object);