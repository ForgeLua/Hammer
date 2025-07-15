module("Core.Common", package.seeall)
do
  local _class_0
  local _base_0 = {
    Set = function(self, field, value)
      self.fields[field].value = value
      if not (self.dirty) then
        self.dirty = true
      end
    end,
    Get = function(self, field)
      return self.fields[field].value or self.fields[field].default
    end,
    BuildInsertQuery = function(self)
      if not (self.dirty) then
        return false
      end
      local fields = { }
      local values = { }
      for field, data in pairs(self.fields) do
        table.insert(fields, field)
        if type(data.value) == "string" then
          local escaped_value = data.value:gsub("'", "\\'")
          table.insert(values, "'" .. tostring(escaped_value) .. "'")
        else
          table.insert(values, tostring(data.value or data.default))
        end
      end
      local field_str = table.concat(fields, ", ")
      local value_str = table.concat(values, ", ")
      return "INSERT INTO " .. tostring(self.table_name) .. " (" .. tostring(field_str) .. ") VALUES (" .. tostring(value_str) .. ") ON DUPLICATE KEY UPDATE " .. tostring(self:BuildUpdateClause())
    end,
    BuildUpdateClause = function(self)
      local updates = { }
      for field, data in pairs(self.fields) do
        if type(data.value) == "string" then
          local escaped_value = data.value:gsub("'", "\\'")
          table.insert(updates, tostring(field) .. " = '" .. tostring(escaped_value) .. "'")
        else
          table.insert(updates, tostring(field) .. " = " .. tostring(data.value or data.default))
        end
      end
      return table.concat(updates, ", ")
    end,
    Flush = function(self)
      if self.dirty then
        local query = self:BuildInsertQuery()
        if query then
          self.dirty = false
          Core.Common.Database:AddQuery(query)
          return Core.Common.Logger:Info("Flushed " .. tostring(self.__class.__name))
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.fields = { }
      self.table_name = ""
      self.dirty = false
    end,
    __base = _base_0,
    __name = "DatabaseObject"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DatabaseObject = _class_0
  return _class_0
end
