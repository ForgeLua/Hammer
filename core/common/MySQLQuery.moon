module "Core.Common", package.seeall
export MySQLQuery

class MySQLQuery
    Flush: =>
        column_names = {}
        column_values = {}
        for name, value in pairs(@)
            if (string.sub(name, 1, 3) != "Get" and string.sub(name, 1, 3) != "Set" and string.sub(name, 1, 2) != "__")
                column_names[#column_names + 1] = name
                column_values[#column_values + 1] = @[value._getter]!
                
        print("INSERT INTO #{@@_table} (#{table.concat(column_names, ', ')}) VALUES (#{table.concat(column_values, ', ')});")