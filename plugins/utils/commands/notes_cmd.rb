module AresMUSH
  module Utils
    class NotesCmd
      include CommandHandler
      
      attr_accessor :target, :section

      def parse_args
        if (cmd.args)
          self.target = titlecase_arg(cmd.args)
          self.section = 'admin'
        else
          self.target = enactor_name
          self.section = 'player'
        end
      end

      def check_is_allowed
        return nil if self.section == 'player' && self.target == enactor_name
        return nil if Utils.can_access_notes?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          list = model.notes_section(self.section).map { |k, v| "%ld%R%xh#{k}%xn%R#{v}%R"}
          title = self.section == 'admin' ? t('notes.notes_admin_title', :name => model.name) : t('notes.notes_title', :name => model.name)
          template = BorderedListTemplate.new list, title
          client.emit template.render
        end
      end
    end
  end
end
