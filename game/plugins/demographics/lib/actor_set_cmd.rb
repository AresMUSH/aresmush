module AresMUSH

  module Demographics
    class ActorSetCmd
      include CommandHandler

      attr_accessor :name, :actor

      def help
        "`actor/set <name>` - Set your actor.  Leave blank to clear it."
      end
      
      def parse_args
        # Admin version
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.name = titlecase_arg(args.arg1)
          self.actor = titlecase_arg(args.arg2)
        # Self version
        else
          self.name = enactor.name
          self.actor = titlecase_arg(cmd.args)
        end
      end
      
      def required_args
        [ self.name ]
      end
        
      def check_is_allowed
        return nil if self.name == enactor_name
        return t('dispatcher.not_allowed') if !Demographics.can_set_demographics?(enactor)
        return nil
      end
      
      def check_chargen_locked
        return nil if Demographics.can_set_demographics?(enactor)
        enabled_after_cg = Global.read_config("demographics", "editable_properties")
        return nil if enabled_after_cg.include?("actor")
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        if (self.actor)
          taken = Character.all.select { |c| c.actor.upcase == self.actor.upcase }
          if (taken.first)
            client.emit_failure t('demographics.actor_taken')
            return
          end
        end

        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          
          model.update_demographic("actor", self.actor)
          
          if (self.name == enactor_name)
            client.emit_success t('demographics.property_set', :property => "actor", :value => self.actor)
          else
            client.emit_success t('demographics.admin_property_set', :name => self.name, :property => "actor", :value => self.actor)
          end
        end
      end
        
    end
  end
end