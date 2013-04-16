module AresMUSH

  module Describe
    class RoomHeaderRenderer < TemplateRenderer
      def initialize(room, container)
        @config_reader = container.config_reader
        @data = HashReader.new(room)
      end

      def template
        @config_reader.config["desc"]["room"]["header"]
      end
      
      def date
        DateTime.now.strftime("%F")
      end
      
    end
    
    class RoomEachCharRenderer < TemplateRenderer
      def initialize(room, container)
        @config_reader = container.config_reader
        @data = HashReader.new(room)
      end

      def template
        @config_reader.config["desc"]["room"]["each_char"]
      end
    end
    
    class RoomEachExitRenderer < TemplateRenderer
      def initialize(room, container)
        @config_reader = container.config_reader
        @data = HashReader.new(room)
      end

      def template
        @config_reader.config["desc"]["room"]["each_exit"]
      end
    end
  end
end