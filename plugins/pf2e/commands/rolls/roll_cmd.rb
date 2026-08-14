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

        message = Pf2e.format_roll_message(enactor, result, degree: degree, dc: dc, dc_label: self.dc_raw)

        enactor_room.emit_ooc message

        scene = enactor_room.scene
        if scene && !scene.completed
          Scenes.add_to_scene(scene, message, Game.master.system_character, false, true)
        end
      end
    end
  end
end
