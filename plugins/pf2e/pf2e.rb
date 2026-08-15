module AresMUSH
  module Pf2e

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("pf2e", "shortcuts")
    end

    def self.load
      load_data
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "sheet"
        case cmd.switch
        when "combat" then return SheetCombatCmd
        when nil then return SheetCmd
        end
      when "money"
        case cmd.switch
        when nil then return MoneyCmd
        when "deposit" then return MoneyDepositCmd
        when "withdraw" then return MoneyWithdrawCmd
        when "optimize" then return MoneyOptimizeCmd
        end
      when "gear", "inv", "inventory"
        case cmd.switch
        when nil then return GearCmd
        when "add" then return GearAddCmd
        when "drop" then return GearDropCmd
        when "equip" then return GearEquipCmd
        when "unequip" then return GearUnequipCmd
        when "stow" then return GearStowCmd
        when "retrieve" then return GearRetrieveCmd
        when "activate", "use" then return GearActivateCmd
        end
      when "shop"
        case cmd.switch
        when nil then return ShopCmd
        when "buy" then return ShopBuyCmd
        when "sell" then return ShopSellCmd
        end
      when "spells", "spell"
        case cmd.switch
        when nil then return SpellsCmd
        when "daily", "rest" then return SpellsDailyCmd
        when "prepare", "prep" then return SpellsPrepareCmd
        when "learn" then return SpellsLearnCmd
        when "cast" then return SpellsCastCmd
        end
      when "rituals", "ritual"
        case cmd.switch
        when nil then return RitualsCmd
        when "info", "show" then return RitualsInfoCmd
        when "check", "cast" then return RitualsCheckCmd
        end
      when "roll"
        case cmd.switch
        when nil then return RollCmd
        when "job" then return RollJobCmd
        end
      when "feats"
        return FeatSearchCmd if cmd.switch.nil?
      when "focus"
        return FocusCmd if cmd.switch.nil?
      when "refocus"
        return RefocusCmd if cmd.switch.nil?
      when "pf2e"
        case cmd.switch
        when "set" then return Pf2eSetCmd
        when "reset" then return Pf2eResetCmd
        end
      when "adv", "level"
        case cmd.switch
        when nil, "status" then return AdvStatusCmd
        when "start" then return AdvStartCmd
        when "finish", "done" then return AdvFinishCmd
        when "skill" then return AdvSkillCmd
        when "boost" then return AdvBoostCmd
        when "feat" then return AdvFeatCmd
        end
      when "cg"
        case cmd.switch
        when "ancestry" then return CgAncestryCmd
        when "heritage" then return CgHeritageCmd
        when "background" then return CgBackgroundCmd
        when "class" then return CgClassCmd
        when "identity" then return CgIdentityCmd
        when "commit" then return CgCommitCmd
        when "reset" then return CgResetCmd
        when "boost" then return CgBoostCmd
        when "skill" then return CgSkillCmd
        when "bgskill" then return CgBgskillCmd
        when "language" then return CgLanguageCmd
        when "feat" then return CgFeatCmd
        when "unfeat" then return CgFeatRemoveCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name)
      case event_name
      when "SceneSharedEvent"
        return SceneSharedEventHandler
      end
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

    @@data = {}

    def self.data_dir
      File.join(plugin_dir, "data")
    end

    def self.load_data
      @@data = {}
      return unless Dir.exist?(data_dir)
      Dir[File.join(data_dir, "*.yml")].sort.each do |path|
        begin
          raw = YAML.load_file(path)
          next unless raw.is_a?(Hash)
          @@data = deep_merge(@@data, raw)
        rescue => e
          Global.logger.error "Pf2e data load failed for #{path}: #{e.message}"
        end
      end
      Global.logger.info "Pf2e loaded static data from #{Dir[File.join(data_dir, '*.yml')].size} file(s)."
    end

    def self.read_data(section = nil, key = nil)
      load_data if @@data.empty? && Dir.exist?(data_dir)
      return @@data if section.nil?
      section_data = @@data[section]
      return nil if section_data.nil?
      return section_data if key.nil?
      section_data[key]
    end

    def self.deep_merge(base, overlay)
      result = base.dup
      overlay.each do |k, v|
        if v.is_a?(Hash) && result[k].is_a?(Hash)
          result[k] = deep_merge(result[k], v)
        else
          result[k] = v
        end
      end
      result
    end

  end
end

require File.join(File.dirname(__FILE__), 'helpers')
Dir[File.join(File.dirname(__FILE__), 'templates', '*_template.rb')].sort.each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'commands', '**', '*_cmd.rb')].sort.each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'events', '**', '*_handler.rb')].sort.each { |f| require f }
