# name: StarRocksPlugin
# about:
# version: 0.1
# authors: starrocks
# url: https://github.com/starrocks


register_asset "stylesheets/common/starrocks-plugin.scss"


enabled_site_setting :starrocks_plugin_enabled

PLUGIN_NAME ||= "StarRocksPlugin".freeze

after_initialize do
  
  # see lib/plugin/instance.rb for the methods available in this context
  

  module ::StarRocksPlugin
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace StarRocksPlugin
    end
  end

  add_to_class(:topic, :sr_priority?) do 
    custom_fields['sr_priority'] == ''
  end

  add_to_serializer(:topic_view, :sr_priority) do
    topic.sr_priority
  end

  add_to_serializer(:listable_topic, :sr_priority) do
    object.sr_priority
  end

  add_to_serializer(:topic_list_item, :sr_priority) do
    object.sr_priority
  end

  TopicList.preloaded_custom_fields << "sr_priority"
  CategoryList.preloaded_topic_custom_fields << "sr_priority"
  Search.preloaded_topic_custom_fields << "sr_priority"

  
  require_dependency "application_controller"
  class StarRocksPlugin::ActionsController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    before_action :ensure_logged_in

    def list
      render json: success_json
    end
  end

  StarRocksPlugin::Engine.routes.draw do
    get "/list" => "actions#list"
  end

  Discourse::Application.routes.append do
    mount ::StarRocksPlugin::Engine, at: "/starrocks-plugin"
  end
  
end
