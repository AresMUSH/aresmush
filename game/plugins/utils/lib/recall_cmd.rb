module AresMUSH
  module Utils
    class RecallCmd
      include CommandHandler
      
      attr_accessor :num
      
      def crack!
        self.num = trim_input(cmd.args)
      end

      def handle
        if (!self.num)
          recall_items = enactor.utils_saved_text.each_with_index.map { |x,i| "#{i+1}.  #{x}" }
          client.emit BorderedDisplay.list(recall_items, t('save.recall_title'))
          return
        end
        
        if (num !~ /^[\d]+$/)
          client.emit_failure t('save.invalid_recall_number')
          return
        end
        index = num.to_i - 1
        
        Utils::Api.grab client, enactor, enactor.utils_saved_text[index]
      end
      
    end
  end
end
