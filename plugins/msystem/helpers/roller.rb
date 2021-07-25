module AresMUSH
  module Msystem

    def self.get_partial(list, partial)
      # list.map {|c| c['name']}
      #   .keep_if {|p| Regexp.new("^#{partial}", Regep::IGNORECASE.match?(p.gsub(/\s+/,''))}
      #     .first
    end

    def self.get_partial_skill(partial)
      # get_partial(Msystem.skills, partial)
    end

    def self.get_partial_characteristic(partial)
      # get_partial(Msystem.characteristics, partial)
    end

    def self.roll(char, values)

      # values.map {|part|
      #   k, v = part.first
      #   case k
      #   when :dice 
      #     dice, sides = v.split("d").reject(&:empty?).map(&:to_i)
      #     sides, dice = [dice, 1] if sides.nil?
          

      # }
    end

    def self.parse_roll_for_values(roll)
      # values = []
      # roll.gsub(/\s+/, '').scan(/[+-]?\w+/i).each do |val|

      # end
    end
  end
end