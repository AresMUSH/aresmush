module AresMUSH
    module Custom
      class SetLegendaryAttributeCmd
        include CommandHandler
  
        attr_accessor :name, :attribute, :value
  
        def parse_args
          # Expect command format: setlegendary <name>/<attribute>=<value>
          args = cmd.parse_args(ArgParser.arg1_slash_arg2_equals_arg3)
          self.name = titlecase_arg(args.arg1)
          self.attribute = downcase_arg(args.arg2)
          self.value = trim_arg(args.arg3)
        end
  
        def required_args
          [self.name, self.attribute, self.value]
        end
  
        def handle
          client.emit_failure "This command is under construction."
        end
      end
    end
  end
  