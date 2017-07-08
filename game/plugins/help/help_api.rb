module AresMUSH
  module Help
      def self.get_help(topic_key)
        Help.topic_contents(topic_key)
      end
      
      def self.all_help_topics
        Help.help_topics
      end
    
      def self.reload_help
        Help.help_topics = {}

        all_help = Global.help_reader.help

        [ nil, Global.locale.default_locale, Global.locale.locale ].each do |locale|
          Global.logger.info "Loading help for #{locale}."
        
           all_help.select { |h, v| v["locale"] == locale }.each do |path, value|
           
             file_name = File.basename( value["path"], ".md" ).gsub('_', ' ')
             plugin = value["plugin"]
             if (file_name == "index")
               key = plugin
               value["order"] = value["order"] || 1
               if (!value["aliases"])
                 value["aliases"] = [ file_name ]
               else
                 value["aliases"] << file_name
               end
             else
               key = "#{plugin} #{file_name}"
             end
           
             Help.help_topics[key] = value
           end
         end
      end
  end
end
