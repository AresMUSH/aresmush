module AresMUSH
  module PoseFormatter

    def self.pose_markers
      [ '"', ':', ';' ]
    end
    
    def self.format(name, msg)
      msg = msg.chomp
      if msg.start_with?("\"")
        t('object.say', :name => name, :msg => msg.rest("\""))
      elsif msg.start_with?(":")
        t('object.pose', :name => name, :msg => msg.rest(":"))
      elsif msg.start_with?(";")
        t('object.semipose', :name => name, :msg => msg.rest(";"))
      else
        t('object.say', :name => name, :msg => msg)
      end
    end
  end
end