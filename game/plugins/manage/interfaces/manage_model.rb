module AresMUSH
  class Character
    field :last_ip, :type => String, :default => ""
    field :last_hostname, :type => String, :default => ""
    field :last_on, :type => Time
  end
end
