module AresMUSH
  module Demographics
    class GroupsCmd
      include CommandHandler
      
      def handle        
        groups = Demographics.all_groups
        template = GroupListTemplate.new groups
        client.emit template.render
      end
    end
  end
end
