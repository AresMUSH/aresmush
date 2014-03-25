module AresMUSH
  module Describe
    module RendererFactory
      def self.room_renderer=(renderer)
        @@room_renderer = renderer
      end
    
      def self.room_renderer
        @@room_renderer
      end
    
      def self.char_renderer=(renderer)
        @@char_renderer = renderer
      end
    
      def self.char_renderer
        @@char_renderer
      end
    
      def self.exit_renderer=(renderer)
        @@exit_renderer = renderer
      end
    
      def self.exit_renderer
        @@exit_renderer
      end
      
      def self.build_renderers
        self.room_renderer = build_room_renderer
        self.exit_renderer = build_exit_renderer
        self.char_renderer = build_char_renderer
      end
      
      def self.build_room_renderer
        TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/room.erb")
      end
      
      def self.build_exit_renderer
        TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/exit.erb")
      end
      
      def self.build_char_renderer
        TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/character.erb")
      end
    end
  end
end