module AresMUSH
  class ProgressBarFormatter
    def self.format(progress, total, increments = 10, progressChar = "@", emptyChar = ".")
      progress = progress || 0.0
      percent = (progress / total.to_f * increments).floor
      percent = [ percent, increments ].min
      
      min = progress > 0 ? 1 : 0
      percent = [ percent, min ].max
      stars = percent.times.collect { progressChar }.join
      dots = (increments - percent).times.collect { emptyChar }.join
      "#{stars}#{dots}"
    end
  end
end