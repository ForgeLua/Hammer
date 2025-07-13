my_new_creature = Core.Context.DB.CreatureTemplate(123450)

with my_new_creature
    \SetName "New Forge Creature with custom Data's"
    \SetLevel 80
    \SetFaction 35
    \SetNpcFlag NPC_FLAG.VENDOR.AMMO
    \SetSpeed CT_SPEED_TYPE.WALK, 10
    \SetUnitClass UNIT_CLASS.MAGE
    \SetUnitFlags UNIT_FLAG.SILENCED
    \SetModelId 1, 1254

my_new_creature\Flush!