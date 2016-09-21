module AresMUSH
  module Describe
    class OutfitEditCmd
      include CommandHandler
      include CommandRequiresLogin
           
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_outfit_exists
        return t('describe.outfit_does_not_exist', :name => self.name) if client.char.outfit(self.name).nil?
        return nil
      end
      
      def handle
        client.grab "outfit/set #{self.name}=#{client.char.outfit(self.name)}"
      end
    end    
  end
end
