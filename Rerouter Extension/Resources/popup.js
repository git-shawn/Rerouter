function saveState(e) {
    console.log("Saving state...");
    browser.storage.local.set({
      extState:  {manualMode: document.querySelector("#manualMode").checked}
    });
    e.preventDefault();
}

function restoreState(e) {
    let stateValues = browser.storage.local.get("extState");
    stateValues.then((val) => {
        // Assign stored value to HTML toggle with a bias towards true.
        if (!val.extState.manualMode) {
            document.querySelector("#manualMode").checked = false;
        } else {
            document.querySelector("#manualMode").checked = true;
        }
    });
}

document.addEventListener('DOMContentLoaded', restoreState);
document.querySelector("#manualMode").addEventListener('change', saveState);
