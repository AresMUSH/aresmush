module AresMUSH
  module LearnableMagix
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :register_data_members
    end
    module ClassMethods
      def register_data_members
        attribute :fs3_last_magix, :type => Ohm::DataTypes::DataType::Time, :default => Time.now
        attribute :fs3_xp, :type => Ohm::DataTypes::DataType::Integer, :default => 0
      end
    end

    def learn
      update(fs3_last_magix: Time.now)
      update(fs3_xp: self.xp + 1)
    end

    def xp_needed
      FS3Skills.xp_needed(self.name, self.rating)
    end

    def learning_complete
      self.xp >= self.xp_needed
    end

    def can_learn?
      self.time_to_next_learn <= 0
    end

    def time_to_next_learn
      return 0 if !self.fs3_last_magix
      time_left = (FS3Magix.days_between_learning * 86400) - (Time.now - self.fs3_last_magix)
      [time_left, 0].max
    end
  end
end
