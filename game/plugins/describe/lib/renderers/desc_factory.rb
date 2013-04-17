module AresMUSH
  module Describe
    class DescFactory
      
      def initialize(container)
        @container = container
        @config_reader = container.config_reader
      end
      
      def build(model)
        if (model["type"] == "Room")
          RoomRenderer.new(model, @container)
        elsif (model["type"] == "Character")
          TemplateRenderer.new(char_config, model)
        elsif (model["type"] == "Exit")
          TemplateRenderer.new(exit_config, model)
        else
          raise "Invalid model type: #{model["type"]}"
        end
      end 
      
      def char_config
        @config_reader.config["desc"]["char"]
      end
      
      def room_config
        @config_reader.config["desc"]["room"]
      end
      
      def exit_config
        @config_reader.config["desc"]["exit"]
      end
      
      def hash_reader(model)
        HashReader.new(model)
      end
      
      def build_exit_header
        TemplateRenderer.new(room_config["exit_header"])
      end
      
      def build_each_exit(exit)
        TemplateRenderer.new(room_config["each_exit"], hash_reader(exit))
      end

      def build_chars_header
        TemplateRenderer.new(room_config["chars_header"])
      end
      
      def build_each_char(exit)
        TemplateRenderer.new(room_config["each_char"], hash_reader(exit))
      end
      
      def build_room_footer(room)
        TemplateRenderer.new(room_config["footer"], hash_reader(room))
      end  

      def build_room_header(room)
        TemplateRenderer.new(room_config["header"], hash_reader(room))
      end  
        
    end
  end
end