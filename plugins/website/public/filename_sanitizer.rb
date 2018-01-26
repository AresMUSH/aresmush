module AresMUSH
  module Website
    module FilenameSanitizer
      def self.sanitize(filename)
        filename = filename || ""
        filename = filename.strip
        #filename = filename.gsub(/^.*(\\|\/)/, '')
        filename = filename.gsub(/[^0-9A-Za-z.\-]/, '_')
        filename.downcase
      end
    end
  end
end