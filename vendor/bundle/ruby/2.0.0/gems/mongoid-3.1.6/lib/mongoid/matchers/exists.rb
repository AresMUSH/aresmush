# encoding: utf-8
module Mongoid
  module Matchers

    # Checks for existance.
    class Exists < Default

      # Return true if the attribute exists and checking for existence or
      # return true if the attribute does not exist and checking for
      # non-existence.
      #
      # @example Does anything exist?
      #   matcher.matches?({ :key => 10 })
      #
      # @param [ Hash ] value The values to check.
      #
      # @return [ true, false ] If a value exists.
      def matches?(value)
        @attribute.nil? != value.values.first
      end
    end
  end
end
