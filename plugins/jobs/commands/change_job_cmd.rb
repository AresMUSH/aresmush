module AresMUSH
  module Jobs

    class ChangeTitleCmd
      include SingleJobCmd
      
      attr_accessor :value

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.number = trim_arg(args.arg1)
        self.value = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.number, self.value ]
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|
          Jobs.change_job_title(enactor, job, self.value)
        end
      end
    end
    
    class ChangeCategoryCmd
      include SingleJobCmd
      
      attr_accessor :value

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.number = trim_arg(args.arg1)
        self.value = upcase_arg(args.arg2)
      end
      
      def required_args
        [ self.number, self.value ]
      end
      
      def check_category
        return nil if !self.value
        return t('jobs.invalid_category', :categories => Jobs.categories.join(', ')) if (!Jobs.categories.include?(self.value.upcase))
        return nil
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|
          Jobs.change_job_category(enactor, job, self.value)
        end
      end
    end
    
  end
end
