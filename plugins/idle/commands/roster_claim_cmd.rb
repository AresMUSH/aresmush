module AresMUSH

  module Idle
    class RosterClaimCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
       
      def required_args
        [ self.name ]
      end
      
      def check_roster_enabled
        return t('idle.roster_disabled') if !Idle.roster_enabled?
        return nil
      end
      
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          response = Idle.claim_roster(model)
          if (response[:error])
            client.emit_failure response[:error]
          else
            client.emit_success t('idle.roster_claimed', :name => model.name, :password => response[:password])
          end
        end
      end
    end
  end
end
