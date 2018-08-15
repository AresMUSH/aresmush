module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)/)
          self.name = titlecase_arg(args.arg1)
          self.armor = titlecase_arg(args.arg2)
          specials_str = titlecase_arg(args.arg3)
        else
          args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
          self.name = enactor.name
          self.armor = titlecase_arg(args.arg1)
          specials_str = titlecase_arg(args.arg2)
        end
      end

      def handle
        client.emit self.name
        client.emit self.armor
      end



    end
  end
end
