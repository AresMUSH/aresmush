module AresMUSH
  module Profile
    class InfoViewCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :target
      
      def crack!
        self.target = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          template = InfoTemplate.new(model, client)
          template.render
        end
      end
    end
  end
end