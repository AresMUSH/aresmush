module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Remaster terminology (source of truth)
    # Classic names accepted only as *input aliases*.
    # Engine code and new YAML should use Remaster keys.
    # -------------------------------------------------

    # Feat slot / category
    SLOT_ALIASES = {
      "combat" => "ancestry",
      "combat_feat" => "ancestry_feat"
    }.freeze

    # Class feature string markers → slot type (legacy features_by_level lists)
    CLASS_FEAT_MARKER_ALIASES = {
      "fighter_feat" => "class",
      "wizard_feat" => "class",
      "rogue_feat" => "class",
      "druid_feat" => "class",
      "bard_feat" => "class",
      "champion_feat" => "class",
      "cleric_feat" => "class",
      "monk_feat" => "class",
      "ranger_feat" => "class",
      "barbarian_feat" => "class",
      "witch_feat" => "class",
      "oracle_feat" => "class",
      "magus_feat" => "class",
      "summoner_feat" => "class",
      "inventor_feat" => "class",
      "swashbuckler_feat" => "class",
      "investigator_feat" => "class",
      "oracle_feat" => "class",
      "class_feat" => "class",
      "skill_feat" => "skill",
      "general_feat" => "general",
      "ancestry_feat" => "ancestry",
      "combat_feat" => "ancestry"
    }.freeze

    # Language
    LANGUAGE_ALIASES = {
      "druidic" => "wildsong",
      "common" => "tradetongue"
    }.freeze

    # Condition / prose (documentation + future condition keys)
    CONDITION_ALIASES = {
      "flat_footed" => "off_guard",
      "flat-footed" => "off_guard",
      "flatfooted" => "off_guard"
    }.freeze

    def self.remaster_slot(name)
      key = name.to_s.strip.downcase
      SLOT_ALIASES[key] || key
    end

    def self.remaster_language(slug)
      key = slug.to_s.strip.downcase
      LANGUAGE_ALIASES[key] || key
    end

    def self.remaster_condition(key)
      k = key.to_s.strip.downcase.tr(" ", "_")
      CONDITION_ALIASES[k] || k
    end

    # Map a legacy features_by_level token to a slot type, or nil if real feature.
    def self.slot_type_for_marker(token)
      k = token.to_s.strip.downcase
      return CLASS_FEAT_MARKER_ALIASES[k] if CLASS_FEAT_MARKER_ALIASES.key?(k)
      return "class" if k.end_with?("_feat") && !%w[skill_feat general_feat ancestry_feat combat_feat].include?(k)
      nil
    end

  end
end
