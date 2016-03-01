module AresMUSH
  module Chargen
    class ChargenPrevNextCmd
      include CommandHandler
      include CommandWithoutArgs
      include CommandRequiresLogin
      
      attr_accessor :offset
      
      def want_command?(client, cmd)
        cmd.root_is?("cg") && (cmd.switch_is?("next") || cmd.switch_is?("prev") || cmd.switch.nil?)
      end
            
      def crack!
        if (cmd.switch.nil?)
          self.offset = 0
        elsif (cmd.switch_is?("next"))
          self.offset = 1
        else
          self.offset = -1
        end
      end
      
      def check_can_advance
        if (self.offset > 0)
          Chargen.can_advance?(client.char)
        end
      end
      
      def handle
        current_page = client.char.chargen_stage
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
        
        client.char.chargen_stage = new_page
        client.char.save!
        client.emit BorderedDisplay.text Chargen.chargen_display(client.char)
      end
    end
  end
end
