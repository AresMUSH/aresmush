module AresMUSH
  module Api
    class ApiSyncResponseArgs
      attr_accessor :friends, :autospace, :timezone
      
      def initialize(friends, autospace, timezone)
        @friends = friends
        @autospace = autospace
        @timezone = timezone
      end
      
      def validate
        return nil
      end
      
      def to_s
        "#{friends}||#{autospace}||#{timezone}"
      end

      def self.create_from(response_args)
        args = response_args.split("||")
        friends, autospace, timezone = args
        ApiSyncResponseArgs.new(friends, autospace, timezone)
      end
    end
  end
end