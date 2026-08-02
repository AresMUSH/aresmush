module AresMUSH
  module Pf2e
    class RollCmd
      include CommandHandler

      attr_accessor :expression, :dc_raw

      def parse_args
        raw = cmd.args.to_s.strip
        self.expression = nil
        self.dc_raw = nil
        return if raw.blank?

        # "melee vs 20" or "athletics vs class_dc" or "spell_attack vs spell_dc"
        if raw =~ /\A(.+?)\s+vs\s+(\S+)\z/i
          self.expression = $1.strip
          self.dc_raw = $2.strip
        elsif raw =~ /\A(.+?)\s*=\s*(\S+)\z/
          self.expression = $1.strip
          self.dc_raw = $2.strip
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
        subject = sheet || enactor

        result = Pf2e.roll(self.expression, subject)

        d20_face = nil
        result[:parts].each do |part|
          if part[:type] == :dice && part[:rolls].is_a?(Array) && part[:raw].to_s =~ /d20/i
            d20_face = part[:rolls].first
            break
          end
        end

        degree = nil
        dc = nil
        if !self.dc_raw.nil?
          dc = Pf2e.resolve_dc_argument(self.dc_raw, subject)
          if dc.nil?
            client.emit_failure t('pf2e.roll_bad_dc', :dc => self.dc_raw)
            return
          end
          degree = Pf2e.degree_of_success(result[:total], dc, d20: d20_face)
        end

        client.emit format_result(result, degree, dc)
      end

      def format_result(result, degree, dc)
        parts_str = result[:parts].map { |p| format_part(p) }.join(" ")

        lines = []
        lines << "%xh#{enactor.name} rolls%xn #{result[:expression]}"
        lines << "  #{parts_str}"
        lines << "  %xhTotal:%xn #{result[:total]}"

        if !degree.nil?
          label = self.dc_raw
          lines << "  %xhvs DC #{dc}%xn (#{label}): #{format_degree(degree)}"
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
        when :ability, :skill, :save, :attack, :spell_attack, :dc
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
