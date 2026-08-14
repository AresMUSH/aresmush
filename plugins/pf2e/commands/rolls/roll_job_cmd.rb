module AresMUSH
  module Pf2e
    class RollJobCmd
      include CommandHandler

      attr_accessor :number, :expression, :dc_raw

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.number = trim_arg(args.arg1)
        raw = args.arg2.to_s.strip

        self.expression = nil
        self.dc_raw = nil
        return if raw.blank?

        if raw =~ /\A(.+?)\s+vs\s+(\S+)\z/i
          self.expression = $1.strip
          self.dc_raw = $2.strip
        elsif raw =~ /\A(.+?)\s*=\s*(\S+)\z/
          # avoid confusion with job#=expr; only if inner vs-style without spaces around =
          self.expression = $1.strip
          self.dc_raw = $2.strip
        else
          self.expression = raw
        end
      end

      def required_args
        [ self.number, self.expression ]
      end

      def check_expression
        return t('pf2e.roll_job_usage') if self.number.blank? || self.expression.blank?
        nil
      end

      def handle
        Jobs.with_a_job(enactor, client, self.number) do |job|
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

          message = Pf2e.format_roll_message(enactor, result, degree: degree, dc: dc, dc_label: self.dc_raw)

          # System-authored so it reads as a roll log line, same as FS3 web job rolls
          Jobs.comment(job, Game.master.system_character, message, false)

          client.emit_success t('pf2e.roll_job_ok', :number => job.id)
          client.emit message
        end
      end
    end
  end
end
