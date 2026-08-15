module AresMUSH
  module Pf2e
    class SpellsCastCmd
      include CommandHandler

      attr_accessor :source, :spell, :rank

      def parse_args
        # spells/cast <spell>
        # spells/cast <spell> <rank>
        # spells/cast <source>=<spell>
        # spells/cast <source>=<spell> <rank>
        raw = cmd.args.to_s.strip
        self.source = nil
        self.spell = nil
        self.rank = nil
        return if raw.blank?

        if raw =~ /\A([^=\s]+)=(.+)\z/
          self.source = $1.strip
          rest = $2.strip
        else
          rest = raw
        end

        bits = rest.split(/\s+/)
        self.spell = bits[0].to_s.strip.downcase.gsub(/-/, '_')
        if bits[1] && bits[1] =~ /\A\d+\z/
          self.rank = bits[1].to_i
        end
      end

      def check_args
        return t('pf2e.magic_cast_usage') if self.spell.blank?
        nil
      end

      def handle
        result = Pf2e.magic_cast(enactor, self.spell, source: self.source, rank: self.rank)

        unless result[:ok]
          emit_cast_failure(result)
          return
        end

        message = Pf2e.format_cast_message(enactor, result)

        # Room OOC + active scene log (same pattern as roll)
        enactor_room.emit_ooc message

        scene = enactor_room.scene
        if scene && !scene.completed
          Scenes.add_to_scene(scene, message, Game.master.system_character, false, true)
        end
      end

      def emit_cast_failure(result)
        case result[:error]
        when "pf2e.magic_source_required"
          client.emit_failure t('pf2e.magic_source_required', :sources => Array(result[:sources]).join(', '))
        when "pf2e.magic_unknown_source"
          client.emit_failure t('pf2e.magic_unknown_source', :sources => Array(result[:sources]).join(', '))
        when "pf2e.magic_unknown_spell"
          client.emit_failure t('pf2e.magic_unknown_spell', :spells => Array(result[:spells]).join(', '))
        when "pf2e.magic_not_known"
          client.emit_failure t('pf2e.magic_not_known', :spell => result[:spell], :source => result[:source])
        when "pf2e.magic_not_prepared_spell"
          client.emit_failure t('pf2e.magic_not_prepared_spell', :spell => result[:spell], :source => result[:source], :rank => result[:rank])
        when "pf2e.magic_rank_too_low"
          client.emit_failure t('pf2e.magic_rank_too_low', :spell => result[:spell], :base => result[:base_rank], :rank => result[:rank])
        when "pf2e.magic_no_slot_rank"
          client.emit_failure t('pf2e.magic_no_slot_rank', :rank => result[:rank])
        when "pf2e.magic_slots_exhausted"
          client.emit_failure t('pf2e.magic_slots_exhausted', :rank => result[:rank])
        when "pf2e.focus_exhausted"
          client.emit_failure t('pf2e.focus_exhausted', :current => result[:current], :needed => result[:needed])
        when "pf2e.innate_exhausted"
          client.emit_failure t('pf2e.innate_exhausted', :spell => result[:spell], :used => result[:used], :max => result[:max])
        when "pf2e.innate_not_found"
          client.emit_failure t('pf2e.innate_not_found', :spell => result[:spell])
        when "pf2e.magic_cast_usage"
          client.emit_failure t('pf2e.magic_cast_usage')
        else
          client.emit_failure t(result[:error] || 'pf2e.no_sheet')
        end
      end
    end
  end
end
