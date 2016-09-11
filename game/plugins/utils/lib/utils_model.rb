module AresMUSH
  class Character
    field :autospace, :type => String, :default => "%r"
    field :edit_prefix, :type => String, :default => "FugueEdit >"
    field :saved_text, :type => Array, :default => []
  end
end