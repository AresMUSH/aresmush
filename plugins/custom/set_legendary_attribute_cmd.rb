module AresMUSH
    module Custom
      class SetLegendaryAttributeCmd
        include CommandHandler
  
        attr_accessor :name, :attribute, :value
  
        def parse_args
          # Expect command format: setlegendary <name>/<attribute>
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)
          self.name = titlecase_arg(args.arg1)
          self.attribute = downcase_arg(args.arg2)
          self.value = 5  # Always set the value to 5
        end
  
        def required_args
          [self.name, self.attribute]
        end
  
        def check_permissions
          return t('dispatcher.not_allowed') unless enactor.is_admin?
          nil
        end
  
        def handle
          target = Character.find_one_by_name(self.name)
          if !target
            client.emit_failure "Character #{self.name} not found."
            return
          end
  
          if !target.fs3_attributes[self.attribute]
            client.emit_failure "Attribute #{self.attribute} is not valid."
            return
          end
  
          target.fs3_attributes[self.attribute] = self.value
          target.save
          Global.dispatcher.queue_event CharUpdatedEvent.new(target.id)
  
          client.emit_success("#{self.name}'s #{self.attribute.capitalize} is now Legendary (5).")
        end
      end
    end
  end
    