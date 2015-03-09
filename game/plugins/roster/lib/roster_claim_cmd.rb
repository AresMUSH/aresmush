module AresMUSH

  module Roster
    class RosterClaimCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'roster'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("roster") && cmd.switch_is?("claim")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          if (!model.roster_registry)
            client.emit_failure t('roster.not_on_roster', :name => model.name)
            return
          end

          password = Character.random_link_code
          model.change_password(password)
          model.roster_registry.destroy
          
          model.save
          client.emit_success t('roster.roster_claimed', :name => model.name, :password => password)
          
          bbs = Global.config['roster']['arrivals_board']
          return if !bbs
          return if bbs.blank?
        
          Bbs.post(bbs, 
            t('roster.roster_bbs_subject'), 
            t('roster.roster_bbs_body', :name => model.name), 
            Game.master.system_character)
        end
      end
    end
  end
end
