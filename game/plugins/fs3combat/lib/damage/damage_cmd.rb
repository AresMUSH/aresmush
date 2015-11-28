module AresMUSH
  module FS3Combat
    class DamageCmd
      include CommandHandler
      include CommandRequiresLogin
      include TemplateFormatters
      
      attr_accessor :name

      def want_command?(client, cmd)
        cmd.root_is?("damage") && cmd.switch.nil?
      end
      
      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : client.char.name
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          template = DamageTemplate.new(model, client)
          template.render
        end
      end
    end
  end
end