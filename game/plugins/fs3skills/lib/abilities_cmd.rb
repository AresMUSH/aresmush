module AresMUSH

  module FS3Skills
    class AbilitiesCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :page

      def want_command?(client, cmd)
        cmd.root_is?("abilities")
      end

      def crack!
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle
        if (self.page == 1)
          list = FS3Skills.aptitudes.map { |a| "%xh#{a['name'].ljust(20)}%xn #{a['desc']}" }
          title = t('fs3skills.attributes_title')
        elsif (self.page == 2)
          list = FS3Skills.action_skills.map { |a| "%xh#{a['name'].ljust(20)}%xn #{a['desc']}" }
          title = t('fs3skills.action_skills_title')
        elsif (self.page == 3)
          list = [ t('fs3skills.interests_and_expertise')]
          title = t('fs3skills.interests_and_expertise_title')
        elsif (self.page == 4)
          list = FS3Skills.languages
          title = t('fs3skills.languages_title')
        elsif (self.page == 5)
          list = FS3Skills.advantages.map { |a| "%xh#{a['name'].ljust(20)}%xn #{a['desc']}" }
          title = t('fs3skills.advantages_title')
        else
          client.emit_failure t('pages.not_that_many_pages')
          return
        end
        footer = t('pages.page_x_of_y', :x => self.page, :y => 4)
        footer = "%x!#{footer.center(78, '-')}%xn"
        client.emit BorderedDisplay.list(list, title, footer)
      end
    end
  end
end
