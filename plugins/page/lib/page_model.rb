module AresMUSH
  class Character
    attribute :last_paged, :type => DataType::Array, :default => []
    attribute :page_do_not_disturb, :type => DataType::Boolean
    attribute :page_autospace, :default => "%r"
    attribute :page_color, :default => "%xc"
    set :page_ignored, "AresMUSH::Character"
  end
end