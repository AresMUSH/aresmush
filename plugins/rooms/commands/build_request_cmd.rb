module AresMUSH
  module Rooms
    class BuildRequestCmd
    # build/request <room name>=<text>
      include CommandHandler

      attr_accessor :room, :details

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.room = trim_arg(args.arg1)
        self.details = trim_arg(args.arg2)
      end

      def handle
        client.emit_success t('custom.build_requested')
        subj = "Build #{room} for #{enactor.name}"
        Jobs.create_job("BUILD", subj, details, enactor)
      end

    end
  end
end
