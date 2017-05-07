---
toc: Configuring FS3 Combat
summary: Configuring FS3 Combat weapons.
---
# Configuring FS3 Combat - Weapons

> **Permission Required:** Configuring the game requires the Admin role.

To configure the FS3 Weapons List:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat_weapons.yml`

## Before You Start

Consider whether you really want to make up different models of weapons (M16 Assault Rifle, AK47 Assault Rifle, etc.) or just lump everything into a generic category (Assault Rifle). It can be tedious creating all the statistics, and having too many weapons to pick from can either be overwhelming or cool depending on your player base.

## Weapon Types

FS3 lets you set up as many weapon types as you want.  FS3 weapons have the following stats, explained below:

        Rifle:
            description: "Assault Rifle"
            skill: Firearms
            lethality: 0
            penetration: 4
            weapon_type: Ranged
            is_automatic: true
            ammo: 20
            recoil: 1
            damage_type: Physical
            accuracy: 0
            has_shrapnel: false
            allowed_specials: 
                - 'Ap'
                - 'Scope'

### Dscription

The description is just a free-form text field describing the weapon.  For best results, use double quotes around it.

### Skill

The weapon's skill is used for attack rolls.

### Lethality

Lethality modifier provides a bonus (or penalty, if negative) to weapon damage.  Lethality is a percentage, so a 20 means that it's 20% more likely to do a serious wound.

> **Tip:** For reference, a 30 lethality is what applies to critical hit locations, so that's a big modifier.  Anything close to 50 is almost guaranteed to impair/incapacitate.

### Penetration

Penetration determines the weapon's chance of getting through armor.  You need to carefully balance the penetration values of your weapons and the protection values of your armor.  See [Configuring Armor](/help/fs3combat/config_armor) for more information.

### Weapon Type

Weapons are classified as either Explosive, Ranged, Melee or Suppressive.  The type determines what combat actions are available and how defense works.

* If **both** attacker and defender have melee weapons, the defender uses their weapon's skill instead of a regular defense roll.  In other words, if it's Knife vs. Sword, the swordsman will defend with his swords skill.
* Only explosive weapons can use the `combat/explode` action.
* Suppressive weapons cannot attack; they can only use the `combat/suppress` action.  This is suitable for things like ECM jamming, or smoke/flashbang grenades.

> **Tip** Even though anti-vehicle missiles technically "explode", they are designed more for armor piercing capability than hitting multiple targets or creating shrapnel.  The 'Ranged' type probably fits better for them.

### Automatic Fire

Automatic weapons (marked with `is_automatic: true`) are allowed to use the `combat/fullauto` command and the `burst` attack option.  

There is no way to specify a weapon that can do bursts but not full-auto fire.  You'll just have to handle that in RP.

### Ammo

For ranged weapons, the ammo value specifies the number of times it can fire before the attacker has to reload.

If a weapon does not need to reload, just comment out or remove its ammo value.

### Recoil

For automatic weapons, recoil is a penalty applied to each shot after the first when doing burst or full-auto fire.

For example:  LMG has a recoil value of 2.  Marcus is shooting a 3-round burst and his skill+attribute gives him 8 dice.  On the first shot, he will roll all 8 dice.  On the second shot, he will only have 6 (8 - recoil).  On the third shot, he will only have 4 (8 - (2 x recoil)).

### Damage Type

A weapon can do either Physical or Stun damage.  Stun damage is intended for bruises or shock weapons, and heals significantly faster than Physical damage.

### Accuracy

The weapon's accuracy value gives the attacker a bonus (or penalty, if accuracy is negative) to their attack roll.  

> **Tip:** Even a +/-1 can make an impact.  You probably don't want to go beyond +/-3.

### Shrapnel

You can control whether an explosive weapon does additional shrapnel damage.  Anti-vehicle weapons typically do not generate shrapnel.

### Specials

You can configure which weapon "specials" are available.  Specials are described in the next section.


## Weapon Specials

In addition to specifying the base weapon types, you can define "specials", which are accessories or different configurations that can augment a weapon's capabilities.   Some examples of weapon specials include:

* Armor-piercing bullets
* Sparring gear
* Machinegun bipods

Specials can provide a bonus or penalty (if the value is negative) to lethality, penetration, ammo, recoil or accuracy.  The special's value is simply added to/subtracted from the weapon's base stat.

For example, a machinegun bipod with recoil -2 would reduce a weapon's recoil stat by 2.

    Bipod:
        recoi: -2

Sparring gear reduces the lethality, since people are wearing protective equipment and not trying to hurt each other:

    Sparring:
        lethality: -50

You can have multiple specials attached to a weapon at one time.