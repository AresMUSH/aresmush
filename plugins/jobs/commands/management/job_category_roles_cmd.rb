module AresMUSH
  module Jobs
    class JobCategoryRolesCmd
      include CommandHandler

      attr_accessor :name, :roles
    
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.roles = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Jobs.can_manage_jobs?(enactor)
        return nil
      end
      
      def check_roles
        if (self.roles == "none" || !self.roles)
          return nil
        end
        self.roles.split(",").each do |r|
          return t('jobs.invalid_category_role', :name => r) if !Role.found?(r)
        end
        return nil
      end
    
      def handle
        Jobs.with_a_category(name, client, enactor) do |category|        
          if (self.roles == "none")
            roles = []
          else
            roles = self.roles.split(",").map { |r| Role.find_one_by_name(r) }
          end

          category.roles.replace(roles)
          
          client.emit_success t('jobs.job_category_roles_set')
        end
      end
    end
  end
end
