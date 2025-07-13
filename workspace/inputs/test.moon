creature = Core.Context.DB.CreatureTemplate(123450)
creature\SetName "New Forge Creature with custom Data's"
creature\SetLevel 80
creature\SetFaction 13
creature\SetNpcFlag NPC_FLAG.VENDOR.AMMO
creature\SetSpeed SPEED_TYPE.WALK, 10
creature\SetUnitClass UNIT_CLASS.MAGE
creature\SetUnitFlags UNIT_FLAG.SILENCED
creature\Flush!