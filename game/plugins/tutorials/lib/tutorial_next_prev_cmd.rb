module AresMUSH
  module Tutorials
    class TutorialPrevNextCmd
      include Plugin
      include PluginWithoutArgs
      include PluginRequiresLogin
      
      attr_accessor :offset
      
      def want_command?(client, cmd)
        cmd.root_is?("tutorial") && (cmd.switch_is?("next") || cmd.switch_is?("prev") || cmd.switch.nil?)
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
      
      def check_tutorial_in_progress
        return t('tutorials.tutorial_not_started') if client.char.tutorial.nil?
        return nil
      end
        
      def handle
        current_page = client.char.tutorial_page_index
        total_pages = Tutorials.page_files(client.char.tutorial).count
        
        new_page = current_page + offset
        
        if (new_page < 0)
          client.emit_failure t('tutorials.already_on_first_page')
          return
        end
        
        if (new_page >= total_pages)
          client.emit_success t('tutorials.tutorial_complete')
          return
        end
        
        client.char.tutorial_page_index = new_page
        client.char.save!
        client.emit BorderedDisplay.text Tutorials.get_page(client.char)
      end
    end
  end
end
