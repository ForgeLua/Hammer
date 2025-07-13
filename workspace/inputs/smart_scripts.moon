smart_script = Core.Context.DB.SmartScript 123450, 0

with smart_script
    \SetId 1
    \When 4
    \Do 1, 0
    \On 0
    \SetComment("Say something on aggro !")

smart_script\Flush!