module AresMUSH
  module LearnableStat
    def on_success(c,a)
      ability_type = SuperConsole.get_ability_type(a)
      ability = SuperConsole.find_ability(c,a)
      learn_pool = ability.learnpoints
      new = learn_pool + 1
      max = 100
      rating = ability.rating
      new_rating = rating + 1
     if new_rating == 1
       if new == 100
         ability.update(learnpoints: 0)
         ability.update(rating: new_rating)
         ability.update(acquired: char.level)
       elsif new > 100
         ability.update(learnpoints: (new - max))
         ability.update(rating: new_rating)
         ability.update(acquired: char.level)
       end
     elsif new_rating < 5
        if new == 100
          ability.update(learnpoints: 0)
          ability.update(rating: new_rating)
        elsif new > 100
          ability.update(learnpoints: (new - max))
          ability.update(rating: new_rating)
        end
      elsif new_rating == 5
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
      max = 100
      rating = ability.rating
      new_rating = rating + 1
     if new_rating == 1
       if new == 100
         ability.update(learnpoints: 0)
         ability.update(rating: new_rating)
         ability.update(acquired: char.level)
       elsif new > 100
         ability.update(learnpoints: (new - max))
         ability.update(rating: new_rating)
         ability.update(acquired: char.level)
       end
     elsif new_rating < 5
        if new == 100
          ability.update(learnpoints: 0)
          ability.update(rating: new_rating)
        elsif new > 100
          ability.update(learnpoints: (new - max))
          ability.update(rating: new_rating)
        end
      elsif new_rating == 5
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
      max = 100
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
      max = 100
       if new < 0
         ability.update(learnpoints: 0)
       else
         ability.update(learnpoints: new)
       end
    end
  end
end
