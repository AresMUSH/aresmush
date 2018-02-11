module AresMUSH
  module FS3Combat
    class MountDetailCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end
      
      def check_mounts_allowed
        return t('fs3combat.mounts_disabled') if !FS3Combat.mounts_allowed?
        return nil
      end
      
      def check_valid_mount
        return t('fs3combat.invalid_mount') if !FS3Combat.mount(self.name)
        return nil
      end
      
      def handle
        template = GearDetailTemplate.new(FS3Combat.mount(self.name), self.name, :mount)
        client.emit template.render
      end
    end
  end
end