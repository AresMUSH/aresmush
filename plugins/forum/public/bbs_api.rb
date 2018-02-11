module AresMUSH
  module Forum
    def self.has_unread_forum_posts?(char)
      BbsBoard.all.each do |b|
        if (b.has_unread?(char))
          return true
        end
      end
      return false
    end
    
    def self.system_post(category, subject, message)
      return if !category
      return if category.blank?
  
      Forum.post(category, subject, message, Game.master.system_character)
    end
  end
end
