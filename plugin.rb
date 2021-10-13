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

  add_to_class(:topic, :get_sr_fields) do
    self.custom_fields['sr_fields']
  end

  add_to_serializer(:topic_view, :sr_fields) do
    object.topic.get_sr_fields
  end

  add_to_serializer(:listable_topic, :sr_fields) do
    object.get_sr_fields
  end

  add_to_serializer(:topic_list_item, :sr_fields) do
    object.get_sr_fields
  end

  Topic.register_custom_field_type("sr_fields", :json)
  TopicList.preloaded_custom_fields << "sr_fields"
  CategoryList.preloaded_topic_custom_fields << "sr_fields"
  Search.preloaded_topic_custom_fields << "sr_fields"
  
  require_dependency "application_controller"
  class StarRocksPlugin::StarRocksController < ::ApplicationController
  
    def set_fields
      # if guardian.is_staff?
      #   render json: {
      #     "message": "No privilege."
      #   }
      #   return true
      # end
      # post = Post.find(params[:id].to_i)
      # topic = post.topic
      # topic.custom_fields["sr_fields"] = params[:sr_fields].to_h
      # topic.save!
      render json: success_json
    end
  end

  StarRocksPlugin::Engine.routes.draw do
    post "/set-fields" => "starrocks#set_fields"
  end

  Discourse::Application.routes.append do
    mount ::StarRocksPlugin::Engine, at: "starrocks"
  end
  
end
