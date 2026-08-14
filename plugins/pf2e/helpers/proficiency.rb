module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Proficiency helpers
    # Rank → bonus calculations, level scaling, etc.
    # -------------------------------------------------

    # TEML rank → numeric proficiency bonus.
    # Accepts single-letter or full-word forms (case-insensitive).
    # Unknown / blank / nil → 0 (Untrained).
    TEML_BONUS = {
      "T" => 2, "TRAINED"   => 2,
      "E" => 4, "EXPERT"    => 4,
      "M" => 6, "MASTER"    => 6,
      "L" => 8, "LEGENDARY" => 8
    }.freeze unless const_defined?(:TEML_BONUS)

    # Ordered rank scale for comparisons (U < T < E < M < L).
    TEML_ORDER = {
      "U" => 0, "UNTRAINED" => 0,
      "T" => 1, "TRAINED"   => 1,
      "E" => 2, "EXPERT"    => 2,
      "M" => 3, "MASTER"    => 3,
      "L" => 4, "LEGENDARY" => 4
    }.freeze

    def self.teml_to_bonus(rank)
      return 0 if rank.nil? || rank.to_s.strip.empty?
      TEML_BONUS[rank.to_s.strip.upcase] || 0
    end

    def self.teml_order(rank)
      return 0 if rank.nil? || rank.to_s.strip.empty?
      TEML_ORDER[rank.to_s.strip.upcase] || 0
    end

    # True if actual rank is at least the required rank.
    def self.teml_at_least?(actual, required)
      teml_order(actual) >= teml_order(required)
    end

  end
end
