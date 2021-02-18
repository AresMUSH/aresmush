module AresMUSH
    module Custom
        class WordCountCmd
            include CommandHandler
      
            attr_accessor :name
      
            def parse_args
              self.name = cmd.args || enactor_name
            end
            
            def handle
                ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
                  word_count = "#{model.name}'s Word Count:", model.pose_word_count
                  msg = word_count.join(" ")
                  client.emit_success msg
                end
            end
        end
    end
end