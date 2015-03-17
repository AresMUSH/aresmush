# encoding: utf-8
module Mongoid
  module Persistence
    module Atomic

      # This operation is for performing $bit atomic operations against the
      # database.
      class Bit
        include Operation

        # Execute the bitwise operation. This correlates to a $bit in MongoDB.
        #
        # @example Execute the op.
        #   bit.persist
        #
        # @return [ Integer ] The new value.
        #
        # @since 2.1.0
        def persist
          prepare do
            current = document[field]
            return nil unless current
            document[field] = value.inject(current) do |result, (bit, val)|
              result = result & val if bit.to_s == "and"
              result = result | val if bit.to_s == "or"
              result
            end
            execute("$bit")
            document[field]
          end
        end
      end
    end
  end
end
