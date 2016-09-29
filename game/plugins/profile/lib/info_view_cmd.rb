module AresMUSH
  module Profile
    class InfoViewCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :target
      
      def crack!
        self.target = !cmd.args ? enactor_name : trim_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          template = InfoTemplate.new(model, client)
          client.emit template.render
        end
      end
    end
  end
end