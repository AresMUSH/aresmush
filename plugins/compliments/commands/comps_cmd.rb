module AresMUSH
  module Compliments
    class CompsCmd
      include CommandHandler
      attr_accessor :target_name

      def parse_args
         self.target_name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
         comps = model.comps.to_a.sort_by { |c| c.created_at }.reverse
         paginator = Paginator.paginate(comps, cmd.page, 5)

         if (paginator.out_of_bounds?)
           client.emit_failure paginator.out_of_bounds_msg
         else
           template = CompsTemplate.new(model, paginator)
           client.emit template.render
          end
       end



      end

    end
  end
end
