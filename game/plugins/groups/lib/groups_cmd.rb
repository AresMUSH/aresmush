module AresMUSH
  module Groups
    class GroupsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("group") && !cmd.args
      end

      def handle        
        groups = Groups.all_groups
                
        list = groups.keys.sort.map { |g| "#{g.ljust(20)} #{groups[g]['desc']}"} 
        client.emit BorderedDisplay.list list, t('groups.group_types_title')
      end
    end
  end
end
