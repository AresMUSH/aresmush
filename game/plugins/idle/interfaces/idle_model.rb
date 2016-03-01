module AresMUSH
  class Character
    field :idled_out, :type => String
    field :lastwill, :type => String
    
    def self.active_chars
      base_list = Character.where(:idled_out.exists => false, :idled_out.ne => "", :is_playerbit.ne => true)
      base_list.select { |c| !(c.is_admin? || c.is_guest?)}
    end
    
  end
end