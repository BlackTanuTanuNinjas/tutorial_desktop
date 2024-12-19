const Native1 = {
  mounted() {
    userAgent = navigator.userAgent;

    // document.getElementById("log").textContent = userAgent;

    if (/Android/.test(userAgent)) {
      document.getElementById("android-ver").textContent =  window.Android.sample1();
    } else if (/Mac/.test(userAgent)) {
      document.getElementById("ios-ver").textContent =  window.webkit.messageHandlers.sample1.postMessage("sample1s");

    }

    const sample1 = (message) => {
      document.getElementById("ios-ver").textContent = message;
    }

    window.callFromNative = sample1;
  },


};

export default Native1;
