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

  add_to_class(:topic, :get_sr_topic_fields) do
    self.custom_fields['sr_topic_fields']
  end

  add_to_serializer(:topic_view, :sr_topic_fields) do
    object.topic.get_sr_topic_fields
  end

  add_to_serializer(:listable_topic, :sr_topic_fields) do
    object.get_sr_topic_fields
  end

  add_to_serializer(:topic_list_item, :sr_topic_fields) do
    object.get_sr_topic_fields
  end

  Post.add_permitted_post_create_param("sr_topic_fields")
  Topic.register_custom_field_type("sr_topic_fields", :json)
  TopicList.preloaded_custom_fields << "sr_topic_fields"
  CategoryList.preloaded_topic_custom_fields << "sr_topic_fields"
  Search.preloaded_topic_custom_fields << "sr_topic_fields"
  PostRevisor.track_topic_field("sr_topic_fields".to_sym) do |tc, tf|
    tc.record_change("sr_topic_fields", tc.topic.custom_fields["sr_topic_fields"], tf)
    tc.topic.custom_fields["sr_topic_fields"] = tf
  end
  
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
