module AresMUSH
  module Login
    def self.terms_of_service
      tos_filename = Global.read_config("connect", "terms_of_service")
      return tos_filename.nil? ? nil : File.read(tos_filename, :encoding => "UTF-8")
    end
  end
end
