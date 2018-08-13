module AresMUSH
  module Custom
    class SetSchoolsCmd
      include CommandHandler
# school/set <name>=<major/minor>/<school>` - Set a school on a character and sets their matching attribute to 1 (minor) or 2(major).
      
      attr_accessor :school_type, :char, :school

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        self.char = Character.find_one_by_name(args.arg1)
        self.school_type = titlecase_arg(args.arg2)
        self.school = titlecase_arg(args.arg3)
      end
        
      def check_can_set
        return nil if enactor_name == self.char
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end      
      
      def check_chargen_locked
        return nil if FS3Skills.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
        
        
      def handle   
        school_list = Global.read_config("schools")
        if school_list.include?(self.school)
          client.emit "Name: #{self.char.name} Type: #{school_type} School: #{self.school}"
          if school_type == "Major"
            self.char.update(major_school: self.school)          
            client.emit_success "You set #{self.char.name}'s major school to #{self.school}. "
            FS3Skills.set_ability(client, self.char, self.school, 2)
          elsif school_type == "Minor"
            self.char.update(minor_school: self.school)
            client.emit_success "You set #{self.char.name}'s minor school to #{self.school}."
            FS3Skills.set_ability(client, self.char, self.school, 1)          
          else client.emit_failure "That is not a type of school. Choose major or minor."
          end
        else
          client.emit_failure "That is not a school of magic. Type 'schools' to see the list of schools."
        end
       end       
        
        
    end
  end
end