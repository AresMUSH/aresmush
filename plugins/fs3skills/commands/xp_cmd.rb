module AresMUSH

  module FS3Skills
    class XpCmd
      include CommandHandler

      attr_accessor :target

      def parse_args
        self.target = !cmd.args ? enactor_name : trim_arg(cmd.args)
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          if (!FS3Skills.can_view_xp?(enactor, model))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          template = XpTemplate.new(model)
          client.emit template.render
        end
      end


    end
  end
end
