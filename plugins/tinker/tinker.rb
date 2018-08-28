$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Tinker
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    attr_accessor :name, :target, :spell, :spell_list, :caster

    def handle
      self.spell_list = Global.read_config("spells")
      if (cmd.args =~ /\//)
        #Forcing NPC or PC to cast
        args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
        combat = enactor.combat
        caster_name = titlecase_arg(args.arg1)
        self.spell = titlecase_arg(args.arg2)
        target_name = titlecase_arg(args.arg3)
        self.caster = combat.find_combatant(caster_name)
        self.target = combat.find_combatant(target_name)
      else
        args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>.+)?/)
        self.caster = enactor.combatant
        self.spell = titlecase_arg(args.arg1)
        target_name = titlecase_arg(args.arg2)
        self.target = FS3Combat.find_named_thing(target_name, self.caster)
      end
      client.emit self.caster.name
      client.emit self.spell
      client.emit self.target.name
    end


    end
  end
end
