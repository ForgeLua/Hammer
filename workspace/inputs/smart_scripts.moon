smart_script = Core.Context.DB.SmartScript 123450, 0

with smart_script
    \SetId 1
    \When SMART_EVENT.AGGRO
    \Do SMART_ACTION.TALK, 0
    \On SMART_TARGET.SELF
    \SetComment("Say something on aggro !")

smart_script\Flush!