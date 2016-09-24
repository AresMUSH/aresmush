module AresMUSH

  module Roster
    class RosterViewCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'roster'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          registry = model.roster_registry
          
          if (!registry)
            client.emit_failure t('roster.not_on_roster', :name => model.name)
            return
          end
          
          template = RosterDetailTemplate.new model, registry
          client.emit template.render
        end
      end
    end
  end
end
