-- Core Loading
require("core.common.Logger")

require("core.utils.FileExplorer")

require("core.common.Database")
require("core.common.DatabaseObject")

-- Enums
require("core.enums.creature_elite_type")
require("core.enums.creature_family")
require("core.enums.creature_type")
require("core.enums.dmg_school")
require("core.enums.npc_flags")
require("core.enums.smart_action")
require("core.enums.smart_event")
require("core.enums.smart_target")
require("core.enums.unit_flags")
require("core.enums.unit_class")
require("core.enums.unit_dynamic_flags")
require("core.enums.unit_flags")
require("core.enums.unit_flags2")

require("core.enums.creature_template.speed_type")

-- Context DB
require("core.context.db.creature_template")
require("core.context.db.smart_scripts")

-- All processors
require("core.utils.ScriptProcessor")