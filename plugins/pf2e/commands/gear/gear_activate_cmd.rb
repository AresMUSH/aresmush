module AresMUSH
  module Pf2e
    class GearActivateCmd
      include CommandHandler

      attr_accessor :item_id, :spell_slug

      def parse_args
        args = cmd.args.to_s.strip
        if args =~ /\A(\S+)\s+(\S+)\z/
          self.item_id = Regexp.last_match(1).downcase
          self.spell_slug = Regexp.last_match(2).downcase
        else
          self.item_id = args.downcase
          self.spell_slug = nil
        end
      end

      def check_args
        return t('pf2e.spell_item_activate_usage') if self.item_id.blank?
        nil
      end

      def handle
        result = Pf2e.spell_item_activate(enactor, self.item_id, spell_slug: self.spell_slug)
        unless result[:ok]
          case result[:error]
          when "pf2e.spell_item_no_charges"
            client.emit_failure t('pf2e.spell_item_no_charges',
                                 :charges => result[:charges],
                                 :needed => result[:needed],
                                 :max => result[:max])
          when "pf2e.spell_item_staff_need_spell"
            client.emit_failure t('pf2e.spell_item_staff_need_spell',
                                 :options => Array(result[:options]).join(', '))
          when "pf2e.spell_item_staff_unknown"
            client.emit_failure t('pf2e.spell_item_staff_unknown', :spell => result[:spell])
          when "pf2e.spell_item_wrong_spell"
            client.emit_failure t('pf2e.spell_item_wrong_spell', :spell => result[:spell])
          else
            client.emit_failure t(result[:error] || 'pf2e.no_sheet')
          end
          return
        end

        client.emit_success t('pf2e.spell_item_activate_ok',
                              :type => result[:type],
                              :name => result[:item_name],
                              :spell => result[:spell],
                              :rank => result[:rank],
                              :dc => result[:dc],
                              :attack => result[:attack],
                              :caster => result[:using_caster] ? 'your' : 'item',
                              :charges => format_charges(result))
      end

      def format_charges(result)
        if result[:consumed]
          "scroll consumed"
        elsif result[:type] == "scroll"
          "#{result[:charges]} left"
        else
          "#{result[:charges]}/#{result[:charges_max]} charges"
        end
      end
    end
  end
end
