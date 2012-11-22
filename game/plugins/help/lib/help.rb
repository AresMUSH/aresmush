module AresMUSH
  module Help
    class Help
      include AresMUSH::Plugin

      def after_initialize
        @config_reader = container.config_reader
      end
      
      def want_command?(cmd)
        cmd.root.end_with?("help")
      end

      def on_command(client, cmd)
        handle_help(client, cmd)
      end
      
      def on_anon_command(client, cmd) 
        handle_help(client, cmd)   
      end
      
      def help_index(prefix)
        indices = @config_reader.config['help']['indices']
        return indices[0] if prefix.nil?
        indices.each do |i|
           return i if i['prefix'] == prefix
        end
        return nil
      end
      
      def handle_help(client, cmd)
        # TODO - Clean up ugly method
        # TODO - write specs
        # TODO - localize
        # TODO - implement locking
        match = /(?<prefix>\S+)*help/.match(cmd.root)
        index = help_index(match[:prefix])        
        help = load_help[index['index']]
        if help.nil?
          client.emit_failure("No help files found.") 
          return
        end
        topic = cmd.args.to_s
        if (topic.empty?)
          help["index"].each { |k, v| client.emit("    #{k.ljust(15)} -- #{v}") }
        elsif help.has_key?(topic)
          title = "#{index['title']} -- #{topic}"
          client.emit_with_lines("#{title.center(78)}\n#{help[topic]}")
        else
          possible_topics = help.deep_match(/#{topic}/)
          topics_string = ""
          possible_topics.map { |k, v| topics_string << k << " "}
          client.emit_with_lines("Maybe you meant one of these: #{topics_string}")
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
