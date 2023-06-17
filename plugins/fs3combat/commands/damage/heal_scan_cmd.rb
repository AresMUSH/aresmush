module AresMUSH
  module FS3Combat
    class HealScanCmd
      include CommandHandler

      def handle
        damage = {}
        Character.all.each do |c|
          damage_mod = FS3Combat.total_damage_mod(c)
          if (damage_mod != 0)
            damage[c.name] = damage_mod
          end
        end

        Mount.all.each do |c|
          damage_mod = FS3Combat.total_damage_mod(c)
          if (damage_mod != 0)
            damage[c.name] = damage_mod
          end
        end

        list = damage.sort_by { |k, v| v }.map { |name, damage_mod| "#{name.ljust(30)} #{damage_mod}" }

        template = BorderedListTemplate.new list, t('fs3combat.damage_scan_title'), nil, t('fs3combat.damage_scan_subtitle')
        client.emit template.render
      end



    end
  end
end