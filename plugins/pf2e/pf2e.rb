module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Plugin interface
    # -------------------------------------------------

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("pf2e", "shortcuts")
    end

    # Called by the engine when the plugin is loaded / reloaded.
    def self.load
      load_data
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "sheet"
        case cmd.switch
        when "combat"
          return SheetCombatCmd
        when nil
          return SheetCmd
        end
      when "roll"
        return RollCmd if cmd.switch.nil?
      when "cg"
        case cmd.switch
        when "start"
          return CgStartCmd
        when "ancestry"
          return CgAncestryCmd
        when "heritage"
          return CgHeritageCmd
        when "background"
          return CgBackgroundCmd
        when "class"
          return CgClassCmd
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

    # -------------------------------------------------
    # Static data loader
    #
    # All static PF2e reference data (classes, feats, skills,
    # spells, etc.) lives in YAML files under data/.
    # Multiple files may contribute to the same top-level
    # section; they are deep-merged, exactly like Global
    # config files under a single section key.
    #
    # Usage mirrors Global.read_config:
    #   Pf2e.read_data                  → entire data hash
    #   Pf2e.read_data("skills")        → skills section
    #   Pf2e.read_data("skills", "athletics") → one entry
    # -------------------------------------------------

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

    # Mirrors Global.read_config(section, key = nil)
    def self.read_data(section = nil, key = nil)
      load_data if @@data.empty? && Dir.exist?(data_dir)

      return @@data if section.nil?

      section_data = @@data[section]
      return nil if section_data.nil?
      return section_data if key.nil?

      section_data[key]
    end

    # Simple recursive deep merge (hashes only; arrays/values from the
    # second hash win). Keeps the loader dependency-free.
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

# Load all helper files (they reopen AresMUSH::Pf2e)
require File.join(File.dirname(__FILE__), 'helpers')

# Template renderers (ErbTemplateRenderer subclasses)
Dir[File.join(File.dirname(__FILE__), 'templates', '*_template.rb')].sort.each { |f| require f }

# Command handlers (recursive — supports commands/<domain>/*_cmd.rb)
Dir[File.join(File.dirname(__FILE__), 'commands', '**', '*_cmd.rb')].sort.each { |f| require f }
