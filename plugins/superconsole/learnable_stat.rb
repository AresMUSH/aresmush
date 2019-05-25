module AresMUSH
  module SuperConsole
   module LearnableStat

    def self.get_max_learn(c,a)
      type = SuperConsole.get_ability_type(a)
      ability = SuperConsole.get_max_default_learn(c,a)
      ability
    end


    def on_success(c,a)
      ability_type = SuperConsole.get_ability_type(a)
      ability = SuperConsole.find_ability(c,a)
      learn_pool = ability.learnpoints
      new = learn_pool + 1
      max = SuperConsole.get_max_learn(c,a)
      rating = ability.rating
      max_rating = SuperConsole.get_max_rating(c,a)
      new_rating = rating + 1
     if new_rating == 1
       if new == max
         ability.update(learnpoints: 0)
         ability.update(rating: new_rating)
       elsif new > max
         ability.update(learnpoints: (new - max))
         ability.update(rating: new_rating)
       end
     elsif new_rating < max_rating
        if new == max
          ability.update(learnpoints: 0)
          ability.update(rating: new_rating)
        elsif new > max
          ability.update(learnpoints: (new - max))
          ability.update(rating: new_rating)
        end
      elsif new_rating == max_rating
        ability.update(learnpoints: 0)
        ability.update(rating: new_rating)
        ability.update(learnable: false)
      end
    end
    def on_critical_success(c,a)
      ability_type = SuperConsole.get_ability_type(a)
      ability = SuperConsole.find_ability(c,a)
      learn_pool = ability.learnpoints
      new = learn_pool + 5
      max = SuperConsole.get_max_learn(c,a)
      rating = ability.rating
      max_rating = SuperConsole.get_max_rating(c,a)
      new_rating = rating + 1
     if new_rating == 1
       if new == max
         ability.update(learnpoints: 0)
         ability.update(rating: new_rating)
       elsif new > max
         ability.update(learnpoints: (new - max))
         ability.update(rating: new_rating)
       end
     elsif new_rating < 5
        if new == max
          ability.update(learnpoints: 0)
          ability.update(rating: new_rating)
        elsif new > max
          ability.update(learnpoints: (new - max))
          ability.update(rating: new_rating)
        end
      elsif new_rating == max_rating
        ability.update(learnpoints: 0)
        ability.update(rating: new_rating)
        ability.update(learnable: false)
      end
    end
    def on_failure(c,a)
      ability_type = SuperConsole.get_ability_type(a)
      ability = SuperConsole.find_ability(c,a)
      learn_pool = ability.learnpoints
      new = learn_pool - 1
      max = SuperConsole.get_max_learn(c,a)
       if new < 0
         ability.update(learnpoints: 0)
       else
         ability.update(learnpoints: new)
       end
    end
    def on_critical_failure(c,a)
      ability_type = SuperConsole.get_ability_type(a)
      ability = SuperConsole.find_ability(c,a)
      learn_pool = ability.learnpoints
      new = learn_pool - 5
      max = SuperConsole.get_max_learn(c,a)
       if new < 0
         ability.update(learnpoints: 0)
       else
         ability.update(learnpoints: new)
       end
    end
  end
 end
end
