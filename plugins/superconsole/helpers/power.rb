module AresMUSH
  module SuperConsole
   def self.power_abil(char)
     0
   end
   def self.power_attr(char)
     0
   end
   def self.power_level(char)
     lvl = char.level
     mlvl = char.console_max_level
     char_level = lvl * 100
     max_level = SuperConsole.max_level_cleared(mlvl)
     char_level + max_level
   end
   def self.max_level_cleared(l)
     if l.between?(1,10)
       val = l
     elsif l.between?(11,20)
       val = l * 2
     elsif l.between?(21,40)
       val = l * 3
     elsif l.between?(41,70)
       val = l * 4
     elsif rating.between?(71,90)
       val = l * 5
     elsif rating.between?(91,100)
       val = l * 10
     end
     val * 50
   end
   def self.power_gear(char)
     0
   end
  end
end
