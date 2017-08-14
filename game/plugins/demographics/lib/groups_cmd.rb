module AresMUSH
  module Demographics
    class GroupsCmd
      include CommandHandler
      
      def help
        "`groups` - List all group types.\n" +
        "`group <type>` - Shows options available for a group type."
      end

      def handle        
        groups = Demographics.all_groups
        template = GroupListTemplate.new groups
        client.emit template.render
      end
    end
  end
end
