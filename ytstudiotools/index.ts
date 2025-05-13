import { initMaterialTailwind } from "@material-tailwind/html";

type ElmPagesInit = {
  load: (elmLoaded: Promise<unknown>) => Promise<void>;
  flags: unknown;
};

const config: ElmPagesInit = {
  load: async function (elmLoaded) {
    initMaterialTailwind();
    // https://www.material-tailwind.com/docs/v3/html/installation
    // @TODO clean up imports
    const app = await elmLoaded;
    console.log("App loaded", app);
  },
  flags: function () {
    return "You can decode this in Shared.elm using Json.Decode.string!";
  },
};

export default config;
