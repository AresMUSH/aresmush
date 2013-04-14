module AresMUSH
  module Describe
    class DescCmdValidator
      def self.validate(args, client)
        if (args.nil? || args.target.nil? || args.desc.nil?)
          client.emit_failure(t('describe.invalid_desc_syntax'))
          return false
        end
        return true
      end
    end
  end
end
