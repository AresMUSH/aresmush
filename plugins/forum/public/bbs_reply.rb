module AresMUSH
  class BbsReply < Ohm::Model
    include ObjectModel
    
    attribute :message

    reference :bbs_post, "AresMUSH::BbsPost"
    reference :author, "AresMUSH::Character"
    
    def authored_by?(char)
      char == author
    end
    
    def author_name
      !self.author ? t('global.deleted_character') : self.author.name
    end
    
    def created_date_str(char)
      OOCTime.local_long_timestr(char, self.created_at)
    end    

    def created_date_str_short(char)
      OOCTime.local_short_timestr(char, self.created_at)
    end    
  end
end
