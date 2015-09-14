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
        template = GroupCensusTemplate.new(Character.active_chars, self.name, client)
        template.render
      end
      
      def show_gender_census
        template = GenderCensusTemplate.new(Character.active_chars, client)
        template.render
      end
      
      def show_complete_census
        template = CompleteCensusTemplate.new(Character.active_chars, self.page, client )
        template.render        
      end   
    end
  end
end
