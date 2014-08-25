module AresMUSH
  class Character
    field :last_paged, :type => Array, :default => []
    field :do_not_disturb, :type => Boolean
  end
end