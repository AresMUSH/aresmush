module AresMUSH
  module Custom
    class FatigueAddCmd
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
        new_fatigue = current_fatigue.to_i + 1

        if (new_fatigue > 7)
          client.emit_failure("#{name.name}'s fatigue is already at 7.")
          return nil
        end

        name.update(fatigue: new_fatigue)
        client.emit_ooc("Added 1 to #{name.name}'s fatigue.  Now at: #{new_fatigue} / 7.")
        Login.emit_ooc_if_logged_in(name, "#{enactor.name} added one to your fatigue level.  Now at: #{new_fatigue} / 7.")
      end
    end
  end
end
