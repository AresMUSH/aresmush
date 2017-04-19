module AresMUSH

  module Idle
    class RosterClaimCmd
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
        terms_of_service = Login::Api.terms_of_service
        if (terms_of_service && client.program[:tos_accepted].nil?)
          client.program[:create_cmd] = cmd
          client.emit "%l1%r#{terms_of_service}%r#{t('login.tos_agree')}%r%l1"
          return
        end
        
        client.program.delete(:create_cmd)
        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (!model.on_roster?)
            client.emit_failure t('idle.not_on_roster', :name => model.name)
            return
          end

          password = Login::Api.set_random_password(model)
          model.update(idle_state: nil)
          
          client.emit_success t('idle.roster_claimed', :name => model.name, :password => password)
          
          bbs = Global.read_config("idle", "arrivals_board")
          return if !bbs
          return if bbs.blank?
        
          Bbs::Api.post(bbs, 
            t('idle.roster_bbs_subject'), 
            t('idle.roster_bbs_body', :name => model.name), 
            Game.master.system_character)
        end
      end
    end
  end
end
