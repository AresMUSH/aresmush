module AresMUSH
  module Utils
    class NotesEditCmd
      include CommandHandler
      
      attr_accessor :target, :section

      def parse_args
        if (!cmd.args)
          self.target = enactor_name
          self.section = 'player'
        else
          args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)
          if (args.arg2)
            self.target = titlecase_arg(args.arg1)
            self.section = downcase_arg(args.arg2)
          else
            self.target = enactor_name
            self.section = downcase_arg(args.arg1)
          end
        end
      end
      
      def required_args
        [ self.section ]
      end
      
      def check_section
        return t('notes.invalid_notes_section', :sections => Utils.note_sections.join(', ')) if !Utils.note_sections.include?(self.section)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          if (!Utils.can_access_notes?(model, enactor, self.section))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          notes = model.notes_section(self.section)
          
          if (self.target == enactor_name)
            Utils.grab client, enactor, "notes/set #{self.section}=#{notes}"
          else
            Utils.grab client, enactor, "notes/set #{self.target}/#{self.section}=#{notes}"
          end
        end
      end
    end
  end
end
