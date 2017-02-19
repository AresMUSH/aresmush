module AresMUSH
  module Groups
    class GroupsCmd
      include CommandHandler
      
      def handle        
        groups = Groups.all_groups
        template = GroupListTemplate.new groups
        client.emit template.render
      end
    end
  end
end
