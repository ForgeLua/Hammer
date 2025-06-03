module "Core.Contexts.DB", package.seeall
export CreatureTemplate

firstToUpper = (str) ->
    return (str\gsub("^%l", string.upper))

class CreatureTemplate extends Core.Common.MySQLQuery
    @_table: "creature_template"

    @entry:                     { default: 0,           value: nil                                                  }
    @KillCredit1:               { default: 0,           value: nil                                                  }
    @KillCredit2:               { default: 0,           value: nil                                                  }
    @modelid1:                  { default: 0,           value: nil                                                  }
    @modelid2:                  { default: 0,           value: nil                                                  }
    @modelid3:                  { default: 4,           value: nil                                                  }
    @entry:                     { default: 0,           value: nil                                                  }
    @name:                      { default: 0,           value: nil                                                  }
    @subname:                   { default: "(NULL)",    value: nil,             override: "SubName"                 }
    @IconName:                  { default: "(NULL)",    value: nil                                                  }
    @gossip_menu_id:            { default: 0,           value: nil,             override: "GossipMenuId"            }
    @minlevel:                  { default: 1,           value: nil,             override: "MinLevel"                }
    @maxlevel:                  { default: 1,           value: nil,             override: "MaxLevel"                }
    @exp:                       { default: 0,           value: nil                                                  }
    @faction:                   { default: 0,           value: nil                                                  }
    @npcflag:                   { default: 0,           value: nil,             override: "NpcFlag"                 }
    @speed_walk:                { default: 1,           value: nil,             override: "SpeedWalk"               }
    @speed_run:                 { default: 1.14286,     value: nil,             override: "SpeedRun"                }
    @scale:                     { default: 1,           value: nil                                                  }
    @rank:                      { default: 0,           value: nil                                                  }
    @dmgschool:                 { default: 0,           value: nil,             override: "DmgSchool"               }
    @BaseAttackTime:            { default: 0,           value: nil                                                  }
    @RangeAttackTime:           { default: 0,           value: nil                                                  }
    @BaseVariance:              { default: 1,           value: nil                                                  }
    @RangeVariance:             { default: 1,           value: nil                                                  }
    @unit_class:                { default: 0,           value: nil,             override: "UnitClass"               }
    @unit_flags:                { default: 0,           value: nil,             override: "UnitFlags"               }
    @unit_flags2:               { default: 0,           value: nil,             override: "UnitFlags2"              }
    @dynamicflags:              { default: 0,           value: nil,             override: "Dynamicflags"            }
    @family:                    { default: 0,           value: nil                                                  }
    @type:                      { default: 0,           value: nil                                                  }
    @type_flags:                { default: 0,           value: nil,             override: "TypeFlags"               }
    @lootid:                    { default: 0,           value: nil                                                  }
    @pickpocketloot:            { default: 0,           value: nil,             override: "PickPocketLoot"          }
    @skinloot:                  { default: 0,           value: nil,             override: "SkinLoot"                }
    @PetSpellDataId:            { default: 0,           value: nil                                                  }
    @VehicleId:                 { default: 0,           value: nil                                                  }
    @mingold:                   { default: 0,           value: nil,             override: "MinGold"                 }
    @maxgold:                   { default: 0,           value: nil,             override: "MaxGold"                 }
    @AIName:                    { default: "",          value: nil                                                  }
    @MovementType:              { default: 0,           value: nil                                                  }
    @HoverHeight:               { default: 1,           value: nil                                                  }
    @HealthModifier:            { default: 1,           value: nil                                                  }
    @ManaModifier:              { default: 1,           value: nil                                                  }
    @ArmorModifier:             { default: 1,           value: nil                                                  }
    @DamageModifier:            { default: 1,           value: nil                                                  }
    @ExperienceModifier:        { default: 1,           value: nil                                                  }
    @RacialLeader:              { default: 0,           value: nil                                                  }
    @movementID:                { default: 0,           value: nil                                                  }
    @RegenHealth:               { default: 1,           value: nil                                                  }
    @mechanic_immune_mask:      { default: 0,           value: nil,             override: "MechanicImmuneMask"      }
    @spell_school_immune_mask:  { default: 0,           value: nil,             override: "SpellSchoolImmuneMask"   }
    @flags_extra:               { default: 0,           value: nil,             override: "FlagsExtra"              }
    @ScriptName:                { default: "",          value: nil                                                  }
    @VerifiedBuild:             { default: 0,           value: nil                                                  }
    
    new: =>
        for column_name, column_data in pairs(@@)
            if (column_name != "__name" and column_name != "__base" and column_name != "__init" and column_name != "_table")
                name = column_data.override or column_name
                @[column_name] = column_data

                getter_name = "Get#{firstToUpper(name)}"
                @[column_name]._getter = getter_name
                @[getter_name] = -> 
                    return @[column_name].value or @[column_name].default

                @["Set#{firstToUpper(name)}"] = (self, value) -> 
                    @[column_name].value = value
                    return @