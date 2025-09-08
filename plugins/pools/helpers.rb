module AresMUSH
  module Pools
    def self.can_manage_pools?(actor)
      actor && actor.has_permission?("manage_pools")
    end
    
    def self.modify_pool(char, amount)
      max_pool = Global.read_config("pools", "max_pool")
      min_pool = Global.read_config("pools", "min_pool")
      pool = char.pool + amount
      pool = [max_pool, pool].min
      pool = [min_pool, pool].max
      char.update(pools_pool: pool)
    end

    def self.set_pool(char, value)
      max_pool = Global.read_config("pools", "max_pool")
      min_pool = Global.read_config("pools", "min_pool")
      pool = value
      pool = [max_pool, pool].min
      pool = [min_pool, pool].max
      char.update(pools_pool: pool)
    end      

    def self.pool_char_max(char)
      pool_mult = Global.read_config("pools", "pool_multiplier")
      pool_stat = Global.read_config("pools", "pool_ability")
      current_rating = FS3Skills.ability_rating(char, pool_stat)
      pool_max_value = current_rating * pool_mult

      return pool_max_value
    end

    def self.pool_set(char, enactor_name, amount, reason, room)
      char.set_pool(amount)
      Global.logger.info "Pool Points set to #{amount} by #{enactor_name} to #{char} for #{reason}"
      pool_name =  Global.read_config("pools", "pool_name_plural")
      message = t('pools.pool_set', :name => char.name, :pool => amount, :reason => reason, :pool_name => pool_name)
     
      if (room.scene)
        room.emit_ooc message
        Scenes.add_to_scene(room.scene, message)
      else
        room.emit_ooc message
      end
    end

    def self.pool_spend(char, amount, reason, room)
       char.spend_pool(amount.to_i)
       current_pool = char.pools_pool
       pool_max = Pools.pool_char_max(char)
       pool_name =  Global.read_config("pools", "pool_name")
       message = t('pools.pool_spent', :name => char.name, :pool => amount, :total => current_pool, :pool_max => pool_max, :reason => reason, :pool_name => pool_name)
         
       if (room.scene)
          room.emit_ooc message
          Scenes.add_to_scene(room.scene, message)
       else
          room.emit_ooc message
       end
   end

   def self.pool_add(char, amount, reason, room)
       char.add_pool(amount.to_i)
       current_pool = char.pools_pool
       pool_name =  Global.read_config("pools", "pool_name")
       pool_max = Pools.pool_char_max(char)
       message = t('pools.pool_added', :name => char.name, :pool => amount, :total => current_pool, :pool_max => pool_max, :reason => reason, :pool_name => pool_name)
         
       if (room.scene)
          room.emit_ooc message
          Scenes.add_to_scene(room.scene, message)
       else
        room.emit_ooc message
       end
   end

   def self.pool_desperate(char, enactor, room)
          pool_amount = char.pools_pool
          pool_max = Pools.pool_char_max(char)
          desperate = Global.read_config("pools", "desperate_amount")
          new_pool_amount = pool_amount - desperate
          if new_pool_amount >= 1
            new_pool_amount = 0
          end
          char.set_pool(new_pool_amount)
          pool_name =  Global.read_config("pools", "pool_name")
          pool_name_plural =  Global.read_config("pools", "pool_name_plural")
          
          message = t('pools.pool_desperate', :name => char.name, :amount => desperate, :pool_max => pool_max, :pool => new_pool_amount, :pool_name => pool_name, :pool_name_plural => pool_name_plural)
       if (room.scene)
          room.emit_ooc message
          Scenes.add_to_scene(room.scene, message)
       else
          room.emit_ooc message
       end
   end

   def self.pool_reset(char, enactor, room)
          pool_name =  Global.read_config("pools", "pool_name_plural")
          pool_value = Pools.pool_char_max(char)
          char.set_pool(pool_value)
          
          message = t('pools.pool_reset', :name => char.name, :pool => pool_value, :pool_name => pool_name)
       if (room.scene)
          room.emit_ooc message
          Scenes.add_to_scene(room.scene, message)
       else
          room.emit_ooc message
       end
   end

   def self.show_pool(char, enactor_name, room)
        pool_name =  Global.read_config("pools", "pool_name")
        pool_name_plural =  Global.read_config("pools", "pool_name_plural")
        pool_max = Pools.pool_char_max(char)
        message = t('pools.show_pool', :enactor => enactor_name, :name => char.name, :pool => char.pool, :pool_max => pool_max, :pool_name => pool_name, :pool_name_plural => pool_name_plural)

        if (room.scene)
          room.emit_ooc message
          Scenes.add_to_scene(room.scene, message)
        else
          room.emit_ooc message
        end
    end
  end
end
