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
    attribute :scene_pacing
    attribute :location
    attribute :summary
    attribute :limit
    attribute :shared
    attribute :was_restarted, :type => DataType::Boolean, :default => false
    attribute :logging_enabled, :type => DataType::Boolean, :default => true
    attribute :deletion_warned, :type => DataType::Boolean, :default => false
    attribute :icdate
    attribute :tags, :type => DataType::Array, :default => []
    attribute :content_warning
    
    collection :scene_poses, "AresMUSH::ScenePose"
    collection :scene_likes, "AresMUSH::SceneLike"
    reference :scene_log, "AresMUSH::SceneLog"
    
    set :invited, "AresMUSH::Character"
    set :watchers, "AresMUSH::Character"
    set :participants, "AresMUSH::Character"
    set :likers, "AresMUSH::Character"
    
    # DEPRECATED - DO NOT USE (replaced by plot links)
    reference :plot, "AresMUSH::Plot"
    set :plots, "AresMUSH::Plot"
    
    before_delete :on_delete
    
    index :shared
    index :completed
    
    def self.shared_scenes
      Scene.find(shared: true).to_a
    end
    
    def self.scenes_starring(char)
      Scene.all.select { |s| s.shared && s.participants.include?(char) }
    end
    
    def is_private?
      self.private_scene
    end
    
    def last_posed
      last_pose = self.poses_in_order.to_a[-1]
      last_pose ? last_pose.character : nil
    end
    
    def created_date_str(char)
      OOCTime.local_short_timestr(char, self.created_at)
    end
    
    def mark_read(char)
      Scenes.mark_read(self, char)
    end
    
    def is_unread?(char)
      Scenes.is_unread?(self, char)
    end
    
    def mark_unread(except_for_char = nil)
      Scenes.mark_unread(self, except_for_char)
    end
    
    def poses_in_order
      scene_poses.select { |p| !p.is_deleted? }.sort_by { |p| p.sort_order }
    end

    def on_delete
      scene_poses.each { |p| p.delete }
      if (self.scene_log)
        self.scene_log.delete
      end
      Scenes.find_all_scene_links(self).each { |s| s.delete }
      self.plot_links.each { |p| p.delete }
    end
    
    def all_info_set?
      missing_fields = self.title.blank? || self.location.blank? || self.scene_type.blank? || self.summary.blank? || self.icdate.blank?
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
      self.scene_likes.any? { |s| s.character == char }
    end
    
    def like(char)
      if (!self.has_liked?(char))
        SceneLike.create(character: char, scene: self)
      end
    end

    def unlike(char)
      if (self.has_liked?(char))
        like = char.scene_likes.select { |s| s.scene == self }.first
        like.delete
      end
    end
    
    def likes
      self.scene_likes.count
    end
    
    def live_url
      "#{Game.web_portal_url}/scene-live/#{self.id}"
    end
    
    def url
      "#{Game.web_portal_url}/scene/#{self.id}"
    end
    
    def has_notes?
      !self.limit.blank?
    end
    
    def days_since_shared
      return nil if !self.date_shared
      (Time.now - self.date_shared) / 86400
    end
    
    def days_since_last_activity
      (Time.now - self.last_activity)/86400
    end    
    
    def last_pose_time_str(viewer)
      last_pose = self.poses_in_order.to_a[-1]
      return nil if !last_pose
      
      elapsed = Time.now - last_pose.updated_at
      if (elapsed < 86400 * 30)
        TimeFormatter.format(elapsed)
      else
        OOCTime.local_short_timestr(viewer, last_pose.updated_at)
      end
    end
    
    def is_participant?(char)
      return false if !char
      char == self.owner || self.participants.include?(char)
    end
    
    def plot_links
      PlotLink.find_by_scene(self)
    end
    
    def related_plots
      self.plot_links.map { |p| p.plot }
    end
    
  end
end
