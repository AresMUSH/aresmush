module AresMUSH
  module Scenes
    class SceneReportCmd
      include CommandHandler
           
      attr_accessor :scene_num, :reason
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.scene_num = integer_arg(args.arg1)
        self.reason = args.arg2
      end
      
      def required_args
        [ self.scene_num, self.reason ]
      end
      
      def handle
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          Scenes.report_scene(enactor, scene, self.reason) 
          client.emit_success t('scenes.scene_reported')
        end
      end
    end  
  end
end