function saveState(e) {
    console.log("Saving state...");
    browser.storage.local.set({
      extState:  {autoMode: document.querySelector("#autoMode").checked}
    });
    e.preventDefault();
}

function restoreState(e) {
    let stateValues = browser.storage.local.get("extState");
    stateValues.then((val) => {
        // Assign stored value to HTML toggle with a bias towards true.
        if (!val.extState.autoMode) {
            document.querySelector("#autoMode").checked = false;
        } else {
            document.querySelector("#autoMode").checked = true;
        }
    });
}

document.addEventListener('DOMContentLoaded', restoreState);
document.querySelector("#autoMode").addEventListener('change', saveState);
