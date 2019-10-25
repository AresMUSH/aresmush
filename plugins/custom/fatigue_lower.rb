module AresMUSH
  module Custom
    class FatigueLowerCmd
      include CommandHandler

      attr_accessor :name

      def parse_args
        self.name = !cmd.args ? enactor : Character.find_one_by_name(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
     
      def handle
        if (!enactor.is_admin?)
          client.emit_failure("Submit a request to staff.")
          return nil
        end

        current_fatigue = name.fatigue
        new_fatigue = current_fatigue.to_i - 1
        name.update(fatigue: new_fatigue)
        client.emit_ooc("Lowered #{name.name}'s Fatigue by 1.  Now at: #{new_fatigue} / 7.")
        Login.emit_ooc_if_logged_in(name, "#{enactor.name} removed one from your fatigue level.  Now at: #{new_fatigue} / 7.")
      end
    end
  end
end
