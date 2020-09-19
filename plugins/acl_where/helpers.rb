    def self.top_level_areas
      Area.all.select { |a| !a.parent }.sort_by { |a| a.name }
    end