module AresMUSH
  class Character
    field :channel_options, :type => Hash, :default => {}
    has_and_belongs_to_many :channels
  end
  
  class Channel
    
    include ObjectModel
    
    field :color, :type => String, :default => "%xh"
    field :description, :type => String
    field :announce, :type => Boolean, :default => true
    field :roles, :type => Array, :default => []
    
    has_and_belongs_to_many :characters
    
    def display_name(include_markers = true)
      display = "#{self.color}#{self.name}%xn"
      include_markers ? Channels.name_with_markers(display) : display
    end
    
    def emit(msg)
      characters.each do |c|
        if (!Channels.is_gagging?(c, self))
          client = Global.client_monitor.find_client(c)
          if (!client.nil?)
            client.emit "#{display_name} #{msg}"
          end
        end
      end
    end
    
    def pose(name, msg)
      emit PoseFormatter.format(name, msg)
    end
  end
end
