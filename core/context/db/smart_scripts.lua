module("Core.Context.DB", package.seeall)
do
  local _class_0
  local _parent_0 = Core.Common.DatabaseObject
  local _base_0 = {
    When = function(self, event_type, param1, param2, param3, param4, param5)
      if param1 == nil then
        param1 = 0
      end
      if param2 == nil then
        param2 = 0
      end
      if param3 == nil then
        param3 = 0
      end
      if param4 == nil then
        param4 = 0
      end
      if param5 == nil then
        param5 = 0
      end
      self:SetEventType(event_type)
      self:SetEventParam1(param1)
      self:SetEventParam2(param2)
      self:SetEventParam3(param3)
      self:SetEventParam4(param4)
      self:SetEventParam5(param5)
      return self
    end,
    Do = function(self, action_type, param1, param2, param3, param4, param5, param6)
      if param1 == nil then
        param1 = 0
      end
      if param2 == nil then
        param2 = 0
      end
      if param3 == nil then
        param3 = 0
      end
      if param4 == nil then
        param4 = 0
      end
      if param5 == nil then
        param5 = 0
      end
      if param6 == nil then
        param6 = 0
      end
      self:SetActionType(action_type)
      self:SetActionParam1(param1)
      self:SetActionParam2(param2)
      self:SetActionParam3(param3)
      self:SetActionParam4(param4)
      self:SetActionParam5(param5)
      self:SetActionParam6(param6)
      return self
    end,
    On = function(self, target_type, param1, param2, param3, param4, x, y, z, o)
      if param1 == nil then
        param1 = 0
      end
      if param2 == nil then
        param2 = 0
      end
      if param3 == nil then
        param3 = 0
      end
      if param4 == nil then
        param4 = 0
      end
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if z == nil then
        z = 0
      end
      if o == nil then
        o = 0
      end
      self:SetTargetType(target_type)
      self:SetTargetParam1(param1)
      self:SetTargetParam2(param2)
      self:SetTargetParam3(param3)
      self:SetTargetParam4(param4)
      self:SetTargetX(x)
      self:SetTargetY(y)
      self:SetTargetZ(z)
      self:SetTargetO(o)
      return self
    end,
    ResetEventActionTarget = function(self)
      for column_name, column_data in pairs(self.fields) do
        if (column_name ~= "link" and column_name ~= "id" and column_name ~= "entryorguid" and column_name ~= "source_type") then
          local name = column_data.override or column_name
          self["Set" .. tostring(name:gsub("^%l", string.upper))](self, column_data.default)
        end
      end
    end,
    NewEntry = function(self)
      if self.dirty then
        self:SaveCurrentEntry()
      end
      self.current_id = self.current_id + 1
      self:SetId(self.current_id)
      if (self:GetLink() ~= 0) then
        self:SetLink(0)
      end
      self:ResetEventActionTarget()
      return self
    end,
    SaveCurrentEntry = function(self)
      local entry = { }
      for field, data in pairs(self.fields) do
        entry[field] = data.value
      end
      table.insert(self.entries, entry)
      self.dirty = false
    end,
    BuildInsertQuery = function(self)
      if not (self.dirty or #self.entries > 0) then
        return false
      end
      if self.dirty then
        self:SaveCurrentEntry()
      end
      local queries = { }
      local _list_0 = self.entries
      for _index_0 = 1, #_list_0 do
        local entry = _list_0[_index_0]
        local fields = { }
        local values = { }
        for field, value in pairs(entry) do
          table.insert(fields, field)
          if type(value) == "string" then
            local escaped_value = value:gsub("'", "\\'")
            table.insert(values, "'" .. tostring(escaped_value) .. "'")
          else
            table.insert(values, tostring(value))
          end
        end
        local field_str = table.concat(fields, ", ")
        local value_str = table.concat(values, ", ")
        table.insert(queries, "INSERT INTO " .. tostring(self.table_name) .. " (" .. tostring(field_str) .. ") VALUES (" .. tostring(value_str) .. ")")
      end
      return queries
    end,
    Flush = function(self)
      local queries = self:BuildInsertQuery()
      if queries then
        for _index_0 = 1, #queries do
          local query = queries[_index_0]
          Core.Common.Database:AddQuery(query)
        end
        self.entries = { }
        self.dirty = false
        return Core.Common.Logger:Info("Flushed " .. tostring(#queries) .. " SmartScript entries for " .. tostring(self.id))
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, source_id, source_type)
      if source_type == nil then
        source_type = 0
      end
      self.table_name = "smart_scripts"
      self.source_type = source_type
      self.current_id = 0
      self.current_link = 0
      self.entries = { }
      self.current_entry = nil
      self.fields = {
        entryorguid = {
          default = 0,
          value = source_id,
          override = "EntryOrGuid"
        },
        source_type = {
          default = 0,
          value = nil,
          override = "SourceType"
        },
        id = {
          default = 0,
          value = 0
        },
        link = {
          default = 0,
          value = nil
        },
        event_type = {
          default = 0,
          value = nil,
          override = "EventType"
        },
        event_phase_mask = {
          default = 0,
          value = nil,
          override = "EventPhaseMask"
        },
        event_chance = {
          default = 0,
          value = nil,
          override = "EventChance"
        },
        event_flags = {
          default = 0,
          value = nil,
          override = "EventFlags"
        },
        event_param1 = {
          default = 0,
          value = nil,
          override = "EventParam1"
        },
        event_param2 = {
          default = 0,
          value = nil,
          override = "EventParam2"
        },
        event_param3 = {
          default = 0,
          value = nil,
          override = "EventParam3"
        },
        event_param4 = {
          default = 0,
          value = nil,
          override = "EventParam4"
        },
        event_param5 = {
          default = 0,
          value = nil,
          override = "EventParam5"
        },
        action_type = {
          default = 0,
          value = nil,
          override = "ActionType"
        },
        action_param1 = {
          default = 0,
          value = nil,
          override = "ActionParam1"
        },
        action_param2 = {
          default = 0,
          value = nil,
          override = "ActionParam2"
        },
        action_param3 = {
          default = 0,
          value = nil,
          override = "ActionParam3"
        },
        action_param4 = {
          default = 0,
          value = nil,
          override = "ActionParam4"
        },
        action_param5 = {
          default = 0,
          value = nil,
          override = "ActionParam5"
        },
        action_param6 = {
          default = 0,
          value = nil,
          override = "ActionParam6"
        },
        target_type = {
          default = 0,
          value = nil,
          override = "TargetType"
        },
        target_param1 = {
          default = 0,
          value = nil,
          override = "TargetParam1"
        },
        target_param2 = {
          default = 0,
          value = nil,
          override = "TargetParam2"
        },
        target_param3 = {
          default = 0,
          value = nil,
          override = "TargetParam3"
        },
        target_param4 = {
          default = 0,
          value = nil,
          override = "TargetParam4"
        },
        target_x = {
          default = 0,
          value = nil,
          override = "TargetX"
        },
        target_y = {
          default = 0,
          value = nil,
          override = "TargetY"
        },
        target_z = {
          default = 0,
          value = nil,
          override = "TargetZ"
        },
        target_o = {
          default = 0,
          value = nil,
          override = "TargetO"
        },
        comment = {
          default = '(NULL)',
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
    __name = "SmartScript",
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
  SmartScript = _class_0
  return _class_0
end
