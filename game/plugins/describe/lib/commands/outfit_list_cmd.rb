module AresMUSH
  module Describe
    class OutfitListCmd
      include AresMUSH::Plugin
           
      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        (cmd.root_is?("outfit") || cmd.root_is?("outfits")) && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle
        output = "%l1" << "%r"
        
        output << "%xh" << t('describe.your_outfits') << "%xn"
        client.char.outfits.keys.each do |k|
          output << "%r" << k
        end

        output << "%r%r"
        
        output << "%xh" << t('describe.game_outfits') << "%xn"
        Global.config['describe']['outfits'].keys.each do |k|
          output << "%r" << k
        end

        output << "%r%l1"
        
        client.emit output
      end
    end
  end
end
