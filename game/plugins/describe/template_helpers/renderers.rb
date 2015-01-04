module AresMUSH
  module Describe
    mattr_accessor :room_renderer, :exit_renderer, :char_renderer
        
    def self.build_renderers
      self.room_renderer = RoomRenderer.new
      self.exit_renderer = ExitRenderer.new
      self.char_renderer = CharRenderer.new
    end
      
    class CharRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/character.erb")
      end
      
      def render(model, client)
        client = model.client
        if (client.nil?)
          return t('db.object_not_found')
        end
        data = CharacterTemplate.new(client)
        @renderer.render(data)
      end
    end
      
    class ExitRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/exit.erb")
      end
      
      def render(model, client)
        data = ExitTemplate.new(model)
        @renderer.render(data)
      end
    end
      
    class RoomRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/room.erb")
      end
      
      def render(model, client)
        data = RoomTemplate.new(model, client)
        @renderer.render(data)
      end
    end
  end
end