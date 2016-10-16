module AresMUSH
  module FS3Combat
    class DamageCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :name

      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : enactor.name
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          template = DamageTemplate.new(model)
          client.emit template.render
        end
      end
    end
  end
end