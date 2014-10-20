module AresMUSH
  module Api
    class LinkResponseHandler < ApiResponseHandler
      def handle   
        client.char.handle = response.args_str
        client.char.save!
        client.emit_success "You have linked this character to handle #{response.args_str}.  Your privacy level has been set to #{client.char.handle_privacy}."
      end
    end
  end
end