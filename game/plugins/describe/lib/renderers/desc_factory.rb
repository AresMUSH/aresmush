module AresMUSH
  module Describe
    class DescFactory
      
      def initialize(container)
        @container = container
        @config_reader = container.config_reader
      end
      
      def build(model)
        if (model["type"] == "Room")
          RoomRenderer.new(model, self, @container)
        elsif (model["type"] == "Character")
          TemplateRenderer.new(char_config, hash_reader(model))
        elsif (model["type"] == "Exit")
          TemplateRenderer.new(exit_config, hash_reader(model))
        else
          raise "Invalid model type: #{model["type"]}"
        end
      end 
      
      def hash_reader(model)
        HashReader.new(model)
      end
      
      def char_config
        @config_reader.config["desc"]["char"]
      end
      
      def exit_config
        @config_reader.config["desc"]["exit"]
      end
      
      def room_config
        @config_reader.config["desc"]["room"]
      end
      
      def build_room_exit_header(room)
        TemplateRenderer.new(room_config["exit_header"], hash_reader(room))
      end
      
      def build_room_each_exit(exit)
        TemplateRenderer.new(room_config["each_exit"], hash_reader(exit))
      end

      def build_room_char_header(room)
        TemplateRenderer.new(room_config["char_header"], hash_reader(room))
      end
      
      def build_room_each_char(exit)
        TemplateRenderer.new(room_config["each_char"], hash_reader(exit))
      end
      
      def build_room_footer(room)
        TemplateRenderer.new(room_config["footer"], hash_reader(room))
      end  

      def build_room_header(room)
        RoomHeaderRenderer.new(room_config["header"], hash_reader(room))
      end  
        
    end
  end
end