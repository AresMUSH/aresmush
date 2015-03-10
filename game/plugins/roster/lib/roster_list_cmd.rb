module AresMUSH

  module Roster
    class RosterListCmd
      include Plugin
      include PluginRequiresLogin
      include TemplateFormatters
      
      attr_accessor :page

      def want_command?(client, cmd)
        cmd.root_is?("roster") && cmd.switch.nil? && cmd.args.nil?
      end

      def crack!
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle
        roster = RosterRegistry.all.sort { |a,b| a.character.name <=> b.character.name }
        list = []
        list << t('roster.roster_column_titles')
        list << "%l2"
        roster.each do |r|
          roster_char = r.character
          app = roster_char.is_approved? ? t('global.y') : t('global.n')
          list << "#{roster_char.name.ljust(30)} #{center(app,10)}   #{r.contact}"
        end
        client.emit BorderedDisplay.paged_list(list, self.page, 15, t('roster.roster_title'))
      end
    end
  end
end
