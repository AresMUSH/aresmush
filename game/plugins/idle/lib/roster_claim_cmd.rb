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
      
      def check_roster_enabled
        return t('idle.roster_disabled') if !Idle.roster_enabled?
        return nil
      end
      
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (!model.on_roster?)
            client.emit_failure t('idle.not_on_roster', :name => model.name)
            return
          end
          
          if (model.roster_restricted)
            client.emit_failure t('idle.contact_required')
            return
          end

          password = Login.set_random_password(model)
          model.update(idle_state: nil)
          model.update(terms_of_service_acknowledged: nil)
          
          client.emit_success t('idle.roster_claimed', :name => model.name, :password => password)
          
          welcome_message = Global.read_config("idle", "roster_welcome_msg")
          Mail::Api.send_mail([model.name], t('idle.roster_welcome_msg_subject'), welcome_message, nil)          
          
          bbs = Global.read_config("idle", "arrivals_board")
          return if !bbs
          return if bbs.blank?
        
          Bbs.post(bbs, 
            t('idle.roster_bbs_subject'), 
            t('idle.roster_bbs_body', :name => model.name), 
            Game.master.system_character)
        end
      end
    end
  end
end
