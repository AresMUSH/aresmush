module AresMUSH

  module FS3Skills
    class AbilitiesCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :page

      def crack!
        self.page = !cmd.page ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle
        
        num_pages = 6
        
        case self.page
        when 1
          template = AbilityPageTemplate.new("/ratings.erb", {})
        when 2
          template = AbilityPageTemplate.new("/costs.erb", {
            starting_points: Global.read_config("fs3skills", "starting_points"),
            free_interests: Global.read_config("fs3skills", "free_interests"),
            free_languages: Global.read_config("fs3skills", "free_languages")
          })
        end
        
          client.emit template.render
        
        return 
        if (self.page == 2)
          #list = [ 
          #  , :total => ),
          #  t('fs3skills.points_tutorial_aptitudes'),
          #  t('fs3skills.points_tutorial_action'),
          #  t('fs3skills.points_tutorial_interests', :free => ),
          #  t('fs3skills.points_tutorial_expertise'),
          #  t('fs3skills.points_tutorial_languages', :free => )
          #]
          if (FS3Skills.advantages_enabled?)
            list << t('fs3skills.points_tutorial_advantages')
          end
          
          file = "costs.txt"
        elsif (self.page == 3)
          list = FS3Skills.aptitudes.map { |a| "%xh#{a['name'].ljust(20)}%xn #{a['desc']}" }
          file = "aptitudes.txt"
        elsif (self.page == 4)
          list = FS3Skills.action_skills.map { |a| "%xh#{a['name'].ljust(20)}%xn (#{a['linked_attr']}) #{a['desc']}" }
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
