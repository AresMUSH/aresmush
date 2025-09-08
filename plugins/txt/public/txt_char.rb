module AresMUSH
    class Character
        attribute :txt_last, :type => DataType::Array, :default => []
        attribute :txt_last_scene, :type => DataType::Array, :default => []
        attribute :txt_received
        attribute :txt_received_scene
        attribute :txt_color
        attribute :txt_scene
    end
  end