module AresMUSH
  module Manage
    class BlockListRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        
        blocks = enactor.blocks.to_a.sort_by { |b| [ b.blocked.name, b.block_type ]}.map { |b|
          {
            id: b.id,
            blocked: {
              name: b.blocked.name,
              id: b.blocked.id
            },
            block_type: b.block_type,
          }
        }
        
        {
          blocks: blocks,
          block_types: [ "all" ].concat(Manage.block_types)
        }
      end
    end
  end
end