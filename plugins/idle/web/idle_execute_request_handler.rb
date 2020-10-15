module AresMUSH
  module Idle
    class IdleExecuteRequestHandler
      def handle(request)
                
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        if (!Idle.can_idle_sweep?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        char_data = request.args['chars'].values
        
        queue = {}
        char_data.each do |data|
          char = Character.named(data['name'])
          notes = data['notes']
          action = data['idle_action']
          
          if (!char) 
            return { error: t('db.object_not_found')}
          end

          if (action == "None")
            char.update(idle_state: nil)
          else
            queue[char.id] = action
          end
          
          if (notes != char.idle_notes)
            char.update(idle_notes: notes)
          end
        end
        
        report = Idle.execute_idle_sweep(enactor, queue)
        
        return {
          report: Website.format_markdown_for_html(report)
        }
      end

    end
  end
end