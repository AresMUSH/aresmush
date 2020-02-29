module AresMUSH
  module Rooms
    class LockCmd
      include CommandHandler

      attr_accessor :name
      attr_accessor :lock_keys
            
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = trim_arg(args.arg1)
        self.lock_keys = trimmed_list_arg(args.arg2, /,/) || []
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def check_roles
        return t('rooms.no_roles_specified') if cmd.root_is?("lock") && self.lock_keys.empty?
        
        self.lock_keys.each do |k|
          return t('rooms.exit_lock_not_valid_role', :name => k) if !Role.found?(k)
        end
        return nil
      end
      
      def handle
        find_result = VisibleTargetFinder.find(self.name, enactor)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target
        if (target.class != Exit)
          client.emit_failure(t('rooms.can_only_lock_exits'))
          return
        end
        
        if (cmd.root_is?("unlock"))
          target.update(lock_keys: [])
        else
          target.update(lock_keys: self.lock_keys)
        end
        client.emit_success self.lock_keys.empty? ? t('rooms.exit_unlocked') : t('rooms.exit_locked')
      end
    end
  end
end
