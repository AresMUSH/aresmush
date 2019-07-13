module AresMUSH
  module LearnableSpell
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :register_data_members
    end
    module ClassMethods
      def register_data_members
        attribute :last_learned, :type => Ohm::DataTypes::DataType::Time, :default => Time.now
        attribute :xp, :type => Ohm::DataTypes::DataType::Integer, :default => 0
      end
    end

    def can_learn?
      self.time_to_next_learn <= 0
    end

    def time_to_next_learn
      return 0 if !self.last_learned
      time_left = (FS3Skills.days_between_learning * 86400) - (Time.now - self.last_learned)
      [time_left, 0].max
    end
  end
end
