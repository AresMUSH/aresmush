module AresMUSH
  module Magic
    class SpellFatigueRequestHandler
      def handle(request)
        Global.logger.debug "REQUEST: #{request.args}.to_a"
        majorLevels = (request.args[:majorLevels] || "").strip
        minorLevels = (request.args[:minorLevels] || "").strip.to_i


        math = "Math!"
      end


    end
  end
end
