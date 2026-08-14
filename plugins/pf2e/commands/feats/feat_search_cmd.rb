module AresMUSH
  module Pf2e
    class FeatSearchCmd
      include CommandHandler

      attr_accessor :search

      def parse_args
        # cmd.page is set by the engine for /N pagination
        self.search = cmd.args ? cmd.args.strip : nil
      end

      def handle
        results = Pf2e.feat_search(self.search)
        page = cmd.page || 1
        paginator = Paginator.paginate(results, page, 5)

        if paginator.out_of_bounds?
          client.emit_failure paginator.out_of_bounds_msg
          return
        end

        template = FeatSearchTemplate.new(paginator, self.search)
        client.emit template.render
      end
    end
  end
end
