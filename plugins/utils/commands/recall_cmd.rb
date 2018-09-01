module AresMUSH
  module Utils
    class RecallCmd
      include CommandHandler
      
      attr_accessor :num
      
      def parse_args
        self.num = trim_arg(cmd.args)
      end

      def handle
        if (!self.num)
          recall_items = enactor.utils_saved_text.each_with_index.map { |x,i| "#{i+1}.  #{x}" }
          template = BorderedListTemplate.new recall_items, t('save.recall_title')
          client.emit template.render
          return
        end
        
        if (!num.is_integer?)
          client.emit_failure t('save.invalid_recall_number')
          return
        end
        index = num.to_i - 1
        
        Utils.grab client, enactor, enactor.utils_saved_text[index]
      end
      
    end
  end
end
