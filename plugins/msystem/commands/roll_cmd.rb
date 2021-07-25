module AresMUSH
  module Msystem
    class RollCmd
      include CommandHandler
      attr_accessor :values, :errors, :roll_str, :name

      def parse_args
        return if !cmd.args
        self.values = []

        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)
          self.name = titlecase_arg(args.arg1)
          self.roll_str = args.arg2
        else
          self.name = enactor_name
          self.roll_str = cmd.args
        end

        self.values = Msystem.parse_roll(self.roll_str)
        self.errors = Msystem.parse_roll_errors(self.values)
      end

      def required_args
        [self.values, self.name, self.roll_str]
      end

      def handle
        if enactor.is_admin?
          char = Character.named(self.name)
          self.errors << t("msystem.invalid_character", name: self.name) if char.nil?
        else
          char = enactor
        end

        return client.emit_failure self.errors.join("\n   ") if !self.errors.nil?
        
        roll = Msystem.get_roll_results(Msystem.roll(enactor, self.values), self.values)
        message = t(
          "msystem.simple_roll_result",
          system: Msystem.system_prompt,
          name: char && char.name == enactor_name ? char.name : "#{self.name} (#{enactor_name})",
          roll: roll[:roll],
          dice: roll[:dice],
          success: roll[:state]
        )

        Msystem.emit_results message, client, enactor_room, false
      end
    end
  end
end