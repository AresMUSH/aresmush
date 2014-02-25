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
        self.build_room_renderer
        self.build_exit_renderer
        self.build_char_renderer
      end
      
      def self.build_room_renderer
        room_header_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/room/header.lq")
        room_char_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/room/character.lq")
        room_exit_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/room/exit.lq")
        room_footer_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/room/footer.lq")
        self.room_renderer = RoomRenderer.new(room_header_template, room_char_template, room_exit_template, room_footer_template)
      end
      
      def self.build_exit_renderer
        template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/exit/exit.lq")
        self.exit_renderer = ExitRenderer.new(template)
      end
      
      def self.build_char_renderer
        template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/character/character.lq")
        self.char_renderer = CharRenderer.new(template)        
      end
    end
  end
end