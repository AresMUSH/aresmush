module AresMUSH

  module Roster
    class RosterViewCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'roster'
        }
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
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
