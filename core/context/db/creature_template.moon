module "Core.Context.DB", package.seeall
export CreatureTemplate

class CreatureTemplate extends Core.Common.DatabaseObject
    new: (id) =>
        @table_name = "creature_template"

        @fields = {
            entry:                     { default: 0,           value: id                                                   }
            KillCredit1:               { default: 0,           value: nil                                                  }
            KillCredit2:               { default: 0,           value: nil                                                  }
            modelid1:                  { default: 0,           value: nil                                                  }
            modelid2:                  { default: 0,           value: nil                                                  }
            modelid3:                  { default: 4,           value: nil                                                  }
            name:                      { default: 0,           value: nil                                                  }
            subname:                   { default: "'(NULL)'",  value: nil,             override: "SubName"                 }
            IconName:                  { default: "'(NULL)'",  value: nil                                                  }
            gossip_menu_id:            { default: 0,           value: nil,             override: "GossipMenuId"            }
            minlevel:                  { default: 1,           value: nil,             override: "MinLevel"                }
            maxlevel:                  { default: 1,           value: nil,             override: "MaxLevel"                }
            exp:                       { default: 0,           value: nil                                                  }
            faction:                   { default: 0,           value: nil                                                  }
            npcflag:                   { default: 0,           value: nil,             override: "NpcFlag"                 }
            speed_walk:                { default: 1,           value: nil,             override: "SpeedWalk"               }
            speed_run:                 { default: 1.14286,     value: nil,             override: "SpeedRun"                }
            scale:                     { default: 1,           value: nil                                                  }
            rank:                      { default: 0,           value: nil                                                  }
            dmgschool:                 { default: 0,           value: nil,             override: "DmgSchool"               }
            BaseAttackTime:            { default: 0,           value: nil                                                  }
            RangeAttackTime:           { default: 0,           value: nil                                                  }
            BaseVariance:              { default: 1,           value: nil                                                  }
            RangeVariance:             { default: 1,           value: nil                                                  }
            unit_class:                { default: 0,           value: nil,             override: "UnitClass"               }
            unit_flags:                { default: 0,           value: nil,             override: "UnitFlags"               }
            unit_flags2:               { default: 0,           value: nil,             override: "UnitFlags2"              }
            dynamicflags:              { default: 0,           value: nil,             override: "Dynamicflags"            }
            family:                    { default: 0,           value: nil                                                  }
            type:                      { default: 0,           value: nil                                                  }
            type_flags:                { default: 0,           value: nil,             override: "TypeFlags"               }
            lootid:                    { default: 0,           value: nil                                                  }
            pickpocketloot:            { default: 0,           value: nil,             override: "PickPocketLoot"          }
            skinloot:                  { default: 0,           value: nil,             override: "SkinLoot"                }
            PetSpellDataId:            { default: 0,           value: nil                                                  }
            VehicleId:                 { default: 0,           value: nil                                                  }
            mingold:                   { default: 0,           value: nil,             override: "MinGold"                 }
            maxgold:                   { default: 0,           value: nil,             override: "MaxGold"                 }
            AIName:                    { default: "",          value: nil                                                  }
            MovementType:              { default: 0,           value: nil                                                  }
            HoverHeight:               { default: 1,           value: nil                                                  }
            HealthModifier:            { default: 1,           value: nil                                                  }
            ManaModifier:              { default: 1,           value: nil                                                  }
            ArmorModifier:             { default: 1,           value: nil                                                  }
            DamageModifier:            { default: 1,           value: nil                                                  }
            ExperienceModifier:        { default: 1,           value: nil                                                  }
            RacialLeader:              { default: 0,           value: nil                                                  }
            movementID:                { default: 0,           value: nil                                                  }
            RegenHealth:               { default: 1,           value: nil                                                  }
            mechanic_immune_mask:      { default: 0,           value: nil,             override: "MechanicImmuneMask"      }
            spell_school_immune_mask:  { default: 0,           value: nil,             override: "SpellSchoolImmuneMask"   }
            flags_extra:               { default: 0,           value: nil,             override: "FlagsExtra"              }
            ScriptName:                { default: "",          value: nil                                                  }
            VerifiedBuild:             { default: 0,           value: nil                                                  }
        }

        for column_name, column_data in pairs(@fields)
            name = column_data.override or column_name

            @["Get#{name\gsub("^%l", string.upper)}"] = ->
                return @fields[column_name].value or @fields[column_name].default

            @["Set#{name\gsub("^%l", string.upper)}"] = (self, value) -> 
                @fields[column_name].value = value
                return @

    SetDifficultyEntry: (id, entry) =>
        if id > 0 and id < 4
            @Set "difficulty_entry_#{id}", entry
        return @
    
    SetKillCredit: (id, entry) =>
        if id > 0 and id < 3
            @Set "KillCredit#{id}", entry
        return @

    SetLevel: (minlevel, maxlevel) =>
        @Set "minlevel", minlevel
        @Set "maxlevel", maxlevel or minlevel
        return @

    SetSpeed: (speed_type, speed_value) =>
        switch speed_type
            when CT_SPEED_TYPE.WALK
                @SetSpeedWalk speed_value
            when CT_SPEED_TYPE.RUN
                @SetSpeedRun speed_value
        return @