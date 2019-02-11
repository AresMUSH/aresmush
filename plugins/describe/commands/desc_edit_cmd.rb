module AresMUSH

  module Describe
    class DescEditCmd
      include CommandHandler
      
      attr_accessor :target, :shortdesc
      
      def parse_args
        self.shortdesc = cmd.root_is?("shortdesc")
        self.target = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.target ]
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|
          desc = self.shortdesc ? model.shortdesc : model.description
          Utils.grab client, enactor, "#{cmd.root} #{self.target}=#{desc}"
        end
      end
        
    end
  end
end
