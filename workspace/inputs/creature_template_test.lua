local my_new_creature = Core.Context.DB.CreatureTemplate(123450)
do
  my_new_creature:SetName("New Forge Creature with custom Data's")
  my_new_creature:SetLevel(80)
  my_new_creature:SetFaction(35)
  my_new_creature:SetNpcFlag(NPC_FLAG.VENDOR.AMMO)
  my_new_creature:SetSpeed(CT_SPEED_TYPE.WALK, 10)
  my_new_creature:SetUnitClass(UNIT_CLASS.MAGE)
  my_new_creature:SetUnitFlags(UNIT_FLAG.SILENCED)
  my_new_creature:SetModelId(1, 1254)
end
return my_new_creature:Flush()
