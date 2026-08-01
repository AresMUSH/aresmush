module AresMUSH
  module AltTracker

    # -------------------------------------------------
    # Email utilities
    # -------------------------------------------------
    def self.valid_email?(email)
      return false if email.blank?
      email.strip =~ /\A[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\z/i
    end

    def self.normalize_email(email)
      return nil if email.blank?
      email.strip.downcase
    end

    def self.find_by_email(email)
      return nil if !valid_email?(email)
      AltTrackerRecord.find(player_email: normalize_email(email)).first
    end

    # -------------------------------------------------
    # Registration / linking
    # -------------------------------------------------
    def self.find_or_create_and_link(char, email, code_word = nil)
      return nil if !char
      return nil if !valid_email?(email)

      normalized = normalize_email(email)
      supplied_code = code_word.blank? ? nil : code_word.strip

      tracker = AltTrackerRecord.find(player_email: normalized).first

      if tracker
        return nil if supplied_code.nil?
        return nil if tracker.code_word != supplied_code
        return nil if is_banned?(char)

        begin
          char.update(alt_tracker: tracker)
        rescue Exception => e
          Global.logger.error "AltTracker link failed for #{char.name}: #{e.message}"
          return nil
        end
        return tracker
      end

      return nil if supplied_code.nil?

      begin
        tracker = AltTrackerRecord.create(
          player_email: normalized,
          code_word: supplied_code,
          banned: false,
          ban_history: []
        )
        char.update(alt_tracker: tracker)
      rescue Exception => e
        Global.logger.error "AltTracker create/link failed for #{char.name}: #{e.message}"
        return nil
      end

      tracker
    end

    def self.link_to_existing_alt(char, other_char, code_word)
      return nil if !char || !other_char
      return nil if code_word.blank?

      tracker = other_char.alt_tracker
      return nil if !tracker
      return nil if tracker.code_word != code_word.strip
      return nil if tracker.banned

      begin
        char.update(alt_tracker: tracker)
      rescue Exception => e
        Global.logger.error "AltTracker link_to_existing failed for #{char.name}: #{e.message}"
        return nil
      end

      tracker
    end

    # -------------------------------------------------
    # Player self-update
    # -------------------------------------------------
    def self.update_tracker(char, new_value, code_word)
      return nil if !char
      return nil if new_value.blank? || code_word.blank?

      tracker = char.alt_tracker
      return nil if !tracker
      return nil if tracker.banned
      return nil if tracker.code_word != code_word.strip

      begin
        if valid_email?(new_value)
          normalized = normalize_email(new_value)
          existing = find_by_email(normalized)
          return nil if existing && existing.id != tracker.id

          tracker.update(player_email: normalized)
          { tracker: tracker, changed: :email, value: normalized }
        else
          new_code = new_value.strip
          tracker.update(code_word: new_code)
          { tracker: tracker, changed: :code_word, value: new_code }
        end
      rescue Exception => e
        Global.logger.error "AltTracker update failed for #{char.name}: #{e.message}"
        nil
      end
    end

    # -------------------------------------------------
    # Status
    # -------------------------------------------------
    def self.status_for(char)
      return nil if !char
      tracker = char.alt_tracker
      return nil if !tracker

      {
        tracker: tracker,
        email: tracker.player_email,
        banned: is_banned?(char),
        characters: tracker.characters.to_a.sort_by { |c| c.name }
      }
    end

    # -------------------------------------------------
    # Ban system
    # -------------------------------------------------
    def self.is_banned?(char)
      return false if !char
      tracker = char.alt_tracker
      return false if !tracker
      return false if !tracker.banned

      # Permanent ban
      return true if tracker.ban_expires.nil?

      # Temporary – check expiration
      if Time.now >= tracker.ban_expires
        tracker.update(banned: false, ban_expires: nil)
        return false
      end

      true
    end

    def self.ban_tracker(char, enactor, days = nil)
      return nil if !char || !enactor
      tracker = char.alt_tracker
      return nil if !tracker

      begin
        if days.nil? || days.to_i <= 0
          expires = nil
          duration_text = "permanently"
          days_value = nil
        else
          expires = Time.now + (days.to_i * 24 * 60 * 60)
          duration_text = "for #{days} day(s) (until #{expires.strftime('%Y-%m-%d %H:%M')})"
          days_value = days.to_i
        end

        history_entry = {
          action: "ban",
          by: enactor.name,
          at: Time.now,
          days: days_value,
          expires: expires
        }

        new_history = (tracker.ban_history || []) + [history_entry]

        tracker.update(
          banned: true,
          ban_expires: expires,
          ban_history: new_history
        )

        Global.logger.info "AltTracker: #{enactor.name} BANNED tracker for #{char.name} " +
                           "(email: #{tracker.player_email}) #{duration_text}."
        tracker
      rescue Exception => e
        Global.logger.error "AltTracker ban failed for #{char.name}: #{e.message}"
        nil
      end
    end

    def self.unban_tracker(char, enactor)
      return nil if !char || !enactor
      tracker = char.alt_tracker
      return nil if !tracker

      begin
        history_entry = {
          action: "unban",
          by: enactor.name,
          at: Time.now,
          days: nil,
          expires: nil
        }

        new_history = (tracker.ban_history || []) + [history_entry]

        tracker.update(
          banned: false,
          ban_expires: nil,
          ban_history: new_history
        )

        Global.logger.info "AltTracker: #{enactor.name} UNBANNED tracker for #{char.name} " +
                           "(email: #{tracker.player_email})."
        tracker
      rescue Exception => e
        Global.logger.error "AltTracker unban failed for #{char.name}: #{e.message}"
        nil
      end
    end

    def self.ban_history_for(char)
      return nil if !char
      tracker = char.alt_tracker
      return nil if !tracker
      tracker.ban_history || []
    end

    # -------------------------------------------------
    # Staff code-word tools
    # -------------------------------------------------
    def self.staff_reset_code_word(char, new_code_word, enactor)
      return nil if !char || !enactor
      return nil if new_code_word.blank?

      tracker = char.alt_tracker
      return nil if !tracker

      begin
        old_word = tracker.code_word
        tracker.update(code_word: new_code_word.strip)

        Global.logger.info "AltTracker: #{enactor.name} reset code word for #{char.name} " +
                           "(email: #{tracker.player_email}). Old word was '#{old_word}'."
        tracker
      rescue Exception => e
        Global.logger.error "AltTracker staff code word reset failed for #{char.name}: #{e.message}"
        nil
      end
    end

    def self.code_word_for(char, enactor = nil)
      return nil if !char
      tracker = char.alt_tracker
      return nil if !tracker

      if enactor
        Global.logger.info "AltTracker: #{enactor.name} viewed code word for #{char.name} " +
                           "(email: #{tracker.player_email})."
      end

      tracker.code_word
    end

  end
end
