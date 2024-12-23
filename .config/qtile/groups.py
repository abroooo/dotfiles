from libqtile.config import Group, Match
# from libqtile import layout as Layout



#----------------------------------------------------------------------------
# Groups
#----------------------------------------------------------------------------

groups = [
    Group("1", layout="monadtall", matches = [Match(wm_class = "xfreerdp")]),
    Group("2", layout="monadtall"),
    Group("3", layout="monadtall"),
    Group("4",layout="monadtall" ),
    Group("5",layout="monadtall" ),
    Group("6",layout="monadtall" ),
    Group("7",layout="monadtall" ),
    Group("8",layout="monadtall" ),
    Group("9",layout="monadtall", matches = [Match(wm_class = "obsidian"), Match(wm_class = "telegram-desktop")] ),
    Group("0",layout="monadtall" ),
]
