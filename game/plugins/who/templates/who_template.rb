module AresMUSH
  module Who
    class WhoTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # they are defined in these two modules, found in other files in this directory.
      include WhoCharacterFields
      include CommonWhoFields
    
      attr_accessor :online_chars
      
      def initialize(online_chars)
        self.online_chars = online_chars
        super File.dirname(__FILE__) + "/who.erb"
      end
      
    end 
  end
end