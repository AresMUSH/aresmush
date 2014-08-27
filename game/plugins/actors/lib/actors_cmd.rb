module AresMUSH

  module Actors
    class ActorsListCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :page

      def want_command?(client, cmd)
        cmd.root_is?("actors") && cmd.switch.nil?
      end

      def crack!
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle
        list = ActorRegistry.all.sort { |a,b| a.charname <=> b.charname }
        list = list.map { |a| "#{a.charname.ljust(25)} #{a.actor}" }
        client.emit BorderedDisplay.paged_list(list, self.page, 15, t('actors.actors_title'))
      end
    end
  end
end
