module AresMUSH
  class Character
    field :fs3_aptitudes, :type => Hash, :default => {}
    field :fs3_action_skills, :type => Hash, :default => {}
    field :fs3_advantages, :type => Hash, :default => {}
    field :fs3_interests, :type => Array, :default => []
    field :fs3_expertise, :type => Array, :default => []
    field :fs3_languages, :type => Array, :default => []
    field :fs3_linked_attrs, :type => Hash, :default => {}

    field :hooks, :type => Hash, :default => {}
    field :goals, :type => Hash, :default => {}
  end
end