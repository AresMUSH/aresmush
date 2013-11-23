module AresMUSH
  module Describe
    class DescCmdCracker
      def self.crack(cmd)
        cmd.crack!(/(?<target>[^\=]+)\=(?<desc>.+)/)
      end
    end 
  end
end
