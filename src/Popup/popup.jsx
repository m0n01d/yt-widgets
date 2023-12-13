import { createRoot } from "react-dom/client";
//@TODO convert to rescript

const port = chrome.runtime.connect({ name: "yt-widgets-popup" });

const root = createRoot(document.getElementById("app"));

const PopUp = () => (
  <div>
    <button onClick={handleClick}>Load Title Checker</button>
  </div>
);

root.render(<PopUp />);

function handleClick() {
  port.postMessage({ payload: "load-title-checker" });
}
