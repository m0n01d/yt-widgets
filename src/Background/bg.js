const listeners = new Map();
chrome.runtime.onConnect.addListener(function (port) {
  console.log("connect", port.name);
  switch (port.name) {
    case "yt-widgets-content": {
      listeners.set(port.name, port);

      port.onMessage.addListener((portMsg) => {
        console.log("listenging to content", { portMsg });
      });
    }
    case "yt-widgets-popup": {
      listeners.set(port.name, port);
      port.onMessage.addListener((portMsg) => {
        console.log("listening for popup messages", { portMsg });
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
