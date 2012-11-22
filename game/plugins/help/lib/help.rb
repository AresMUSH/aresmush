module AresMUSH
  module Help
    class Help
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("help")
      end

      def on_command(client, cmd)
        handle_help(client, cmd)
      end
      
      def on_anon_command(client, cmd) 
        handle_help(client, cmd)   
      end
      
      def handle_help(client, cmd)
        help = load_help
        topic = cmd.args.to_s
        if (topic.empty?)
          help["index"].each { |k, v| client.emit("    #{k.ljust(15)} -- #{v}") }
        elsif help.has_key?(topic)
          client.emit_with_lines("Help on #{topic}\n#{help[topic]}")
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
