module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
<<<<<<< HEAD

=======
      
>>>>>>> upstream/master
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        Character.all.select { | c | !c.demographic('enclave') }.each do |c|
           client.emit c.name
        end
      end

    end
  end
end
