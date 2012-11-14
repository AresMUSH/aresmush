class Hash
  
  def parse_pose(msg)
    name = self["name"]
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