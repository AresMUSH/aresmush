module AresMUSH
  module Profile
    def self.format_custom_profile(char)
      text = "%r%l2"
      char.profile.each_with_index do |(k, v), i|
        if (i == 0)
          text << "%R"
        else
          text << "%R%R"
        end
        text << "%xh#{k}%xn%R#{v}"
      end
      text
    end
  end
end