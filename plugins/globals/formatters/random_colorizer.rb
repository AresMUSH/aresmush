module AresMUSH
  class RandomColorizer
    
    # Randomly rotates between colors in a list, based on the seconds value of the current time.
    def self.random_color
      colors = Global.read_config("skin", "random_colors") || [ '%xc', '%xb', '%xg', '%xr' ]
      bracket_width = 60 / colors.count
      index = Time.now.sec / bracket_width
      colors[index]
    end
    
  end
end