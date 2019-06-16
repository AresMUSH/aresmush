module AresMUSH
  module Custom
    class SetGoalsCmd
      include CommandHandler

      attr_accessor :goals

      def parse_args
       self.goals = trim_arg(cmd.args)
      end

      def handle
        enactor.update(goals: self.goals)
        client.emit_success "Goals set!"
      end
    end
  end
end
