module AresMUSH
  module Chargen
    def self.can_approve?(actor)
      actor.has_permission?("manage_apps")
    end

    def self.bg_app_review(char)
      error = char.background.to_s.empty? ? t('chargen.not_set') : t('chargen.ok')
      Chargen.format_review_status t('chargen.background_review'), error
    end

    def self.can_manage_bgs?(actor)
      actor.has_permission?("manage_apps")
    end

    def self.can_view_bgs?(actor)
      return false if !actor
      Chargen.can_manage_bgs?(actor) || actor.has_permission?("view_bgs")
    end

    def self.can_edit_bg?(actor, model, client)
      if (model.is_approved? && !Chargen.can_manage_bgs?(actor))
        client.emit_failure t('chargen.cannot_edit_after_approval')
        return false
      end

      if (actor != model && !Chargen.can_manage_bgs?(actor))
        client.emit_failure t('chargen.cannot_edit_bg')
        return false
      end

      return true
    end

    def self.unsubmit_app(char)
      char.update(chargen_locked: false)

      job = char.approval_job
      return if !job

      Jobs.change_job_status(char,
        job,
        Global.read_config("chargen", "app_hold_status"),
        t('chargen.app_job_unsubmitted'))
    end

    def self.read_tutorial(name)
      filename = File.join(File.dirname(__FILE__), 'templates', name)
      File.read(filename, :encoding => "UTF-8")
    end

    def self.stages
      Global.read_config("chargen", "stages")
    end

    def self.stage_name(char)
      stage = char.chargen_stage
      stage ? Chargen.stages.keys[stage] : nil
    end

    def self.save_char(char, chargen_data)
      alerts = []

      chargen_data[:demographics].each do |k, v|
        char.update_demographic(k, v[:value])
      end

      age_or_bday = chargen_data[:demographics][:age][:value]

      # See if it's just an age.
      if (age_or_bday.is_integer?)
        age = age_or_bday.to_i
        if (age != char.age)
          age_error = Demographics.check_age(age)
          if (age_error)
            alerts << age_error
          else
            Demographics.set_random_birthdate(char, age)
          end
        end
      # Assume it's a birthdate string
      else
        result = Demographics.set_birthday(char, age_or_bday)
        if (result[:error])
          alerts << result[:error]
        end
      end

      chargen_data[:groups].each do |k, v|
        Demographics.set_group(char, v[:name], v[:value])
      end

      if (Ranks.is_enabled?)
        rank_error = Ranks.set_rank(char, chargen_data[:groups][:rank][:value])
        if (rank_error)
          alerts << rank_error
        end
      end

      char.update(cg_background: Website.format_input_for_mush(chargen_data[:background]))
      char.update(idle_lastwill: Website.format_input_for_mush(chargen_data[:lastwill]))

      char.update(rp_hooks: Website.format_input_for_mush(chargen_data[:rp_hooks]))
      char.update(description: Website.format_input_for_mush(chargen_data[:desc]))
      char.update(shortdesc: Website.format_input_for_mush(chargen_data[:shortdesc]))
      char.update(profile_image: chargen_data[:profile_image])

      if FS3Skills.is_enabled?
        error = FS3Skills.save_char(char, chargen_data)
        if (error)
          alerts << error
        end
      end

      # char.update(secretpref: chargen_data[:secretpref][:value])
      return alerts
    end

    def self.approve_char(enactor, model, notes)
      if (model.is_approved?)
        return t('chargen.already_approved', :name => model.name)
      end

      job = model.approval_job

      if (!job)
        return t('chargen.no_app_submitted', :name => model.name)
      end

      Jobs.close_job(enactor, job, "#{Global.read_config("chargen", "approval_message")}%R%R#{notes}")
      Roles.add_role(model, "approved")

      model.update(approval_job: nil)

      Achievements.award_achievement(model, "created_character", 'story', "Created a character.")

      welcome_message = Global.read_config("chargen", "welcome_message")
      welcome_message_args = { name: model.name }
      Demographics.all_groups.keys.each do |k|
        welcome_message_args[k.downcase.to_sym] = model.group(k)
      end
      post_body = welcome_message % welcome_message_args

      Forum.system_post(
        Global.read_config("chargen", "arrivals_category"),
        t('chargen.approval_post_subject', :name => model.name),
        post_body)

      # Jobs.create_job("SECRET",
      #    t('chargen.approval_job_subject', :name => model.name),
      #    "Set their secrets. Their secret pref is: #{model.secretpref}",
      #    Game.master.system_character)

       Chargen.custom_approval(model)

       Global.dispatcher.queue_event CharApprovedEvent.new(Login.find_client(model), model.id)

       return nil
     end

     def self.reject_char(enactor, model, notes)
       if (model.is_approved?)
         return t('chargen.already_approved', :name => model.name)
       end

       job = model.approval_job
       if (!job)
         return t('chargen.no_app_submitted', :name => model.name)
       end

       model.update(chargen_locked: false)

       Jobs.change_job_status(enactor,
         job,
         Global.read_config("chargen", "app_hold_status"),
         "#{Global.read_config("chargen", "rejection_message")}%R%R#{notes}")

       return nil
     end

     def self.build_app_review_info(char)
       abilities_app = FS3Skills.is_enabled? ? MushFormatter.format(FS3Skills.app_review(char)) : nil
       demographics_app = MushFormatter.format Demographics.app_review(char)
       bg_app = MushFormatter.format Chargen.bg_app_review(char)
       desc_app = MushFormatter.format Describe.app_review(char)
       ranks_app = Ranks.is_enabled? ? MushFormatter.format(Ranks.app_review(char)): nil
       hooks_app = MushFormatter.format Chargen.hook_app_review(char)

       custom_review = Chargen.custom_app_review(char)
       custom_app = custom_review ? MushFormatter.format(custom_review) : nil

       {
         abilities: abilities_app,
         demographics: demographics_app,
         background: bg_app,
         desc: desc_app,
         ranks: ranks_app,
         hooks: hooks_app,
         name: char.name,
         id: char.id,
         job: char.approval_job ? char.approval_job.id : nil,
         custom: custom_app,
         allow_web_submit: Global.read_config("chargen", "allow_web_submit")
       }
     end
  end
end
