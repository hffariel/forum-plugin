import { withPluginApi } from "discourse/lib/plugin-api";
import TopicStatus from "discourse/raw-views/topic-status";

function initializeStarRocksPlugin(api) {
  
  // see app/assets/javascripts/discourse/lib/plugin-api
  // for the functions available via the api object
  
}

export default {
  name: "starrocks-plugin",

  initialize() {
    withPluginApi("0.8.24", initializeStarRocksPlugin);
    TopicStatus.reopen({
      statuses: Ember.computed(function () {
        const results = this._super(...arguments);
        if (!this.topic.sr_fields) {
          return results
        }
        if (this.topic.sr_fields.priority) {
        }
        return results;
      }),
    });
  }
};
