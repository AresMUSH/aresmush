module AresMUSH
  module Utils
    class RecallCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
      
      attr_accessor :num
      
      def want_command?(client, cmd)
        cmd.root_is?("recall")
      end
      
      def crack!
        self.num = trim_input(cmd.args)
      end

      def handle
        if (self.num.nil?)
          recall_items = client.char.saved_text.each_with_index.map { |x,i| "#{i+1}.  #{x}" }
          client.emit BorderedDisplay.list(recall_items, t('save.recall_title'))
          return
        end
        
        if (num !~ /^[\d]+$/)
          client.emit_failure t('save.invalid_recall_number')
          return
        end
        index = num.to_i - 1
        
        client.grab client.char.saved_text[index]
      end
      
    end
  end
end
