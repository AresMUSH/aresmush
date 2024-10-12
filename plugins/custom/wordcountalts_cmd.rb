module AresMUSH
    module Custom
        class WordCountAltsCmd
            include CommandHandler
  
            attr_accessor :name
  
            def parse_args
              self.name = enactor_name
            end
      
            def alts
              alt_list = AresCentral.alts(enactor).map { |c| c.name }
            end
  
            def format_number(number)
              number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
            end
     
            def handle
  
              @alt_tot_word_count = Array.new()
              @alt_tot_scene_count = Array.new()
  
              ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
              
              msg = "#{model.ooc_name}'s word count statistics:\n"
              client.emit_success msg
  
              end
  
              alts.sort.each {
                |n| 
                current_alt = "#{n}"
                ClassTargetFinder.with_a_character(current_alt, client, enactor) do |model|
                  word_count = model.pose_word_count
                  scene_count = model.scenes_participated_in.size
  
                  @alt_tot_word_count << word_count
                  @alt_tot_scene_count << scene_count
  
                  if scene_count <1
                    msg = "#{model.name} does not have any saved scenes."
                    client.emit msg
                  else
                    words_per_scene = word_count / scene_count
                    word_count = format_number(word_count)
                    scene_count = format_number(scene_count)
                    words_per_scene = format_number(words_per_scene)
                    fmt_msg = "#{model.name} has written", word_count, "words in", scene_count, "scenes for an average of", words_per_scene, "per scene."
                    msg = fmt_msg.join(" ")
                    client.emit msg
                  end
                end
              }
  
              alt_total_words = @alt_tot_word_count.sum
              alt_total_words = format_number(alt_total_words)
              alt_total_scenes = @alt_tot_scene_count.sum
              alt_total_scenes = format_number(alt_total_scenes)
              total_alts = alts.size
              
              client.emit "\n"
              fmt_msg = "Total:", alt_total_words, "words in", alt_total_scenes, "scenes with", total_alts, "alts."
              msg = fmt_msg.join(" ")
              client.emit_success msg
  
            end
        end
    end
  end