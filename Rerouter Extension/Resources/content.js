function handleMessage(request, sender, sendResponse) {
    if (request.type == "prepareLanding") {
        console.log(request.amapsLink);
        console.log(request.gmapsLink);
        
        var amapsBtn = document.getElementById("amapslink");
        amapsBtn.href = request.amapsLink;
        amapsBtn.style.display = "block";
        var gmapsBtn = document.getElementById("gmapslink");
        gmapsBtn.href = request.gmapslink
        amapsBtn.style.display = "block"
    }
}

browser.runtime.onMessage.addListener(handleMessage);
