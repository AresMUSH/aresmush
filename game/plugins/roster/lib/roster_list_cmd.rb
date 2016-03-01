module AresMUSH

  module Roster
    class RosterListCmd
      include CommandHandler
      include CommandRequiresLogin
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
        template = RosterTemplate.new roster, self.page, client
        template.render
      end
    end
  end
end
