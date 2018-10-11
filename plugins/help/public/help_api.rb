module AresMUSH
  module Help
      def self.get_help(topic_key)
        topics = Help.find_topic(topic_key)
        Help.topic_contents(topics.first)
      end
      
      def self.reload_help
        AresMUSH.with_error_handling(nil, "Loading help.") do
          Global.help_reader.clear_help
          Global.help_reader.load_game_help
          Global.plugin_manager.all_plugin_folders.each do |name|
            Global.plugin_manager.load_plugin_help_by_name name
          end
        end
      end
  end
end
