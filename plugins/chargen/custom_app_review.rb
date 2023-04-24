module AresMUSH
  module Chargen

    def self.bg_too_long(char)
      msg = "Checking Background Length"
      error = t('chargen.ok')
      error = "Background should be less than 4,000 characters." if char.background.length > 4100
      return { error: error, msg: msg }
    end

    def self.custom_app_review(char)
      messages = []
      messages.concat [Chargen.bg_too_long(char)]
      messages.concat [Magic.check_magic_attribute_rating(char)]
      messages.concat [Magic.check_points_on_spells(char)]
      # messages.concat [Magic.check_points_in_wrong_school(char)]
      messages.concat [Magic.check_wrong_spell_levels(char)]
      # messages.concat [Magic.check_skill_levels_against_age(char)]

      msg = []
      if !messages.empty?
        messages.each do |m|
          m[:error] != "%xh%xg< OK! >%xn" ? error = "%xr< #{m[:error]} >%xn" : error = m[:error]
          msg.concat [Chargen.format_review_status(m[:msg], error)]
        end
      end
      puts "Msg #{msg}"

      return  msg.join('%r%r')

      # If you don't want to have any custom app review steps, return nil


      # Otherwise, return a message to display.  Here's an example of how to
      # give an alert if the character has chosen an invalid position for their
      # faction.
      #
      #  faction = char.group("Faction")
      #  position = char.group("Position")
      #
      #  if (position == "Knight" && faction != "Noble")
      #    msg = "%xrOnly nobles can be knights.%xn"
      #  else
      #    msg = t('chargen.ok')
      #  end
      #
      #  return Chargen.format_review_status "Checking groups.", msg
      #
      # You can also use other built-in chargen status messages, like t('chargen.not_set').
      # See https://www.aresmush.com/tutorials/config/chargen.html for details.
    end
  end
end