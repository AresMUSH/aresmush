module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Check / degree-of-success helpers
    # -------------------------------------------------

    # Degree of success from a check total vs DC.
    # Returns one of: :critical_success, :success, :failure, :critical_failure
    #
    # Optional d20 face applies the natural 20 / natural 1 adjustment
    # (upgrade or downgrade the degree by one step).
    def self.degree_of_success(total, dc, d20: nil)
      margin = total.to_i - dc.to_i

      degree = if margin >= 10
                 :critical_success
               elsif margin >= 0
                 :success
               elsif margin <= -10
                 :critical_failure
               else
                 :failure
               end

      return degree if d20.nil?

      face = d20.to_i
      if face == 20
        upgrade_degree(degree)
      elsif face == 1
        downgrade_degree(degree)
      else
        degree
      end
    end

    # Move one step toward critical success.
    def self.upgrade_degree(degree)
      case degree
      when :critical_failure then :failure
      when :failure          then :success
      when :success          then :critical_success
      else degree  # already critical success
      end
    end

    # Move one step toward critical failure.
    def self.downgrade_degree(degree)
      case degree
      when :critical_success then :success
      when :success          then :failure
      when :failure          then :critical_failure
      else degree  # already critical failure
      end
    end

    # -------------------------------------------------
    # Level-based DCs (GM convenience)
    # -------------------------------------------------

    # Rank DC by level (Core Rulebook / GM Core).
    # rank: "T"/"E"/"M"/"L" or full word
    # level: creature or party level
    #
    # Trained    = level + 14
    # Expert     = level + 16
    # Master     = level + 18
    # Legendary  = level + 20
    def self.rank_dc(level, rank = "T")
      bonus = case teml_to_bonus(rank)
              when 2 then 14
              when 4 then 16
              when 6 then 18
              when 8 then 20
              else 12  # untrained-ish / fallback: level + 12
              end
      level.to_i + bonus
    end

    # Simple DCs by difficulty band at a given level.
    # band: :untrained, :trained, :expert, :master, :legendary
    #       or :easy, :medium, :hard, :very_hard (relative to trained)
    #
    # Uses the standard rank DC table as the backbone:
    #   easy       ≈ trained - 2  → level + 12
    #   medium     ≈ trained      → level + 14
    #   hard       ≈ expert       → level + 16
    #   very_hard  ≈ master       → level + 18
    def self.simple_dc(level, band = :medium)
      key = band.to_s.strip.downcase.to_sym
      rank = case key
             when :untrained, :easy then "U"
             when :trained, :medium then "T"
             when :expert, :hard then "E"
             when :master, :very_hard then "M"
             when :legendary then "L"
             else "T"
             end
      rank_dc(level, rank)
    end

  end
end
