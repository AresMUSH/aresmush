module AresMUSH
  module Manage
    class BlockCmd
      include CommandHandler
      
      attr_accessor :target, :block_type, :blocked, :all_types

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = trim_arg(args.arg1)
        self.block_type = downcase_arg(args.arg2)
        self.blocked = cmd.switch_is?("add")
        self.all_types = Manage.block_types
      end
      
      def required_args
        [ self.target, self.block_type ]
      end
      
      def check_type
        return nil if self.block_type == 'all'
        return t('manage.invalid_block_type', :types => self.all_types.join(" ")) if !self.all_types.include?(self.block_type)
        return nil
      end
      
      def check_can_block
        return t('dispatcher.not_allowed') if (enactor.is_npc? || enactor.is_guest?)
        return nil
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |target|
          types = self.block_type == "all" ? Manage.block_types : [ self.block_type ]
          types.each do |type|
          
            if (self.blocked)
              message = Manage.add_block(enactor, target, type)
              if (message)
                client.emit_failure message
              else
                client.emit_success t('manage.block_added', :name => target.name, :type => type)
              end
            else
              message = Manage.remove_block(enactor, target, type)
              if (message)
                client.emit_failure message
              else
                client.emit_success t('manage.block_removed', :name => target.name, :type => type)
              end
            end
          end
        end
      end
    end      
  end
end
