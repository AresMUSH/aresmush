module AresMUSH
  module Groups
    class CensusCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'groups'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("census")
      end

      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : "Position"
      end
      
      def handle        
        group = Groups.get_group(self.name)
        
        if (group.nil?)
          client.emit_failure t('groups.invalid_group_type')
          return
        end

        title = t('groups.census_title', :name => self.name)
        
        counts = {}
        Character.all.each do |c|
          next if c.idled_out
          val = c.groups[self.name]
          if (!val.nil?)
            count = counts.has_key?(val) ? counts[val] : 0
            counts[val] = count + 1
          end
        end
        counts = counts.sort_by { |k,v| v }.reverse
        
        if (group['values'].nil?)
          counts = counts.first(10)
          title = t('groups.census_title_top_10', :name => self.name)
        end
        
        list = counts.map { |k, v| "#{k.ljust(20)}#{v}"}
        
        client.emit BorderedDisplay.list list, title
      end
    end
  end
end
