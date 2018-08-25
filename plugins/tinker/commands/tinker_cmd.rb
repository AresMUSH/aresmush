module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end





      def handle
        school = titlecase_arg(cmd.args)
        client.emit enactor.groups.values

        if enactor.groups.values.include? school
          client.emit "yes"
        else
         client.emit t('custom.wrong_school')
        end


      end



    end
  end
end
