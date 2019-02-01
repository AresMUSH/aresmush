module AresMUSH
  module Scenes
    class SceneHomeCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = !cmd.args ? nil : cmd.args.downcase
      end

      def required_args
        [ self.option ]
      end
      
      def check_option
        options = [ 'ooc', 'home', 'work' ]
        return nil if options.include?(self.option)
        t('scenes.invalid_home_option', :options => options.join(", "))
      end
      
      def check_option_set
        return t('scenes.no_home_set') if self.option == 'home' && !enactor.room_home
        return t('scenes.no_work_set') if self.option == 'work' && !enactor.room_work
        return nil
      end
      
      def handle
        enactor.update(scene_home: self.option)
        client.emit_success t('scenes.scene_home_set', :option => self.option)
      end
    end
  end
end
