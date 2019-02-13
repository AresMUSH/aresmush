module AresMUSH
  module Custom
    class CompsCmd
      include CommandHandler
      attr_accessor :target_name

      def parse_args
         self.target_name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end

      def handle
        comps = Character.named(self.target_name).comps
        paginator = Paginator.paginate(comps, cmd.page, 15)

        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
        else
          template = CompsTemplate.new(paginator)
          client.emit template.render
        end

      end

    end
  end
end
