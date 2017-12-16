module AresMUSH

  module FS3Skills
    class SkillScanCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        skill_type = FS3Skills.get_ability_type(self.name)
        case skill_type
        when :attribute
          min_rating = 3
        when :action
          min_rating = 2
        else
          min_rating = 1
        end
        chars = Chargen.approved_chars.select { |c| FS3Skills.ability_rating(c, self.name) >= min_rating }
        list = chars.sort_by { |c| c.name }.map { |c| "#{color(c)}#{c.name}#{room_marker(c)}%xn" }
        footer = "%R#{t('fs3skills.skill_scan_footer')}"
        
        template = BorderedListTemplate.new list, t('fs3skills.skill_scan_title', :name => self.name), footer
        client.emit template.render
      end
      
      def color(char)
        char.room == enactor_room ? "%xh%xg" : ""
      end
      
      def room_marker(char)
        char.room == enactor_room ? "*" : ""
      end
    end
  end
end
