module "Core.Context.DB", package.seeall
export CreatureTemplate

class CreatureTemplate extends Core.Common.DatabaseObject
    new: (id) =>
        super id
        @table_name = "creature_template"

        @fields = {
            difficulty_entry_1: 0
            difficulty_entry_2: 0
            difficulty_entry_3: 0
            KillCredit1: 0
            KillCredit2: 0
            modelid1: 0
            modelid2: 0
            modelid3: 0
            modelid4: 0
            name: "Forge Creature #{id}"
            subname: ""
            IconName: ""
            gossip_menu_id: 0
            minlevel: 1
            maxlevel: 1
            exp: 0
            faction: 35
            npcflag: 0
            speed_walk: 1
            speed_run: 1.14
            scale: 1
            rank: 0
            dmgschool: 0
            BaseAttackTime: 0
            RangeAttackTime: 0
            BaseVariance: 1
            RangeVariance: 1
            unit_class: 0
            unit_flags: 0
            unit_flags2: 0
            dynamicflags: 0
            family: 0
            type: 0
            type_flags: 0
            lootid: 0
            pickpocketloot: 0
            skinloot: 0
            PetSpellDataId: 0
            VehicleId: 0
            mingold: 0
            maxgold: 0
            AIName: ''
            MovementType: 0
            HoverHeight: 1
            HealthModifier: 1
            ManaModifier: 1
            ArmorModifier: 1
            DamageModifier: 1
            ExperienceModifier: 1
            RacialLeader: 0
            movementID: 0
            RegenHealth: 1
            mechanic_immune_mask: 0
            spell_school_immune_mask: 0
            flags_extra: 0
            ScriptName: ''
            VerifiedBuild: 0
        }

    SetDifficultyEntry: (id, entry) =>
        if id > 0 and id < 4
            @Set "difficulty_entry_#{id}", entry
        return @
    
    SetKillCredit: (id, entry) =>
        if id > 0 and id < 3
            @Set "KillCredit#{id}", entry
        return @
    
    SetName: (name) =>
        @Set "name", name
        return @

    SetSubname: (subname) =>
        @Set "subname", subname
        return @
    
    SetIconname: (icon_name) =>
        @Set "IconName", icon_name
        return @

    SetGossipMenuId: (gossip_menu_id) =>
        @Set "gossip_menu_id", gossip_menu_id
        return @

    SetLevel: (minlevel, maxlevel) =>
        @Set "minlevel", minlevel
        @Set "maxlevel", maxlevel or minlevel
        return @

    SetExp: (exp) =>
        @Set "exp", exp
        return @

    SetFaction: (faction) =>
        @Set "faction", faction
        return @

    SetNpcFlag: (flag) =>
        @Set "npcflag", flag
        return @

    SetSpeedWalk: (speed_walk) =>
        @Set "speed_walk", speed_walk
        return @
    
    SetSpeedRun: (speed_run) =>
        @Set "speed_run", speed_run
        return @

    SetSpeed: (speed_type, speed_value) =>
        switch speed_type
            when CT_SPEED_TYPE.WALK
                @SetSpeedWalk speed_value
            when CT_SPEED_TYPE.RUN
                @SetSpeedRun speed_value
        return @

    SetScale: (scale) =>
        @Set "scale", scale
        return @

    SetRank: (rank) =>
        @Set "rank", rank
        return @

    SetDmgSchool: (dmg_school) =>
        @Set "dmgschool", dmg_school
        return @

    SetBaseAttackTime: (base_attack_time) =>
        @Set "BaseAttackTime", base_attack_time
        return @

    SetRangeAttackTime: (range_attack_time) =>
        @Set "RangeAttackTime", range_attack_time
        return @

    SetBaseVariance: (base_variance) =>
        @Set "BaseVariance", base_variance
        return @

    SetRangeVariance: (range_variance) =>
        @Set "RangeVariance", range_variance
        return @

    SetUnitClass: (unit_class) =>
        @Set "unit_class", unit_class
        return @

    SetUnitFlags: (unit_flags) =>
        @Set "unit_flags", unit_flags
        return @

    SetUnitFlags2: (unit_flags2) =>
        @Set "unit_flags2", unit_flags2
        return @

    SetDynamicFlags: (dynamic_flags) =>
        @Set "dynamicflags", dynamic_flags
        return @

    SetFamily: (family) =>
        @Set "family", family
        return @