module AresMUSH
  class Game
    attribute :login_activity, :type => DataType::Hash, :default => {}
    attribute :login_activity_samples, :type => DataType::Integer
    attribute :login_motd
  end
end