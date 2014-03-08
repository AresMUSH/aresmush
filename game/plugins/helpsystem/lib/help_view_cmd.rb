module AresMUSH
  module Help
    
    class HelpCmd
      include AresMUSH::Plugin

      attr_accessor :category
      attr_accessor :topic
            
      def want_command?(client, cmd)
        Help.valid_commands.include?(cmd.root) && !cmd.args.nil?
      end
      
      def crack!
        self.category = Help.category_for_command(cmd.root)
        self.topic = cmd.args
      end
      
      # TODO - Validate permissions
      # TODO - Validate topic exists and show alternatives
      
      def handle
        text = Global.help[self.category][self.topic].chomp
        category_title = Help.category_title(self.category)
        title = t('help.topic', :category => category_title, :topic => self.topic.titlecase)
        client.emit BorderedDisplay.text(text, title.center(78))
      end
      
      def old_handle
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

    end
  end
end
