module AresMUSH
  module Describe
    class WearCmd
      include CommandHandler
      
      attr_accessor :names
      
      def crack!
        if cmd.args
          self.names = cmd.args.split(' ').map { |n| titleize_input(n) }
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
