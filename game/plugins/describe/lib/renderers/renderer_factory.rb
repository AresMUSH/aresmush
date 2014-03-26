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
        self.room_renderer = RoomRenderer.new
        self.exit_renderer = ExitRenderer.new
        self.char_renderer = CharRenderer.new
      end
    end
  end
end