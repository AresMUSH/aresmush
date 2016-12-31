module AresMUSH
  module Rooms
    class LinkCmd
      include CommandHandler

      attr_accessor :name
      attr_accessor :dest

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.dest = trim_arg(args.arg2)
      end
      
      def required_args
        {
          args: [ self.name, self.dest ],
          help: 'link'
        }
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        find_result = ClassTargetFinder.find(self.dest, Room, enactor)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        dest = find_result.target
          
        find_result = VisibleTargetFinder.find(self.name, enactor)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target
        if (target.class != Exit)
          client.emit_failure(t('rooms.can_only_link_exits'))
          return
        end
        
        target.update(dest: dest)
        client.emit_success t('rooms.exit_linked', :dest => dest.name)
      end
    end
  end
end
