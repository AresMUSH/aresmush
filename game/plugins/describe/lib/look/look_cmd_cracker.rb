module AresMUSH
  module Describe
    class LookCmdCracker
      def self.crack(cmd)
        cmd.crack!(/(?<target>.+)/)
      end
    end
  end
end
