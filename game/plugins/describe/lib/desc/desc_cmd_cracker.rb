module AresMUSH
  module Describe
    class DescCmdCracker
      def self.crack(cmd)
        cmd.crack_args!(/(?<target>[^\=]+)\=(?<desc>.+)/)
      end
    end 
  end
end
