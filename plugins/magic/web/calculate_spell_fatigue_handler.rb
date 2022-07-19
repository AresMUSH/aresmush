module AresMUSH
  module Magic
    class CalculateSpellFatigueHandler
      def handle(request)
        Global.logger.debug "REQUEST: #{request.args}"
        level_1 = (request.args[:level_1] || "").strip.to_i
        level_2 = (request.args[:level_2] || "").strip.to_i
        level_3 = (request.args[:level_3] || "").strip.to_i
        level_4 = (request.args[:level_4] || "").strip.to_i
        level_5 = (request.args[:level_5] || "").strip.to_i
        level_6 = (request.args[:level_6] || "").strip.to_i
        level_7 = (request.args[:level_7] || "").strip.to_i
        level_8 = (request.args[:level_8] || "").strip.to_i
        level_9 = (request.args[:level_9] || "").strip.to_i

        fatigue_math = level_1 + level_2 + level_3 + level_4 + level_5 + level_6 + level_7 + level_8 + level_9
        Global.logger.debug "MATH: #{fatigue_math}"
        return fatigue_math
      end




    end
  end
end
