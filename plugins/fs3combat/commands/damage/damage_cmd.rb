module AresMUSH
  module FS3Combat
    class DamageCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor.name
      end
      
      def handle
        target = FS3Combat.find_named_thing(self.name, enactor)
            
        if (target)
          template = DamageTemplate.new(target)
          client.emit template.render
        else 
          client.emit_failure t('db.object_not_found')
        end
      end
    end
  end
end