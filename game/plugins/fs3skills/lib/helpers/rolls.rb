module AresMUSH
  module FS3Skills
    
    def self.success_target_number
      6
    end
    
    # Makes an ability roll and returns the raw dice results.
    # Good for when you're doing a regular roll because you can show the raw dice and
    # use the other methods in this class to get the success level and title to display.
    def self.roll_ability(client, char, roll_params)
      dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
      roll = FS3Skills.roll_dice(dice)
      Global.logger.info "#{char.name} rolling #{roll_params} dice=#{dice} result=#{roll}"
      roll
    end
    
    # Makes an ability roll and returns a hash with the successes and success title.
    # Good for automated systems where you only care about the final result and don't need
    # to know the raw die roll.
    def self.one_shot_roll(client, char, roll_params)
      roll = FS3Skills.roll_ability(client, char, roll_params)
      roll_result = FS3Skills.get_success_level(roll)
      success_title = FS3Skills.get_success_title(roll_result)
      
      {
        :successes => roll_result,
        :success_title => success_title
      }
    end
    
    # Rolls a raw number of dice.
    def self.one_shot_die_roll(dice)
      roll = FS3Skills.roll_dice(dice)
      roll_result = FS3Skills.get_success_level(roll)
      success_title = FS3Skills.get_success_title(roll_result)

      Global.logger.info "Rolling raw dice=#{dice} result=#{roll}"
      
      {
        :successes => roll_result,
        :success_title => success_title
      }
    end
        
    # Rolls a number of FS3 dice and returns the raw die results.
    def self.roll_dice(dice)
      if (dice > 30)
        Global.logger.warn "Attempt to roll #{dice} dice."
        # Hey if they're rolling this many dice they ought to succeed spectacularly.
        return [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8]
      end
      
      dice = [dice, 1].max.ceil
      dice.times.collect { 1 + rand(8) }
    end
    
    # Determines the success level based on the raw die result.
    # Either:  0 for failure, -1 for a botch (embarrassing failure), or
    #    the number of successes.
    def self.get_success_level(die_result)
      successes = die_result.count { |d| d >= FS3Skills.success_target_number }
      botches = die_result.count { |d| d == 1 }
      return successes if (successes > 0)
      return -1 if (botches > die_result.count / 2)
      return 0
    end
    

    def self.emit_results(message, client, room, is_private)
      if (is_private)
        client.emit message
      else
        room.emit message
        channel = Global.read_config("fs3skills", "roll_channel")
        if (channel)
          Channels.send_to_channel(channel, message)
        end
        
        if (room.scene)
          Scenes::Api.add_pose(room.scene, message)
        end
        
      end
      Global.logger.info "FS3 roll results: #{message}"
    end
  end
end