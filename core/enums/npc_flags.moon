_G["NPC_FLAG"] = {
    NONE:               0x00000000
    GOSSIP:             0x00000001
    QUEST_GIVER:        0x00000002
    TRAINER: {
        GENERIC:        0x00000010
        CLASS:          0x00000020
        PROFESSION:     0x00000040
    }
    VENDOR: {
        GENERIC:        0x00000080
        AMMO:           0x00000100
        FOOD:           0x00000200
        POISON:         0x00000400
        REAGENT:        0x00000800
    }
    REPAIRER:           0x00001000
    FLIGHT:             0x00002000
    SPIRIT: {
        HEALER:         0x00004000
        GUIDE:          0x00008000
    }
    INNKEEPER:          0x00010000
    BANKER:             0x00020000
    PETITIONER:         0x00040000
    TABARD_DESIGNER:    0x00080000
    BATTLEMASTER:       0x00100000
    AUCTIONNER:         0x00200000
    STABLE_MASTER:      0x00400000
    GUILD_BANKER:       0x00800000
    SPELLCLICK:         0x01000000
    MAILBOX:            0x04000000
}