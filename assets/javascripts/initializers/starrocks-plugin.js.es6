import { withPluginApi } from "discourse/lib/plugin-api";

function initializeStarRocksPlugin(api) {
  
  // see app/assets/javascripts/discourse/lib/plugin-api
  // for the functions available via the api object
  
}

export default {
  name: "starrocks-plugin",

  initialize() {
    withPluginApi("0.8.24", initializeStarRocksPlugin);
    alert(111)
  }
};
