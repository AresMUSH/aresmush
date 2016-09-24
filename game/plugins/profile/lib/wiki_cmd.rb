module AresMUSH
  module Profile
    class WikiCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      attr_accessor :target

      def crack!
        self.target = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          template =  WikiTemplate.new(model)
          client.emit template.render
        end
      end
    end
  end
end
