module AresMUSH
  module Ffg
    class CortexRollResults
      attr_accessor :roll, :input
      
      def initialize(input, roll)
        self.roll = roll
        self.input = input
      end
      
      def total
        self.roll.reduce(:+)
      end
      
      def is_botch?
        not_ones = self.roll.select { |r| r != 1 }
        not_ones.count == 0
      end
      
      def print_dice
        self.roll.join(" ")
      end
      
      def pretty_input
        pieces = input.split("+").map { |p| p.strip }
        pieces.map { |p| Ffg.is_valid_die_step?(p) ? p.downcase : p.titleize }.join("+")
      end
      
      def to_s
        "#{self.roll}:#{self.total}"
      end
    end
  end
end