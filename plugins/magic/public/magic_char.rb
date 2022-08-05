module AresMUSH
  class Character
    collection :spells_learned, "::SpellsLearned"
    collection :magic_shields, "AresMUSH::MagicShields"
    attribute :spells_cast, :type => DataType::Integer
    attribute :achievement_spells_learned, :type => DataType::Integer
    attribute :achievement_spells_discarded, :type => DataType::Integer
    attribute :magic_energy, :type => DataType::Integer, :default => 16
    attribute :dead, :type => DataType::Boolean, :default => false
    attribute :has_died, :type => DataType::Integer
    attribute :schools, :type => DataType::Hash, :default => {}

    #Delete these eventually
    # attribute :mind_shield, :type => DataType::Integer, :default => 0
    # attribute :endure_fire, :type => DataType::Integer, :default => 0
    # attribute :endure_cold, :type => DataType::Integer, :default => 0

    before_delete :clear_magic

    def clear_magic
      self.magic_shields.each { |s| s.delete }
      self.spells_learned.each { |s| s.delete }
    end

    def major_schools
      self.schools.select { |k, v| v == "Major"}.keys
    end

    def minor_schools
      self.schools.select { |k, v| v == "Minor"}.keys
    end

    def auto_revive?
      auto_revive_spell = self.spells_learned.to_a.select { |spell| spell.learning_complete && Global.read_config("spells", spell.name, "auto_revive")}
      return auto_revive_spell[0].name  if !auto_revive_spell.empty?
    end

    def highest_major_school_rating
      num = 0
      self.major_schools.each do |s|
        rating = FS3Skills.ability_rating(self, s)
        num = rating if rating > num
      end
      return num
    end

    def total_magic_energy
      major_school_energy = self.highest_major_school_rating
      magic_attribute = Global.read_config("magic", "magic_attribute")
      magic_energy = FS3Skills.ability_rating(self, magic_attribute)
      return (major_school_energy + magic_energy) * 10
    end

    def magic_energy_rate
      major_school_energy = self.highest_major_school_rating
      magic_attribute = Global.read_config("magic", "magic_attribute")
      magic_energy = FS3Skills.ability_rating(self, magic_attribute)
      puts "Magic energy #{magic_energy}"
      return major_school_energy + magic_energy
    end

  end
end
