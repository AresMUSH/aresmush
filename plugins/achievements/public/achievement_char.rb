module AresMUSH
  class Character
    attribute :achieve_word_count, :type => DataType::Boolean
    collection :achievements, "AresMUSH::Achievement"
    
    before_delete :delete_achievements
    
    def delete_achievements
      self.achievements.each { |a| a.delete }
    end
  end
end