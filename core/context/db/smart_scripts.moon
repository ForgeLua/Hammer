module "Core.Context.DB", package.seeall
export SmartScript

class SmartScript extends Core.Common.DatabaseObject
    new: (source_id, source_type = 0) =>
        @table_name = "smart_scripts"
        @source_type = source_type
        
        @current_id = 0
        @current_link = 0

        @entries = {}
        @current_entry = nil

        @fields = {
            entryorguid:        { default: 0,           value: source_id,       override: "EntryOrGuid"             }
            source_type:        { default: 0,           value: nil,             override: "SourceType"              }
            id:                 { default: 0,           value: 0                                                    }
            link:               { default: 0,           value: nil                                                  }
            event_type:         { default: 0,           value: nil,             override: "EventType"               }
            event_phase_mask:   { default: 0,           value: nil,             override: "EventPhaseMask"          }
            event_chance:       { default: 0,           value: nil,             override: "EventChance"             }
            event_flags:        { default: 0,           value: nil,             override: "EventFlags"              }
            event_param1:       { default: 0,           value: nil,             override: "EventParam1"             }
            event_param2:       { default: 0,           value: nil,             override: "EventParam2"             }
            event_param3:       { default: 0,           value: nil,             override: "EventParam3"             }
            event_param4:       { default: 0,           value: nil,             override: "EventParam4"             }
            event_param5:       { default: 0,           value: nil,             override: "EventParam5"             }
            action_type:        { default: 0,           value: nil,             override: "ActionType"              }
            action_param1:      { default: 0,           value: nil,             override: "ActionParam1"            }
            action_param2:      { default: 0,           value: nil,             override: "ActionParam2"            }
            action_param3:      { default: 0,           value: nil,             override: "ActionParam3"            }
            action_param4:      { default: 0,           value: nil,             override: "ActionParam4"            }
            action_param5:      { default: 0,           value: nil,             override: "ActionParam5"            }
            action_param6:      { default: 0,           value: nil,             override: "ActionParam6"            }
            target_type:        { default: 0,           value: nil,             override: "TargetType"              }
            target_param1:      { default: 0,           value: nil,             override: "TargetParam1"            }
            target_param2:      { default: 0,           value: nil,             override: "TargetParam2"            }
            target_param3:      { default: 0,           value: nil,             override: "TargetParam3"            }
            target_param4:      { default: 0,           value: nil,             override: "TargetParam4"            }
            target_x:           { default: 0,           value: nil,             override: "TargetX"                 }
            target_y:           { default: 0,           value: nil,             override: "TargetY"                 }
            target_z:           { default: 0,           value: nil,             override: "TargetZ"                 }
            target_o:           { default: 0,           value: nil,             override: "TargetO"                 }
            comment:            { default: '(NULL)',    value: nil                                                  }
        }

        for column_name, column_data in pairs(@fields)
            name = column_data.override or column_name

            @["Get#{name\gsub("^%l", string.upper)}"] = ->
                return @Get column_name

            @["Set#{name\gsub("^%l", string.upper)}"] = (self, value) -> 
                @Set column_name, value
                return @

    When: (event_type, param1 = 0, param2 = 0, param3 = 0, param4 = 0, param5 = 0) =>
        @\SetEventType event_type
        @\SetEventParam1 param1
        @\SetEventParam2 param2
        @\SetEventParam3 param3
        @\SetEventParam4 param4
        @\SetEventParam5 param5
        return @

    Do: (action_type, param1 = 0, param2 = 0, param3 = 0, param4 = 0, param5 = 0, param6 = 0) =>
        @\SetActionType action_type
        @\SetActionParam1 param1
        @\SetActionParam2 param2
        @\SetActionParam3 param3
        @\SetActionParam4 param4
        @\SetActionParam5 param5
        @\SetActionParam6 param6
        return @

    On: (target_type, param1 = 0, param2 = 0, param3 = 0, param4 = 0, x = 0, y = 0, z = 0, o = 0) =>
        @\SetTargetType target_type
        @\SetTargetParam1 param1
        @\SetTargetParam2 param2
        @\SetTargetParam3 param3
        @\SetTargetParam4 param4
        @\SetTargetX x
        @\SetTargetY y
        @\SetTargetZ z
        @\SetTargetO o
        return @
    
    ResetEventActionTarget: =>
        for column_name, column_data in pairs(@fields)
            if (column_name != "link" and column_name != "id" and column_name != "entryorguid" and column_name != "source_type")
                name = column_data.override or column_name
                @["Set#{name\gsub("^%l", string.upper)}"](@, column_data.default)

    NewEntry: =>
        if @dirty
            @SaveCurrentEntry!
        @current_id += 1
        @\SetId @current_id
        if (@\GetLink! != 0)
            @\SetLink 0
        @ResetEventActionTarget!
        return @

    SaveCurrentEntry: =>
        entry = {}
        for field, data in pairs @fields
            entry[field] = data.value
        table.insert @entries, entry
        @dirty = false

    BuildInsertQuery: =>
        return false unless @dirty or #@entries > 0

        if @dirty
            @SaveCurrentEntry!

        queries = {}
        for entry in *@entries
            fields = {}
            values = {}

            for field, value in pairs entry
                table.insert fields, field
                print(field, value)
                if type(value) == "string"
                    escaped_value = value\gsub "'", "\\'"
                    table.insert values, "'#{escaped_value}'"
                else
                    table.insert values, tostring(value)

            field_str = table.concat fields, ", "
            value_str = table.concat values, ", "
            table.insert queries, "INSERT INTO #{@table_name} (#{field_str}) VALUES (#{value_str})"

        return queries

    Flush: =>
        queries = @BuildInsertQuery!
        if queries
            for query in *queries
                Core.Common.Database\AddQuery query
            @entries = {}
            @dirty = false
            Core.Common.Logger\Info("Flushed #{#queries} SmartScript entries for #{@id}")