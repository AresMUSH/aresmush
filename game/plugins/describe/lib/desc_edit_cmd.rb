module AresMUSH

  module Describe
    class DescEditCmd
      include CommandHandler
      
      attr_accessor :target
      
      def crack!
        self.target = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.target ],
          help: 'describe'
        }
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|
          Utils::Api.grab client, enactor, "#{cmd.root} #{self.target}=#{model.description}"
        end
      end
        
    end
  end
end
