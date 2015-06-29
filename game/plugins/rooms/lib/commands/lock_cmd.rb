module AresMUSH
  module Rooms
    class LockCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :name
      attr_accessor :lock_keys
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'lock'
        super
      end
      
      def want_command?(client, cmd)
        (cmd.root_is?("lock") || cmd.root_is?("unlock")) && cmd.args
      end
            
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.lock_keys = cmd.args.arg2.nil? ? [] : trim_input(cmd.args.arg2).split(" ")
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def check_roles
        return t('rooms.no_roles_specified') if cmd.root_is?("lock") && self.lock_keys.empty?
        
        self.lock_keys.each do |k|
          return t('rooms.exit_lock_not_valid_role', :name => k) if !Roles.valid_role?(k)
        end
        return nil
      end
      
      def handle
        find_result = VisibleTargetFinder.find(self.name, client)
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
          target.lock_keys = []
        else
          target.lock_keys = self.lock_keys
        end
        target.save!
        client.emit_success self.lock_keys.empty? ? t('rooms.exit_unlocked') : t('rooms.exit_locked')
      end
    end
  end
end
