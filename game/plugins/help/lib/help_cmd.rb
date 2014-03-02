module AresMUSH
  module Help
    class HelpCmd
      include AresMUSH::Plugin
            
      def want_command?(client, cmd)
        cmd.root.end_with?("help")
      end

      # TODO - Validate 
      def handle
        if (!cmd.switch)
          show_help(client, cmd)
        else
          client.emit_success("You reload the help files.")
          load_help        
        end
      end
      
      def help_indices
        Global.config['help']['indices']
      end
      
      def find_index(prefix)
        indices = help_indices
        return indices[0] if prefix.nil?
        indices.each do |i|
           return i if i['prefix'] == prefix
        end
        return nil
      end

      def index_prefix(cmd)
        match = /(?<prefix>\S+)*help/.match(cmd.root)
        match[:prefix]
      end
      
      def get_topics(index)
        @help ||= load_help
        @help[index['name']]
      end
            
      def show_help(client, cmd)
        # This is just a prototype!
        # TODO - Clean up ugly method
        # TODO - write specs
        # TODO - localize
        prefix = index_prefix(cmd)
        index = find_index(prefix)
        topics = get_topics(index)
          
        if topics.nil?
          client.emit_failure("No help files found.") 
          return
        end

        
        topic = cmd.args.to_s.downcase
        title = "%xh#{index['title']}"
        if (!topic.empty?)
          title << " -- #{topic.titlecase}"
        end
        title << "%xn"
        
        if (topic.empty? || topic == "toc")
          toc = topics["toc"]
          if (toc.nil?)
            client.emit_failure("Helpfile table of contents is missing.") 
            return
          end
          msg = ""
          toc.each { |k, v| msg << "\n    #{k.ljust(15)} -- #{v}" }
          client.emit("#{title.center(78)}\n#{msg}")
        elsif topics.has_key?(topic)
          client.emit("#{title.center(78)}\n#{topics[topic]}")
        else
          possible_topics = topics.deep_match(/#{topic}/i)
          topics_string = ""
          possible_topics.map { |k, v| topics_string << k << " "}
          client.emit("Maybe you meant one of these: #{topics_string}")
        end
      end
      
      def load_help        
        help = {}
        PluginManager.help_files.each do |f|
          help = help.merge_yaml(f)
        end      
        help  
      end
    end
  end
end
