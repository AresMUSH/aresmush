module AresMUSH

  module Idle
    class RosterClaimCmd
      include CommandHandler
      
      attr_accessor :name, :app
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = titlecase_arg(args.arg1)
        self.app = trim_arg(args.arg2)
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
          response = Idle.claim_roster(model, enactor, self.app)
          if (response[:error])
            client.emit_failure response[:error]
          elsif (response[:password])
            client.emit_success t('idle.roster_claimed', :name => model.name, :password => response[:password])
          else
            client.emit_success t('idle.roster_app_submitted', :name => model.name)
          end
          Global.logger.debug "Roster #{model.name} claimed by #{enactor_name} - #{client.ip_addr}."
        end
      end
    end
  end
end
