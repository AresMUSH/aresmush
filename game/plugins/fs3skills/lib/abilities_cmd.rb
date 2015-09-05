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
        
        num_pages = FS3Skills.advantages_enabled? ? 7 : 6
        
        if (self.page == 1)
          list = nil
          file = "ratings.txt"
        elsif (self.page == 2)
          list = [ 
            t('fs3skills.points_tutorial_total', :total => Global.read_config("fs3skills", "starting_points"))
            t('fs3skills.points_tutorial_aptitudes')
            t('fs3skills.points_tutorial_action')
            t('fs3skills.points_tutorial_interests', :free => Global.read_config("fs3skills", "free_interests"))
            t('fs3skills.points_tutorial_expertise')
            t('fs3skills.points_tutorial_languages', :free => Global.read_config("fs3skills", "free_languages"))
          ]
          if (FS3Skills.advantages_enabled?)
            list << t('fs3skills.points_tutorial_advantages')
          end
          
          file = "costs.txt"
        elsif (self.page == 3)
          list = FS3Skills.aptitudes.map { |a| "%xh#{a['name'].ljust(20)}%xn #{a['desc']}" }
          file = "aptitudes.txt"
        elsif (self.page == 4)
          list = FS3Skills.action_skills.map { |a| "%xh#{a['name'].ljust(20)}%xn #{a['desc']}" }
          file = "action_skills.txt"
        elsif (self.page == 5)
          list = nil
          file = "interests_expertise.txt"
        elsif (self.page == 6)
          list = FS3Skills.languages
          file = "languages.txt"
        elsif (self.page == 7 && FS3Skills.advantages_enabled?)
          list = FS3Skills.advantages.map { |a| "%xh#{a['name'].ljust(20)}%xn #{a['desc']}" }
          file = "advantages.txt"
        else
          client.emit_failure t('pages.not_that_many_pages')
          return
        end
        dir_path = File.join(AresMUSH.game_path, "plugins", "fs3skills", "ability_pages") 

        text = File.read(File.join(dir_path, file))
        if (list)
          text << "%R%R#{list.join("%R")}"
        end
        footer = t('pages.page_x_of_y', :x => self.page, :y => num_pages)
        footer = "%x!#{footer.center(78, '-')}%xn"
        client.emit BorderedDisplay.text(text, nil, true, footer)
      end
    end
  end
end
