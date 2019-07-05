module AresMUSH
  module LuckGive
    class LuckRecordCmd
      include CommandHandler
      attr_accessor :target_name

      def parse_args
         self.target_name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
         luck_record = model.luck_record.to_a.reverse
         paginator = Paginator.paginate(luck_record, cmd.page, 5)

         if (paginator.out_of_bounds?)
           client.emit_failure paginator.out_of_bounds_msg
         else
           template = LuckRecordTemplate.new(model, paginator)
           client.emit template.render
          end
       end



      end

    end
  end
end
