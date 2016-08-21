module AresMUSH
  class Character
    field :temp_link_codes, :type => Hash, :default => {}
    field :profile, :type => Hash, :default => {}
  end
end