module AresMUSH
  class Character
    attribute :secrets
    attribute :gmsecrets
    attribute :secret_summary
    attribute :secret_name
    attribute :secret_plot, :type => DataType::Integer
    attribute :secretpref, :default => "None"
  end
end
