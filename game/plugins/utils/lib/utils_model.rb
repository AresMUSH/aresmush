module AresMUSH
  class Character
    field :edit_prefix, :type => String, :default => "FugueEdit >"
    field :saved_text, :type => Array, :default => []
  end
end