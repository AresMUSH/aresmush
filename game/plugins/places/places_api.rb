module AresMUSH
  class Character
    def place_title(viewer)
      return "" if !self.place
      color = Global.read_config("places", "same_place_color")
      default_format = "%xh%xx[-- #{self.place.name} --]%xn "
      same_place_format = "#{color}[++ #{self.place.name} ++]%xn "
      viewer.place == self.place ? same_place_format : default_format
    end
  end
end