module AresMUSH
  module Describe
    class DescCmdCracker
      def self.crack(cmd)
        cmd.crack!(/(?<target>[^\=]+)\=(?<desc>.+)/)
        cmd.args
      end
    end 
  end
end
