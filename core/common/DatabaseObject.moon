module "Core.Common", package.seeall
export DatabaseObject

class DatabaseObject
    new: () =>
        @fields = {}
        @table_name = ""
        @dirty = false
    
    Set: (field, value) =>
        @fields[field].value = value
        unless @dirty
            @dirty = true

    Get: (field) =>
        return @fields[field].value or @fields[field].default

    BuildInsertQuery: =>
        return false unless @dirty

        fields = {}
        values = {}

        for field, data in pairs @fields
            table.insert fields, field
            if type(data.value) == "string"
                escaped_value = data.value\gsub "'", "\\'"
                table.insert values, "'#{escaped_value}'"
            else
                table.insert values, tostring(data.value or data.default)

        field_str = table.concat fields, ", "
        value_str = table.concat values, ", "
        return "INSERT INTO #{@table_name} (#{field_str}) VALUES (#{value_str}) ON DUPLICATE KEY UPDATE #{@BuildUpdateClause!}"

    BuildUpdateClause: =>
        updates = {}
        for field, data in pairs @fields
            if type(data.value) == "string"
                escaped_value = data.value\gsub "'", "\\'"
                table.insert updates, "#{field} = '#{escaped_value}'"
            else
                table.insert updates, "#{field} = #{data.value or data.default}"

        return table.concat updates, ", "

    Flush: =>
        if @dirty
            query = @BuildInsertQuery!
            if query
                @dirty = false
                Core.Common.Database\AddQuery query
                Core.Common.Logger\Info("Flushed #{@@__name}")