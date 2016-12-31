module AresMUSH

  module Describe
    class DescCmd
      include CommandHandler
      
      attr_accessor :target, :description

      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2)
        self.target = trim_input(cmd.args.arg1)
        self.description = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.target, self.description ],
          help: 'describe'
        }
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|
        
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          type = cmd.root_is?("shortdesc") ? :short : :current
          desc = model.descs_of_type(type).first
        
          if (!desc)
            desc = model.create_desc(type,  self.description)
          else
            desc.update(description: self.description)
          end
          client.emit_success(t('describe.desc_set', :name => model.name))
        end
      end
    end
  end
end
