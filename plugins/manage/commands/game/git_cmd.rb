module AresMUSH
  module Manage
    class GitCmd
      include CommandHandler
      
      attr_accessor :args
      
      def parse_args
        self.args = cmd.args
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end
      
      def check_command
        commands = [
          "git commit -m ",
          "git add",
          "git pull",
          "git status",
          "git diff"
        ]
        commands.each do |c|
          if (cmd.raw.downcase.start_with?(c))
            return nil
          end
        end
        return t('manage.invalid_git_command', :commands => commands.join(', '))
      end

      def handle
        Global.dispatcher.spawn("Doing git query", client) do
          output = `git #{self.args} 2>&1`
          client.emit_success t('manage.git_output', :output => output)
        end
      end
    end
  end
end
