$:.unshift File.dirname(__FILE__)
load "describe_api.rb"
load "lib/desc_edit_cmd.rb"
load "lib/desc_model.rb"
load "lib/describe_cmd.rb"
load "lib/desc_notify_cmd.rb"
load "lib/glance_cmd.rb"
load "lib/details/detail_delete_cmd.rb"
load "lib/details/detail_edit_cmd.rb"
load "lib/details/detail_set_cmd.rb"
load "lib/event_handlers.rb"
load "lib/helpers.rb"
load "lib/look_cmd.rb"
load "lib/outfits/outfit_delete_cmd.rb"
load "lib/outfits/outfit_edit_cmd.rb"
load "lib/outfits/outfit_list_cmd.rb"
load "lib/outfits/outfit_set_cmd.rb"
load "lib/outfits/outfit_view_cmd.rb"
load "lib/scene_set_cmd.rb"
load "lib/scenes_cmd.rb"
load "lib/wear_cmd.rb"
load "templates/char_desc_template_fields.rb"
load "templates/character_template.rb"
load "templates/exit_template.rb"
load "templates/glance_template.rb"
load "templates/room_template.rb"
load "templates/scenes_list_template.rb"

module AresMUSH
  module Describe
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("describe", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/descriptions.md", "help/detail.md", "help/glance.md", "help/outfit.md", "help/look.md", "help/scene.md" ]
    end
 
    def self.config_files
      [ "config_desc.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "describe", "shortdesc"
        case cmd.switch
        when "edit"
          return DescEditCmd
        when "notify"
          return DescNotifyCmd
        when nil
          return DescCmd
        end
      when "detail"
        case cmd.switch
        when "delete"
          return DetailDeleteCmd
        when "edit"
          return DetailEditCmd
        when "set"
          return DetailSetCmd
        when nil
          return LookCmd
        end
      when "glance"
        return GlanceCmd
      when "look"
        return LookCmd
      when "outfit"
        case cmd.switch
        when "delete"
          return OutfitDeleteCmd
        when "edit"
          return OutfitEditCmd
        when "set"
          return OutfitSetCmd
        when nil
          if (cmd.args)
            return OutfitViewCmd
          else
            return OutfitListCmd
          end
        end
      when "scene"
        case cmd.switch
        when "set"
          return SceneSetCmd
        end
      when "scenes"
        return ScenesCmd
      when "wear"
        return WearCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
  end
end