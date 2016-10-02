module AresMUSH
  module Describe
    class WearCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
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
        desc = ""
        self.names.each do |n|
          desc << enactor.outfit(n)
          desc << " "
        end
        Describe.set_desc(enactor, desc)
        client.emit_success t('describe.outfits_worn')
      end
    end
  end
end
