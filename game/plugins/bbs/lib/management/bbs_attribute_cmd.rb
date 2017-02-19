module AresMUSH
  module Bbs
    module  BbsAttributeCmd
      include CommandHandler
           
      attr_accessor :name, :attribute
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.attribute = trim_arg(args.arg2)
      end
      
      def required_args
        {
          args: [ self.name, self.attribute ],
          help: 'bbs'
        }
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Bbs.can_manage_bbs?(enactor)
        return nil
      end
    end
  
    class BbsDescCmd
      include BbsAttributeCmd
    
      def handle
        Bbs.with_a_board(name, client, enactor) do |board|        
          board.update(description: self.attribute)
          client.emit_success t('bbs.desc_set')
        end
      end
    end
    
    class BbsOrderCmd
      include BbsAttributeCmd    
    
      def check_number
        return t('bbs.invalid_board_number') if !self.attribute.is_integer?
        return nil
      end
      
      def handle
        Bbs.with_a_board(name, client, enactor) do |board|        
          board.update(order: self.attribute.to_i)
          client.emit_success t('bbs.order_set')
        end
      end
    end
    
    class BbsRenameCmd
      include BbsAttributeCmd
    
      def handle
        Bbs.with_a_board(name, client, enactor) do |board|        
          board.update(name: self.attribute)
          client.emit_success t('bbs.board_renamed')
        end
      end
    end
    
    class BbsRolesCmd
      include BbsAttributeCmd
    
      def check_roles
        if (self.attribute == "none" || !self.attribute)
          return nil
        end
        self.attribute.split(",").each do |r|
          return t('bbs.invalid_board_role', :name => r) if !Role.found?(r)
        end
        return nil
      end
    
      def handle
        Bbs.with_a_board(name, client, enactor) do |board|
        
          if (self.attribute == "none")
            roles = []
          else
            roles = self.attribute.split(",").map { |r| Role.find_one_by_name(r) }
          end
          
          if (cmd.switch_is?("readroles"))
            board.read_roles.each { |r| board.read_roles.delete r }
            roles.each { |r| board.read_roles.add r }
          else
            board.write_roles.each { |r| board.write_roles.delete r }
            roles.each { |r| board.write_roles.add r }
          end
          client.emit_success t('bbs.roles_set')
        end
      end
    end
  end
end
