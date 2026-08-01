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
    }.freeze

    def self.teml_to_bonus(rank)
      return 0 if rank.nil? || rank.to_s.strip.empty?
      TEML_BONUS[rank.to_s.strip.upcase] || 0
    end

  end
end
