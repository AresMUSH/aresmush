module AresMUSH
  module Formatters
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
  end
end