-- consolelog

LOG_INFO = 2
LOG_WARN = 3
LOG_ERR = 4

-- say messages
-- 0  green, 1 blue, 2 yellow, 3 red, 4 gray, 5 white, 9 orange, 
SAY_TEXT = '\f2'
SAY_PRIVATE = '\f7(\f3PM\f7) '
SAY_NORMAL = '\f0'
SAY_INFO = '\fP'
SAY_WARN = '\f9'
SAY_ERR = '\f3'
SAY_SYS = '\f5'
SAY_GRAY = '\f4'
SAY_LIGHTGRAY = '\fY'
SAY_DARKGRAY = '\fZ'
SAY_MAGENTA = '\fX'

-- color

C_CODES = { "\f0", "\f1", "\f2", "\f3", "\f4", "\f5", "\f6", "\f7", "\f8", "\f9", "\fA", "\fB", "\fC", "\fD", "\fE", "\fF", "\fG", "\fH", "\fI", "\fJ", "\fK", "\fL", "\fM", "\fN", "\fO", "\fP", "\fQ", "\fR", "\fS", "\fT", "\fU", "\fV", "\fW", "\fX", "\fY", "\fZ", "\fb"}

logline(LOG_INFO,'SDBS: Player SYSTEM says: Module function constants is OK')