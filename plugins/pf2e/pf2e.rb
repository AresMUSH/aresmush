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
      when "roll"
        case cmd.switch
        when nil then return RollCmd
        when "job" then return RollJobCmd
        end
      when "feats"
        return FeatSearchCmd if cmd.switch.nil?
      when "pf2e"
        case cmd.switch
        when "set" then return Pf2eSetCmd
        when "reset" then return Pf2eResetCmd
        end
      when "cg"
        case cmd.switch
        when "start" then return CgStartCmd
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
