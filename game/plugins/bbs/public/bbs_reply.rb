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
      !self.author ? t('bbs.deleted_author') : self.author.name
    end
    
    def created_date_str(char)
      OOCTime::Api.local_long_timestr(char, self.created_at)
    end    
  end
end
