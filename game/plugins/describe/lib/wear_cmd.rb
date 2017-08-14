module AresMUSH
  module Describe
    class WearCmd
      include CommandHandler
      
      attr_accessor :names
      
      def help
        "`wear <list of outfits>` - Wear outfits."
      end
      
      def parse_args
        if cmd.args
          self.names = cmd.args.split(' ').map { |n| titlecase_arg(n) }
        end
      end
      
      def check_outfits_exist
        return t('dispatcher.invalid_syntax', :command => 'wear') if !self.names || self.names.empty?
        self.names.each do |n|
          return t('describe.outfit_does_not_exist', :name => n) if enactor.outfit(n).nil?
        end
        return nil
      end
      
      def handle
        text = ""
        self.names.each do |n|
          text << enactor.outfit(n).description
          text << " "
        end
        
        Describe.update_current_desc(enactor, text)
        
        client.emit_success t('describe.outfits_worn')
      end
    end
  end
end
