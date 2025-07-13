
-- Simple SmartScript
-- smart_script = Core.Context.DB.SmartScript 123450, 0

-- with smart_script
--     \SetId 1
--     \When SMART_EVENT.AGGRO
--     \Do SMART_ACTION.TALK, 0
--     \On SMART_TARGET.SELF
--     \SetComment("Say something on aggro !")
-- smart_script\Flush!

-- More advanced smart_script
smart_script = Core.Context.DB.SmartScript 123450, 0

with smart_script
    \When SMART_EVENT.AGGRO
    \Do SMART_ACTION.TALK, 0
    \On SMART_TARGET.SELF
    \SetComment("Say something on aggro !")
    \SaveCurrentEntry!

with smart_script\NewEntry!
    \When SMART_EVENT.HEALTH_PCT, 50
    \Do SMART_ACTION.CAST, 12345
    \On SMART_TARGET.SELF
    \SetComment "Cast spell at 50% health"

with smart_script\NewEntry!
    \SetEventPhaseMask 1
    \SetEventChance 75
    \When SMART_EVENT.UPDATE_IC, 5000, 10000, 15000, 20000
    \Do SMART_ACTION.CAST, 54321, 0, 0, 0, 0, 2
    \On SMART_TARGET.VICTIM
    \SetComment "Cast spell on victim with 75% chance in phase 1"

smart_script\Flush!