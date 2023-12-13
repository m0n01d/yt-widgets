const listeners = new Map();
chrome.runtime.onConnect.addListener(function (port) {
  switch (port.name) {
    case "yt-widgets-content": {
      listeners.set(port.name, port);
      port.onMessage.addListener((popupMsg) => {
        console.log("content listening...");
      });
    }
    case "yt-widgets-popup": {
      listeners.set(port.name, port);
      console.log("popup listening...");

      port.onMessage.addListener((popupMsg) => {
        const contentPort = listeners.get("yt-widgets-content");
        if (contentPort) {
          contentPort.postMessage({
            tag: "init",
            payload: "TitleChecker",
          });
        }
      });
    }
  }
  port.onDisconnect.addListener(() => {
    listeners.delete(port.name);
  });
});
