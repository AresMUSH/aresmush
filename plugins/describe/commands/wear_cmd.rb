module AresMUSH
  module Describe
    class WearCmd
      include CommandHandler
      
      attr_accessor :names
      
      def parse_args
        if cmd.args
          self.names = cmd.args.split(' ').map { |n| titlecase_arg(n) }
        end
      end
      
      def check_outfits_exist
        return t('dispatcher.invalid_syntax', :cmd => 'wear') if !self.names || self.names.empty?
        self.names.each do |n|
          return t('describe.outfit_does_not_exist', :name => n) if enactor.outfit(n).nil?
        end
        return nil
      end
      
      def handle
        text = ""
        self.names.each do |n|
          text << enactor.outfit(n)
          text << " "
        end
        
        enactor.update_desc(text)
        client.emit_success t('describe.outfits_worn')
      end
    end
  end
end
