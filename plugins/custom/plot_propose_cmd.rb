module AresMUSH
  module Custom
    class PlotProposeCmd
    # plot/propose <plot name>=<form>
      include CommandHandler

      attr_accessor :plot_name, :plot_form

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.plot_name = trim_arg(args.arg1)
        self.plot_form = trim_arg(args.arg2)
      end

      def handle
        client.emit_success t('custom.plot_proposed')
        subj = "PRP: #{plot_name} by #{enactor.name}"
        Jobs.create_job("PLOT", subj, plot_form, enactor)
      end

    end
  end
end
