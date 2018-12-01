module AresMUSH
  module Scenes
    class WhisperCmd
      include CommandHandler
      
      attr_accessor :name, :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.message = args.arg2
      end
      
      def required_args
        [ self.name, self.message ]
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.name, client, enactor) do |model|          
          if (model.class != Character)
            client.emit_failure t('db.object_not_found')
            return
          end
          
          other_client = Login.find_client(model)
          if (!other_client)
            client.emit_failure t('db.object_not_found')
            return
          end
          
          header = t('scenes.whisper_emit_header')
          whisper = t('scenes.whisper_emit', :name => enactor_name, :target => model.name, :message => self.message)
          other_client.emit "#{model.pose_autospace}#{header}%R#{whisper}"
          client.emit "#{enactor.pose_autospace}#{header}%R#{whisper}"
        end
      end
    end
  end
end
