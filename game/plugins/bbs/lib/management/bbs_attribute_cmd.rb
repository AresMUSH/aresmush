module AresMUSH
  module Bbs
    module  BbsAttributeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name, :attribute

      def initialize
        self.required_args = ['name', 'attribute']
        self.help_topic = 'bbs'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.attribute = trim_input(cmd.args.arg2)
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Bbs.can_manage_bbs?(client.char)
        return nil
      end
    end
  
    class BbsDescCmd
      include BbsAttributeCmd
    
      def handle
        Bbs.with_a_board(name, client) do |board|        
          board.description = self.attribute
          board.save
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
        Bbs.with_a_board(name, client) do |board|        
          board.order = self.attribute.to_i
          board.save
          client.emit_success t('bbs.order_set')
        end
      end
    end
    
    class BbsRenameCmd
      include BbsAttributeCmd
    
      def handle
        Bbs.with_a_board(name, client) do |board|        
          board.name = self.attribute
          board.save
          client.emit_success t('bbs.board_renamed')
        end
      end
    end
    
    class BbsRolesCmd
      include BbsAttributeCmd
    
      def check_roles
        if (self.attribute == "none" || self.attribute.nil?)
          return nil
        end
        self.attribute.split(",").each do |r|
          return t('bbs.invalid_board_role', :name => r) if !Roles::Api.valid_role?(r)
        end
        return nil
      end
    
      def handle
        Bbs.with_a_board(name, client) do |board|
        
          if (self.attribute == "none")
            roles = []
          else
            roles = self.attribute.split(",")
          end
          
          if (cmd.switch_is?("readroles"))
            board.read_roles = roles.map { |r| r.capitalize }
          else
            board.write_roles = roles.map  { |r| r.capitalize }
          end
          board.save
          client.emit_success t('bbs.roles_set')
        end
      end
    end
  end
end
