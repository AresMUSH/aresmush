module AresMUSH
  module Describe
    class LookCmdCracker
      def self.crack(cmd)
        cmd.crack_args!(/(?<target>.+)/)
      end
    end
  end
end
