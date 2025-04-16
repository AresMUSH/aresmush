module AresMUSH
  module Manage
    class RemoveBlockRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args['id']
        
        error = Website.check_login(request)
        return error if error

        block = BlockRecord[id]
        if (!block)
          return { error: "Block not found."}
        end
        
        if (block.owner != enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        Global.logger.debug "Removing block for #{block.blocked.name} from #{block.owner.name}."
        block.destroy
        {}
      end
    end
  end
end