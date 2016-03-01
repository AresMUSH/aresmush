module AresMUSH
  module Login
    def self.terms_of_service
      use_tos = Global.read_config("connect", "use_terms_of_service") 
      tos_filename = "game/files/tos.txt"
      return use_tos ? File.read(tos_filename, :encoding => "UTF-8") : nil
    end
  end
end
