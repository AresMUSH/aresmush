module AresMUSH

  module Describe
    class DescEditCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :target

      def initialize(client, cmd, enactor)
        self.required_args = ['target']
        self.help_topic = 'describe'
        super
      end
            
      def crack!
        self.target = trim_input(cmd.args)
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|
          Utils::Api.grab client, "#{cmd.root} #{self.target}=#{model.description}"
        end
      end
        
    end
  end
end
