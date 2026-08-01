module AresMUSH
  module Pf2e
    class RollCmd
      include CommandHandler

      attr_accessor :expression, :dc

      def parse_args
        raw = cmd.args.to_s.strip
        self.expression = nil
        self.dc = nil
        return if raw.blank?

        # "athletics vs 20" or "1d20+str vs 15"
        if raw =~ /\A(.+?)\s+vs\s+(\d+)\z/i
          self.expression = $1.strip
          self.dc = $2.to_i
        # "athletics=20"
        elsif raw =~ /\A(.+?)\s*=\s*(\d+)\z/
          self.expression = $1.strip
          self.dc = $2.to_i
        else
          self.expression = raw
        end
      end

      def check_expression
        return t('pf2e.roll_usage') if self.expression.blank?
        nil
      end

      def handle
        sheet = Pf2e.sheet_for(enactor)
        # Rolls still work without a sheet for pure dice; ability/skill/save terms → 0

        result = Pf2e.roll(self.expression, sheet || enactor)

        # Optional DC → degree of success (use d20 face from parts if present)
        d20_face = nil
        result[:parts].each do |part|
          if part[:type] == :dice && part[:rolls].is_a?(Array) && part[:raw].to_s =~ /d20/i
            d20_face = part[:rolls].first
            break
          end
        end

        degree = nil
        if !self.dc.nil?
          degree = Pf2e.degree_of_success(result[:total], self.dc, d20: d20_face)
        end

        client.emit format_result(result, degree)
      end

      def format_result(result, degree)
        parts_str = result[:parts].map { |p| format_part(p) }.join(" ")

        lines = []
        lines << "%xh#{enactor.name} rolls%xn #{result[:expression]}"
        lines << "  #{parts_str}"
        lines << "  %xhTotal:%xn #{result[:total]}"

        if !degree.nil?
          lines << "  %xhvs DC #{self.dc}:%xn #{format_degree(degree)}"
        end

        lines.join("%r")
      end

      def format_part(part)
        case part[:type]
        when :dice
          rolls = Array(part[:rolls]).join(",")
          val = part[:value]
          if val < 0
            "#{part[:raw]}(#{rolls})=#{val}"
          else
            "+#{part[:raw]}(#{rolls})=#{val}"
          end
        when :flat
          val = part[:value]
          val < 0 ? "#{val}" : "+#{val}"
        when :ability, :skill, :save
          val = part[:value]
          label = part[:raw]
          val < 0 ? "#{label}(#{val})" : "+#{label}(#{val})"
        else
          val = part[:value]
          val < 0 ? "#{part[:raw]}(#{val})" : "+#{part[:raw]}(#{val})"
        end
      end

      def format_degree(degree)
        case degree
        when :critical_success then "%xgCritical Success%xn"
        when :success          then "%xgSuccess%xn"
        when :failure          then "%xyFailure%xn"
        when :critical_failure then "%xrCritical Failure%xn"
        else degree.to_s
        end
      end
    end
  end
end
