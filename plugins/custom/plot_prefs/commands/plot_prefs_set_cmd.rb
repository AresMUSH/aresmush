module AresMUSH

  module Custom
    class PlotPrefsSetCmd
      include CommandHandler

      attr_accessor :target, :plot_prefs

      def parse_args
        self.target = enactor
        self.plot_prefs = cmd.args
      end

      def required_args
        [ self.target ]
      end

      def handle
        self.target.update(plot_prefs: self.plot_prefs)
        client.emit_success t('custom.plot_prefs_set')
      end

    end
  end
end
