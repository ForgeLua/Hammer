local item_schema = {
  {
    name = "ID",
    type = "uint32"
  },
  {
    name = "ClassID",
    type = "uint32"
  },
  {
    name = "SubclassID",
    type = "uint32"
  },
  {
    name = "SoundOverrideSubclassID",
    type = "int32"
  },
  {
    name = "Material",
    type = "int32"
  },
  {
    name = "DisplayInfoID",
    type = "uint32"
  },
  {
    name = "InventoryType",
    type = "uint32"
  },
  {
    name = "SheatheType",
    type = "uint32"
  }
}
local item_dbc = Core.Common.DBCObject(item_schema)
item_dbc:Load("./workspace/inputs/dbc_input/Item.dbc")
print("Load finished. Number of rows: " .. tostring(#item_dbc.records))
print("------------------------------------------")
for index, record in ipairs(item_dbc.records) do
  print("Record #" .. tostring(index) .. ":")
  for _, field in ipairs(item_schema) do
    local field_name = field.name
    local field_value = record[field_name]
    print("  - " .. tostring(string.format('%-25s', field_name)) .. " = " .. tostring(tostring(field_value)))
  end
  print("------------------------------------------")
end
local new_record = item_dbc:CreateRecord()
new_record.ID = 12345678
new_record.ClassID = 4
new_record.SubclassID = 4
new_record.SoundOverrideSubclassID = -1
new_record.Material = 6
new_record.DisplayInfoID = 12345
new_record.InventoryType = 4
new_record.SheatheType = 3
item_dbc:AddRecord(new_record)
return item_dbc:Save("./workspace/inputs/dbc_input/Item.dbc")
