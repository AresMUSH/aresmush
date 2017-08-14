module AresMUSH

  module Describe
    class DescEditCmd
      include CommandHandler
      
      attr_accessor :target
      
      def help
        "`describe/edit <name>` - Grabs the existing description into your input buffer"
      end
      
      def parse_args
        self.target = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.target ]
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|
          Utils.grab client, enactor, "#{cmd.root} #{self.target}=#{model.description}"
        end
      end
        
    end
  end
end
