module AresMUSH
  module Chargen
    class ChargenPrevNextCmd
      include CommandHandler
      include CommandWithoutArgs
      
      attr_accessor :offset
      
      def parse_args
        if (!cmd.switch)
          self.offset = 0
        elsif (cmd.switch_is?("next"))
          self.offset = 1
        else
          self.offset = -1
        end
      end
      
      def check_can_advance
        return t('chargen.not_started') if !Chargen.current_stage(enactor)
        
        if (self.offset > 0)
          Chargen.can_advance?(enactor)
        end
      end
      
      def handle
        current_page = Chargen.current_stage(enactor)        
        total_pages = Chargen.stages.keys.count
        
        new_page = current_page + offset
        
        if (new_page < 0)
          client.emit_failure t('chargen.cant_go_back')
          return
        end
        
        if (new_page >= total_pages)
          client.emit_success t('chargen.chargen_complete')
          return
        end
        
        enactor.chargen_info.update(current_stage: new_page)
        
        template = ChargenTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end
