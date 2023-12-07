import { createRoot } from "react-dom/client";
import { make as Popup } from "./Popup.bs.mjs";

const root = createRoot(document.getElementById("app"));
//root.render(<h1>Hello, world</h1>);

root.render(<Popup />);
