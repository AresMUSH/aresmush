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
        return t('describe.outfit_does_not_exist', :name => self.name) if enactor.outfit(self.name).nil?
        return nil
      end
      
      def handle
        Utils::Api.grab client, "outfit/set #{self.name}=#{enactor.outfit(self.name)}"
      end
    end    
  end
end
