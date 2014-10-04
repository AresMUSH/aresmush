module AresMUSH
  module Api
    class ApiRegisterUpdateResponse
      attr_accessor :client, :is_ok, :error
      
      def is_ok?
        is_ok
      end
      
      def initialize(client, response_str)
        @client = client
        if (response_str == "OK")
          @is_ok = true
          @error = ""
        else
          @is_ok = false
          @error = response_str
        end
      end
    end
  end
end