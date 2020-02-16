module AresMUSH
  module Utils
    class NotesSetCmd
      include CommandHandler
      
      attr_accessor :name, :text, :target, :section

      def parse_args
        # Admin version
        if (cmd.args =~ /[^=]+\//)
          args = cmd.parse_args(ArgParser.arg1_slash_arg2_equals_arg3)
          self.target = titlecase_arg(args.arg1)
          self.section = downcase_arg(args.arg2)
          self.text = trim_arg(args.arg3)
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target = enactor_name
          self.section = downcase_arg(args.arg1)
          self.text = trim_arg(args.arg2)
        end
      end
      
      def required_args
        [ self.section, self.text ]
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
          
          model.update_notes_section(self.section, self.text)

          client.emit_success t('notes.notes_set')
        end
      end
    end
  end
end
