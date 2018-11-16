module AresMUSH
  module Forum
    module  BbsAttributeCmd
      include CommandHandler
           
      attr_accessor :name, :attribute
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.attribute = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.attribute ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Forum.can_manage_forum?(enactor)
        return nil
      end
    end
  
    class ForumDescCmd
      include BbsAttributeCmd
    
      def handle
        Forum.with_a_category(name, client, enactor) do |category|        
          category.update(description: self.attribute)
          client.emit_success t('forum.desc_set')
        end
      end
    end
    
    class ForumOrderCmd
      include BbsAttributeCmd    
    
      def check_number
        return t('forum.invalid_category_number') if !self.attribute.is_integer?
        return nil
      end
      
      def handle
        Forum.with_a_category(name, client, enactor) do |category|        
          order = self.attribute.to_i
          category.update(order: order)
          
          BbsBoard.all.each do |other_cat|
            if (other_cat.order >= order && other_cat != category)
              other_cat.update(order: other_cat.order + 1)
            end
          end
            
          client.emit_success t('forum.order_set')
        end
      end
    end
    
    class ForumRenameCmd
      include BbsAttributeCmd
    
      def handle
        Forum.with_a_category(name, client, enactor) do |category|        
          category.update(name: titlecase_arg(self.attribute))
          client.emit_success t('forum.category_renamed')
        end
      end
    end
    
    class ForumRolesCmd
      include BbsAttributeCmd
    
      def check_roles
        if (self.attribute == "none" || !self.attribute)
          return nil
        end
        self.attribute.split(",").each do |r|
          return t('forum.invalid_category_role', :name => r) if !Role.found?(r)
        end
        return nil
      end
    
      def handle
        Forum.with_a_category(name, client, enactor) do |category|
        
          if (self.attribute == "none")
            roles = []
          else
            roles = self.attribute.split(",").map { |r| Role.find_one_by_name(r) }
          end
          
          if (cmd.switch_is?("readroles"))
            category.read_roles.each { |r| category.read_roles.delete r }
            roles.each { |r| category.read_roles.add r }
          else
            category.write_roles.each { |r| category.write_roles.delete r }
            roles.each { |r| category.write_roles.add r }
          end
          client.emit_success t('forum.roles_set')
        end
      end
    end
  end
end
