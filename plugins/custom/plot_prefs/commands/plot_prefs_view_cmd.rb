module AresMUSH

  module Custom
    class PlotPrefsViewCmd
      include CommandHandler

      attr_accessor :target

      def parse_args
        self.target = !cmd.args ? enactor_name : titlecase_arg(cmd.args)
      end

      def required_args
        [ self.target ]
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          formatter = MarkdownFormatter.new
          prefs = formatter.to_mush model.plot_prefs
          template = BorderedDisplayTemplate.new prefs, t('custom.plot_prefs_title', :name => model.name)
          client.emit template.render

        end
      end
    end
  end
end
