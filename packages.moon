-- Core Loading
require("core.common.Logger")

require("core.utils.FileExplorer")

require("core.common.Database")
require("core.common.DatabaseObject")

-- Enums
require("core.enums.creature_elite_type")
require("core.enums.creature_family")
require("core.enums.dmg_school")
require("core.enums.npc_flags")
require("core.enums.unit_flags")
require("core.enums.unit_class")
require("core.enums.unit_dynamic_flags")
require("core.enums.unit_flags")
require("core.enums.unit_flags2")

require("core.enums.creature_template.speed_type")

-- Context DB
require("core.context.db.creature_template")

-- All processors
require("core.utils.ScriptProcessor")