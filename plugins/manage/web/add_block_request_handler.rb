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
        
        if (block_type != "all" && !Manage.block_types.include?(block_type)) 
          return { error: t('manage.invalid_block_type', :types => Manage.block_types.join(' ')) }
        end

        types = block_type == "all" ? Manage.block_types : [ block_type ]
        
        types.each do |t|
          Manage.add_block(enactor, target, t)          
        end        
                
        {}
      end
    end
  end
end