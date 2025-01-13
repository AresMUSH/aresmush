module AresMUSH
  module Manage
    class BlockCmd
      include CommandHandler
      
      attr_accessor :target, :block_type, :blocked

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = trim_arg(args.arg1)
        self.block_type = downcase_arg(args.arg2)
        self.blocked = cmd.switch_is?("add")
      end
      
      def required_args
        [ self.target, self.block_type ]
      end
      
      def check_type
        types = Global.read_config("manage", "block_types") || []
        return t('manage.invalid_block_type', :types => types.join(" ")) if !types.include?(self.block_type)
        return nil
      end
      
      def check_can_block
        return t('dispatcher.not_allowed') if (enactor.is_npc? || enactor.is_guest?)
        return nil
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          existing = enactor.blocks.select { |b| b.block_type == self.block_type && b.blocked == model }.first
          
          if (self.blocked)
            if (existing)
              client.emit_failure t('manage.already_blocked')
              return
            end
            
            BlockRecord.create(owner: enactor, blocked: model, block_type: self.block_type)
            client.emit_success t('manage.block_added')
          else
            if (!existing)
              client.emit_failure t('manage.not_blocked')
              return
            end
            
            existing.destroy
            client.emit_success t('manage.block_removed')
          end
        end
      end
      
    end
  end
end
