module AresMUSH
  module Msystem

    def self.get_partial_skill(partial)
      get_partial(get_stat_names("skills"), partial)
    end

    def self.get_partial_characteristic(partial)
      get_partial(get_stat_names("characteristics"), partial)
    end

    def self.roll(char, values)
      pool = {}
      base_skill = nil
      is_skill_check = false
      adjusted_skill_total = 0

      values.map do |part|
        term, val = part.first
        case term
        when :dice
          dice, sides = val.split("d").reject(&:empty?).map(&:to_i)
          sides, dice = [dice, 1] if sides.nil?
          pool[sides] = !pool.key?(sides) ? dice : pool[sides] + dice
        when :literal
          adjusted_skill_total += val
        when :skill
          skill = get_stat(char, val) 
          if base_skill.nil?
            base_skill = skill
            adjusted_skill_total += skill.total
          else
            adjusted_skill_total += get_augment(skill.total)
          end
          is_skill_check = true
        when :characteristic
          adjusted_skill_total += get_stat(char, val).rating
          is_skill_check = true
        when :difficulty
          adjusted_skill_total += get_difficulty(val, adjusted_skill_total)
        end
      end
      {
        is_skill_check: is_skill_check,
        skill: adjusted_skill_total,
        skill_roll: roll_dice(100),
        dice_roll: pool.map{ |sides, dice| roll_dice(sides, dice) }.flatten.reduce(:+)
      }
    end

    def self.roll_dice(sides, dice = 1)
      dice = 30 if dice > 30
      dice = 1 if dice < 1

      dice.times.map{ |d| rand(sides) + 1 }.reduce(:+)
    end

    def self.parse_roll(roll)
      values = []
      roll.gsub(/\s+/, "").scan(/[+-@]?\w+/i).each do |val|
        skill = get_partial_skill(val.gsub("-", ""))
        characteristic = get_partial_characteristic(val.gsub("-", ""))
        difficulty = get_partial(difficulties, val.gsub("@", ""))

        if /^\+?(\d+)?d\d+/.match?(val)
          values << { dice: val.gsub("+", "") }
        elsif /^[-+]?\d+$/.match(val)
          values << { literal: val.to_i }
        elsif skill
          values << { skill: skill }
        elsif characteristic
          values << { characteristic: characteristic }
        elsif difficulty
          values << { difficulty: difficulty }
        else
          values << { invalid: val }
        end
      end
      order = [:skill, :literal, :dice, :characteristic, :difficulty, :invalid]
      values.sort!{ |a, b| order.index(a.keys.first) <=> order.index(b.keys.first) }
    end

    def self.get_type_from_roll(type, values)
      values.select{ |val| val.keys.first == type.to_sym }
    end

    def self.get_roll_results(results, values = [])
      state = ""
      dice = ""
      roll = ""

      skills = get_type_from_roll("skill", values)
      diff = get_type_from_roll("difficulty", values).first
      values.reject!{ |val| val.has_key?(:difficulty) || val.has_key?(:skill) }

      if skills.size > 0
        roll = "#{skills[0][:skill]}"
        if skills.size == 2
          roll += " " + t("msystem.augmented_by", name: skills[1][:skill])
        end

        if (results[:skill_roll] >= 99 && results[:skill] < 100) || (results[:skill_roll] == 00)
          state = "%xh%xr#{t('msystem.fumble')}!%xn"
        elsif results[:skill_roll] > 95 || results[:skill_roll] > results[:skill]
          state = "%xr#{t('msystem.failure')}%xn"
        elsif (results[:skill_roll] / 10).ceil >= results[:skill_roll]
          state = "%xh%xy#{t('msystem.critical_success')}!%xn"
        elsif results[:skill_roll] <= 5 || results[:skill_roll] <= results[:skill]
          state = "%xy#{t('msystem.success')}%xn"
        end
        dice = "%xc#{results[:skill_roll]}%%xn"
      end

      roll += " + " if !values.empty?
      roll += values.map {|v| v.values }.flatten.join(" + ")
      roll += " " + t("msystem.roll_difficulty_at", difficulty: diff[:difficulty]) if diff

      if !results[:dice_roll].nil?
        dice += " " if skills.size > 0
        dice += "%xy#{results[:dice_roll]}%xn"
      end

      {
        roll: roll,
        dice: dice,
        state: state
      }
    end

    def self.parse_roll_errors(values)
      errors = []
      invalid = []
      skill_count = 0
      values.each do |val|
        invalid << val[:invalid] if val.key?(:invalid)
        skill_count += 1 if val.key?(:skill)
      end
      errors << t("msystem.only_one_augment") if skill_count > 2
      errors << t("msystem.invalid_terms_found", values: invalid.join(", ")) if !invalid.empty?
      errors if !errors.empty?
    end

    def self.emit_results(message, client, room, is_private)
      if (is_private)
        client.emit message
      else
        room.emit message
        channel = Global.read_config("msystem", "roll_channel")
        if (channel)
          Channels.send_to_channel(channel, message)
        end

        if (room.scene)
          Scenes.add_to_scene(room.scene, message)
        end

      end
      Global.logger.info "Roll results: #{message}"
    end

    def self.emit_web_results(request, enactor)
      roll_str = request.args[:roll_string]

      errors = parse_roll_errors(roll_str)
      values = parse_roll(roll_str)

      if !errors.empty?
        message = { error: errors.join("<br/>") }
      else
        results = roll(enactor, values)
        roll = get_roll_results(results, values)

        message = {
          message: t("msystem.simple_roll_result",
            system: system_prompt,
            name: enactor.name,
            roll: roll[:roll],
            dice: roll[:dice],
            success: roll[:state]
          )
        }
      end
    end
  end
end