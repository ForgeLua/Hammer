module("Core.Context.DB", package.seeall)
do
  local _class_0
  local _parent_0 = Core.Common.DatabaseObject
  local _base_0 = {
    SetDifficultyEntry = function(self, id, entry)
      if id > 0 and id < 4 then
        self["SetDifficultyEntry" .. tostring(id)](self, entry)
      end
      return self
    end,
    SetModelId = function(self, id, model)
      if id > 0 and id < 5 then
        self["SetModelId" .. tostring(id)](self, model)
      end
      return self
    end,
    SetKillCredit = function(self, id, entry)
      if id > 0 and id < 3 then
        self["SetKillCredit" .. tostring(id)](self, entry)
      end
      return self
    end,
    SetLevel = function(self, minlevel, maxlevel)
      self:SetMinLevel(minlevel)
      self:SetMaxLevel(maxlevel or minlevel)
      return self
    end,
    SetSpeed = function(self, speed_type, speed_value)
      local _exp_0 = speed_type
      if CT_SPEED_TYPE.WALK == _exp_0 then
        self:SetSpeedWalk(speed_value)
      elseif CT_SPEED_TYPE.RUN == _exp_0 then
        self:SetSpeedRun(speed_value)
      end
      return self
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, id)
      self.table_name = "creature_template"
      self.fields = {
        entry = {
          default = 0,
          value = id
        },
        difficulty_entry_1 = {
          default = 0,
          value = nil,
          override = "DifficultyEntry1"
        },
        difficulty_entry_2 = {
          default = 0,
          value = nil,
          override = "DifficultyEntry2"
        },
        difficulty_entry_3 = {
          default = 0,
          value = nil,
          override = "DifficultyEntry3"
        },
        KillCredit1 = {
          default = 0,
          value = nil
        },
        KillCredit2 = {
          default = 0,
          value = nil
        },
        modelid1 = {
          default = 0,
          value = nil,
          override = "ModelId1"
        },
        modelid2 = {
          default = 0,
          value = nil,
          override = "ModelId2"
        },
        modelid3 = {
          default = 0,
          value = nil,
          override = "ModelId3"
        },
        modelid4 = {
          default = 0,
          value = nil,
          override = "ModelId4"
        },
        name = {
          default = 0,
          value = nil
        },
        subname = {
          default = "'(NULL)'",
          value = nil,
          override = "SubName"
        },
        IconName = {
          default = "'(NULL)'",
          value = nil
        },
        gossip_menu_id = {
          default = 0,
          value = nil,
          override = "GossipMenuId"
        },
        minlevel = {
          default = 1,
          value = nil,
          override = "MinLevel"
        },
        maxlevel = {
          default = 1,
          value = nil,
          override = "MaxLevel"
        },
        exp = {
          default = 0,
          value = nil
        },
        faction = {
          default = 0,
          value = nil
        },
        npcflag = {
          default = 0,
          value = nil,
          override = "NpcFlag"
        },
        speed_walk = {
          default = 1,
          value = nil,
          override = "SpeedWalk"
        },
        speed_run = {
          default = 1.14286,
          value = nil,
          override = "SpeedRun"
        },
        scale = {
          default = 1,
          value = nil
        },
        rank = {
          default = 0,
          value = nil
        },
        dmgschool = {
          default = 0,
          value = nil,
          override = "DmgSchool"
        },
        BaseAttackTime = {
          default = 0,
          value = nil
        },
        RangeAttackTime = {
          default = 0,
          value = nil
        },
        BaseVariance = {
          default = 1,
          value = nil
        },
        RangeVariance = {
          default = 1,
          value = nil
        },
        unit_class = {
          default = 0,
          value = nil,
          override = "UnitClass"
        },
        unit_flags = {
          default = 0,
          value = nil,
          override = "UnitFlags"
        },
        unit_flags2 = {
          default = 0,
          value = nil,
          override = "UnitFlags2"
        },
        dynamicflags = {
          default = 0,
          value = nil,
          override = "Dynamicflags"
        },
        family = {
          default = 0,
          value = nil
        },
        type = {
          default = 0,
          value = nil
        },
        type_flags = {
          default = 0,
          value = nil,
          override = "TypeFlags"
        },
        lootid = {
          default = 0,
          value = nil
        },
        pickpocketloot = {
          default = 0,
          value = nil,
          override = "PickPocketLoot"
        },
        skinloot = {
          default = 0,
          value = nil,
          override = "SkinLoot"
        },
        PetSpellDataId = {
          default = 0,
          value = nil
        },
        VehicleId = {
          default = 0,
          value = nil
        },
        mingold = {
          default = 0,
          value = nil,
          override = "MinGold"
        },
        maxgold = {
          default = 0,
          value = nil,
          override = "MaxGold"
        },
        AIName = {
          default = "",
          value = nil
        },
        MovementType = {
          default = 0,
          value = nil
        },
        HoverHeight = {
          default = 1,
          value = nil
        },
        HealthModifier = {
          default = 1,
          value = nil
        },
        ManaModifier = {
          default = 1,
          value = nil
        },
        ArmorModifier = {
          default = 1,
          value = nil
        },
        DamageModifier = {
          default = 1,
          value = nil
        },
        ExperienceModifier = {
          default = 1,
          value = nil
        },
        RacialLeader = {
          default = 0,
          value = nil
        },
        movementID = {
          default = 0,
          value = nil
        },
        RegenHealth = {
          default = 1,
          value = nil
        },
        mechanic_immune_mask = {
          default = 0,
          value = nil,
          override = "MechanicImmuneMask"
        },
        spell_school_immune_mask = {
          default = 0,
          value = nil,
          override = "SpellSchoolImmuneMask"
        },
        flags_extra = {
          default = 0,
          value = nil,
          override = "FlagsExtra"
        },
        ScriptName = {
          default = "",
          value = nil
        },
        VerifiedBuild = {
          default = 0,
          value = nil
        }
      }
      for column_name, column_data in pairs(self.fields) do
        local name = column_data.override or column_name
        self["Get" .. tostring(name:gsub("^%l", string.upper))] = function()
          return self:Get(column_name)
        end
        self["Set" .. tostring(name:gsub("^%l", string.upper))] = function(self, value)
          self:Set(column_name, value)
          return self
        end
      end
    end,
    __base = _base_0,
    __name = "CreatureTemplate",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  CreatureTemplate = _class_0
  return _class_0
end
