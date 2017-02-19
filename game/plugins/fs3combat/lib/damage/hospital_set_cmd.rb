module AresMUSH
  module FS3Combat
    class HospitalSetCmd
      include CommandHandler
            
      attr_accessor :option

      def parse_args
        self.option = OnOffOption.new(cmd.switch)
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !FS3Combat.can_setup_hospitals?(enactor)
        return nil
      end
      
      def check_option
        return self.option.validate
      end
      
      def handle
        enactor.room.update(is_hospital: self.option.is_on?)
        prompt = self.option.is_on? ? t('fs3combat.set_hospital') : t('fs3combat.clear_hospital')
        client.emit_success prompt
      end
    end
  end
end