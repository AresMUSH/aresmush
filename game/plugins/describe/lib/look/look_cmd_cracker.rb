module AresMUSH
  module Describe
    class LookCmdCracker
      def self.crack(cmd)
        cmd.crack!(/(?<target>.+)/)
        cmd.args
      end
    end
  end
end
