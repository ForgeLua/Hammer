item_schema = {
    { name: "ID",                       type: "uint32" }
    { name: "ClassID",                  type: "uint32" }
    { name: "SubclassID",               type: "uint32" }
    { name: "SoundOverrideSubclassID",  type: "int32"  }
    { name: "Material",                 type: "int32"  }
    { name: "DisplayInfoID",            type: "uint32" }
    { name: "InventoryType",            type: "uint32" }
    { name: "SheatheType",              type: "uint32" }
}

item_dbc = Core.Common.DBCObject item_schema
item_dbc\Load "./workspace/inputs/dbc_input/Item.dbc"


for index = 1, 100
    print "Record ##{index} :"

    record = item_dbc.records[index]
    for _, field in ipairs(item_schema) do
        field_name = field.name
        field_value = record[field_name]

        print string.format("  - %-25s = %s", field_name, tostring(field_value))

    print("------------------------------------------")