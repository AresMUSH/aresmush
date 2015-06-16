module AresMUSH
  module Groups
    class CensusCmd
      include Plugin
      include PluginRequiresLogin
      include TemplateFormatters
      
      attr_accessor :name, :page
     
      def want_command?(client, cmd)
        cmd.root_is?("census")
      end

      def crack!
        self.name = titleize_input(cmd.args)
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle   
        if (!self.name)
          show_complete_census
        elsif (self.name == "Gender")
          show_gender_census
        else
          show_group_census
        end
      end
      
      def show_group_census  
        group = Groups.get_group(self.name)
        
        if (group.nil?)
          client.emit_failure t('groups.invalid_group_type')
          return
        end

        title = t('groups.group_census_title', :name => self.name)
        list = count_by { |c| c.groups[self.name] }
        
        if (group['values'].nil?)
          list = list.first(20)
          title = t('groups.census_title_top_20', :name => self.name)
        end
        
        client.emit BorderedDisplay.list list, title
      end
      
      def show_gender_census
        title = t('groups.gender_census_title')
        list = count_by { |c| c.gender }
        client.emit BorderedDisplay.list list, title
      end
      
      def show_complete_census
        chars = Character.all.select { |c| !c.idled_out }.sort_by { |c| c.name }
        census = chars.map { |c| CensusTemplate.new(c).display }
        
        client.emit BorderedDisplay.paged_list(census, self.page, 15, t('groups.full_census_title'))
        
      end
      
      def count_by(&block)
        counts = {}
        Character.all.each do |c|
          next if c.idled_out
          val = yield(c)
          if (!val.nil?)
            count = counts.has_key?(val) ? counts[val] : 0
            counts[val] = count + 1
          end
        end
        counts = counts.sort_by { |k,v| v }.reverse
        counts.map { |k, v| "#{k.ljust(20)}#{v}"}
      end
      
    end
  end
end
