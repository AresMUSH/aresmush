module AresMUSH
  module Scenes
    class TepeColorCmd
      include CommandHandler

      attr_accessor :option

      def parse_args
        self.option = trim_arg(cmd.args)
      end

      def handle
        if (!self.option)
          enactor.update(pose_tepe_color: nil)
          message = t('scenes.tepe_color_cleared')
        else
          enactor.update(pose_tepe_color: self.option)
          message = t('scenes.tepe_color_set', :option => self.option)
        end

        client.emit_success message

      end
    end
  end
end
