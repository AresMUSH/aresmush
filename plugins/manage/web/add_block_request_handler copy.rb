module AresMUSH
  module Manage
    class AddBlockRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args['name']
        block_type = request.args['block_type']
        
        error = Website.check_login(request)
        return error if error

        target = Character.named(name)
        if (!target)
          return { error: t('webportal.not_found') }
        end
        
        block = enactor.blocks.select { |b| b.block_type == block_type && b.blocked == target }.first
        if (block)
          return { error: t('manage.already_blocked') }
        end
        
        types = Global.read_config('manage', 'block_types')
        if (!types.include?(block_type)) 
          return { error: t('manage.invalid_block_type', :types => types.join(' ')) }
        end
        
        Global.logger.debug "Adding block for #{target.name} from #{enactor.name}."
        BlockRecord.create(owner: enactor, blocked: target, block_type: block_type)
        {}
      end
    end
  end
end