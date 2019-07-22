module AresMUSH
  module FS3Skills
    def self.can_manage_luck?(actor)
      actor.has_permission?("manage_abilities")
    end

    def self.modify_luck(char, amount)
      max_luck = Global.read_config("fs3skills", "max_luck")
      luck = char.luck + amount.to_f
      luck = [max_luck, luck].min
      luck = [0, luck].max
      char.update(fs3_luck: luck)
    end

    def self.spend_luck(char, reason, scene)
      char.spend_luck(1)
      message = t('fs3skills.luck_point_spent', :name => char.name, :reason => reason)

      if (scene)
        scene.room.emit_ooc message
        Scenes.add_to_scene(scene, message)
      else
        char.room.emit_ooc message
      end

      Achievements.award_achievement(char, "fs3_luck_spent", 'fs3', "Spent a luck point.")

      category = Jobs.system_category
      Jobs.create_job(category, t('fs3skills.luck_job_title', :name => char.name, :reason => reason), message, char)

      Global.logger.info "#{char.name} spent luck on #{reason}."
    end
  end
end
