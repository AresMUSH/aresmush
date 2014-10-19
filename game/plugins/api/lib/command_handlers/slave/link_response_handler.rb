module AresMUSH
  module Api
    class LinkResponseHandler < ApiResponseHandler
      def handle   
        client.char.handle = response.args_str
        client.char.save!
        client.emit_success "You have linked this character to handle #{response.args_str}"
      end
    end
  end
end