module AresMUSH
  module Manage
    class LoadGitCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        output = `git pull 2>&1`
        client.emit_success t('manage.git_output', :output => output)
        client.emit_ooc t('manage.load_all')
        error = Manage.load_all
        if (error)
          client.emit_failure error
        else
          client.emit_success t('manage.load_all_complete')
        end
      end

    end
  end
end
