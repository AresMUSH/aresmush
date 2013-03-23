module AresMUSH
  module Formatter
    def self.parse_pose(name, msg)
      if msg.start_with?("\"")
        t('object.say', :name => name, :msg => msg.rest("\""))
      elsif msg.start_with?(":")
        t('object.pose', :name => name, :msg => msg.rest(":"))
      elsif msg.start_with?(";")
        t('object.semipose', :name => name, :msg => msg.rest(";"))
      elsif msg.start_with?("\\")
        msg.rest("\\")
      else
        msg
      end
    end
    
    # %r = linebreak
    # %t = 5 spaces
    # %~ = omit block marker
    def self.perform_subs(str, model)
      str = str.code_gsub("%[rR]", "\n")
      str = str.code_gsub("%[tT]", "     ")
      str = str.code_gsub("%~", "\u2682")
      str
    end
  end
end