local smart_script = Core.Context.DB.SmartScript(123450, 0)
do
  smart_script:When(SMART_EVENT.AGGRO)
  smart_script:Do(SMART_ACTION.TALK, 0)
  smart_script:On(SMART_TARGET.SELF)
  smart_script:SetComment("Say something on aggro !")
end
smart_script:Flush()
smart_script = Core.Context.DB.SmartScript(123450, 0)
do
  smart_script:When(SMART_EVENT.AGGRO)
  smart_script:Do(SMART_ACTION.TALK, 0)
  smart_script:On(SMART_TARGET.SELF)
  smart_script:SetComment("Say something on aggro !")
  smart_script:SaveCurrentEntry()
end
do
  local _with_0 = smart_script:NewEntry()
  _with_0:When(SMART_EVENT.HEALTH_PCT, 50)
  _with_0:Do(SMART_ACTION.CAST, 12345)
  _with_0:On(SMART_TARGET.SELF)
  _with_0:SetComment("Cast spell at 50% health")
end
do
  local _with_0 = smart_script:NewEntry()
  _with_0:SetEventPhaseMask(1)
  _with_0:SetEventChance(75)
  _with_0:When(SMART_EVENT.UPDATE_IC, 5000, 10000, 15000, 20000)
  _with_0:Do(SMART_ACTION.CAST, 54321, 0, 0, 0, 0, 2)
  _with_0:On(SMART_TARGET.VICTIM)
  _with_0:SetComment("Cast spell on victim with 75% chance in phase 1")
end
return smart_script:Flush()
