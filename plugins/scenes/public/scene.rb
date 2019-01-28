module AresMUSH
  
  class Scene < Ohm::Model
    include ObjectModel
    
    reference :room, "AresMUSH::Room"
    reference :owner, "AresMUSH::Character"
    attribute :date_completed, :type => DataType::Time
    attribute :date_shared, :type => DataType::Time
    attribute :last_activity, :type => DataType::Time
    
    attribute :title
    attribute :private_scene, :type => DataType::Boolean
    attribute :temp_room, :type => DataType::Boolean
    attribute :completed
    attribute :scene_type
    attribute :location
    attribute :summary
    attribute :shared
    attribute :logging_enabled, :type => DataType::Boolean, :default => true
    attribute :deletion_warned, :type => DataType::Boolean, :default => false
    attribute :icdate
    attribute :tags, :type => DataType::Array, :default => []
    
    collection :scene_poses, "AresMUSH::ScenePose"
    reference :scene_log, "AresMUSH::SceneLog"
    reference :plot, "AresMUSH::Plot"
    
    set :invited, "AresMUSH::Character"
    set :watchers, "AresMUSH::Character"
    set :participants, "AresMUSH::Character"
    set :likers, "AresMUSH::Character"
    set :readers, "AresMUSH::Character"
    
    before_delete :delete_poses_and_log
    
    def self.shared_scenes
      Scene.all.select { |s| s.shared }
    end
    
    def self.scenes_starring(char)
      Scene.all.select { |s| s.shared && s.participants.include?(char) }
    end
    
    def is_private?
      self.private_scene
    end
    
    def last_posed
      last_pose = self.scene_poses.to_a[-1]
      last_pose ? last_pose.character : nil
    end
    
    def created_date_str(char)
      OOCTime.local_short_timestr(char, self.created_at)
    end
    
    def mark_read(char)
      self.readers.add char
    end
    
    def is_unread?(char)
      !self.readers.include?(char)
    end
    
    def mark_unread(except_for_char = nil)
      self.readers.replace( except_for_char ? [ except_for_char ] : [] )
    end
    
    def poses_in_order
      scene_poses.to_a.sort_by { |p| p.sort_order }
    end

    def delete_poses_and_log
      scene_poses.each { |p| p.delete }
      if (self.scene_log)
        self.scene_log.delete
      end
      Scenes.find_all_scene_links(self).each { |s| s.delete }
    end
    
    def all_info_set?
      missing_fields = self.title.blank? || self.location.blank? || self.scene_type.blank? || self.summary.blank?
      !missing_fields
    end

    def date_title
      "#{self.icdate} - #{self.title}"
    end
    
    def owner_name
      self.owner ? self.owner.name : t('scenes.organizer_deleted')
    end
    
    def related_scenes
      links1 = SceneLink.find(log1_id: self.id)
      links2 = SceneLink.find(log2_id: self.id)
      list1 = links1.map { |l| l.log2 }
      list2 = links2.map { |l| l.log1 }
      list1.concat(list2).uniq
    end
    
    def participant_names
      self.participants.sort { |p| p.name }.map { |p| p.name }
    end
    
    def find_link(other_scene)
      link = SceneLink.find(log1_id: self.id).combine(log2_id: other_scene.id).first
      if (!link)
        link = SceneLink.find(log1_id: other_scene.id).combine(log2_id: self.id).first
      end
      link
    end
    
    def has_liked?(char)
      self.likers.include?(char)
    end
    
    def like(char)
      if (!self.has_liked?(char))
        self.likers.add char
      end
    end

    def unlike(char)
      if (self.has_liked?(char))
        self.likers.delete char
      end
    end
    
    def likes
      self.likers.count
    end
    
    def url
      "#{Game.web_portal_url}/scene/#{self.id}"
    end
  end
end
