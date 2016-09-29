module AresMUSH

  module Describe
    class DescCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :target, :desc

      def initialize(client, cmd, enactor)
        self.required_args = ['target', 'desc']
        self.help_topic = 'describe'
        super
      end      

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.target = trim_input(cmd.args.arg1)
        self.desc = cmd.args.arg2
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client) do |model|
        
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          if (cmd.root_is?("shortdesc"))
            model.shortdesc = desc
            model.save!
          else
            Describe.set_desc(model, desc)
          end
          client.emit_success(t('describe.desc_set', :name => model.name))
        end
      end
        
    end
  end
end
