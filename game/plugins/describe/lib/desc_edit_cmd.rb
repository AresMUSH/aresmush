module AresMUSH

  module Describe
    class DescEditCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :target

      def initialize
        self.required_args = ['target']
        self.help_topic = 'describe'
        super
      end
            
      def want_command?(client, cmd)
        (cmd.root_is?("describe") || cmd.root_is?("shortdesc")) && cmd.switch_is?("edit")
      end

      def crack!
        self.target = trim_input(cmd.args)
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client) do |model|
          client.grab "#{cmd.root} #{self.target}=#{model.description}"
        end
      end
        
    end
  end
end
