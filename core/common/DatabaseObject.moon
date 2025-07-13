module "Core.Common", package.seeall
export DatabaseObject

class DatabaseObject
    new: (id) =>
        @id = id
        @fields = {}
        @table_name = ""
        @dirty = false
    
    Set: (field, value) =>
        @fields[field] = value
        unless @dirty
            @dirty = true

    Get: (field) =>
        return @fields[field]

    BuildInsertQuery: =>
        return false unless @dirty

        fields = {}
        values = {}

        table.insert fields, "entry"
        table.insert values, @id

        for field, value in pairs @fields
            table.insert fields, field
            if type(value) == "string"
                escaped_value = value\gsub "'", "\\'"
                table.insert values, "'#{escaped_value}'"
            else
                table.insert values, tostring(value)

        field_str = table.concat fields, ", "
        value_str = table.concat values, ", "
        return "INSERT INTO #{@table_name} (#{field_str}) VALUES (#{value_str}) ON DUPLICATE KEY UPDATE #{@BuildUpdateClause!}"

    BuildUpdateClause: =>
        updates = {}
        for field, value in pairs @fields
            if type(value) == "string"
                escaped_value = value\gsub "'", "\\'"
                table.insert updates, "#{field} = '#{escaped_value}'"
            else
                table.insert updates, "#{field} = #{value}"

        return table.concat updates, ", "

    Flush: =>
        if @dirty
            query = @BuildInsertQuery!
            if query
                @dirty = false
                Core.Common.Database\AddQuery query
                Core.Common.Logger\Info("Flushed #{@@__name}(#{@id})")