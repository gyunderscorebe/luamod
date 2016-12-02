-- constants

ADMIN = 'ADMIN'
DEFAULT = 'DEFAULT'
REFEREE = 'REFEREE'

DISCONNECT = 'DISCONNECT'
CONNECT = 'CONNECT'

-- TMR

TMR_CONNECT = 1
TMR_LOAD_MAP = 2
TMR_CHK_AUTOTEAM = 3

-- consolelog

LOG_INFO = 2
LOG_WARN = 3
LOG_ERR = 4

-- say messages
-- 0  green, 1 blue, 2 yellow, 3 red, 4 gray, 5 white, 9 orange,
SAY_TEXT = '\f2'
SAY_NORMAL = '\f0'
SAY_INFO = '\f1'
SAY_WARN = '\f9'
SAY_ERR = '\f3'
SAY_SYS = '\f5'
SAY_GRAY = '\f4'
SAY_LIGHTGRAY = '\fY'
SAY_DARKGRAY = '\fZ'
SAY_MAGENTA = '\fX'
SAY_ENABLED_0 = '\f0ENABLED '
SAY_ENABLED_3 = '\f3ENABLED '
SAY_DISABLED_0 = '\f0DISABLED '
SAY_DISABLED_3 = '\f3DISABLED '

-- color

C_CN_CODES = { "\f0", "\f1", "\f2", "\f3", "\f5", "\f9", "\fB", "\fJ", "\fP", "\fV", "\fX", "\fY" }

C_CODES = { "\f0", "\f1", "\f2", "\f3", "\f4", "\f5", "\f6", "\f7", "\f8", "\f9", "\fA", "\fB", "\fC", "\fD", "\fE", "\fF", "\fG", "\fH", "\fI", "\fJ", "\fK", "\fL", "\fM", "\fN", "\fO", "\fP", "\fQ", "\fR", "\fS", "\fT", "\fU", "\fV", "\fW", "\fX", "\fY", "\fZ"}
CC_LOOKUP = { "\\f0", "\\f1", "\\f2", "\\f3", "\\f4", "\\f5", "\\f6", "\\f7", "\\f8", "\\f9", "\\fA", "\\fB", "\\fC", "\\fD", "\\fE",
  "\\fF", "\\fG", "\\fH", "\\fI", "\\fJ", "\\fK", "\\fL", "\\fM", "\\fN", "\\fO", "\\fP", "\\fQ", "\\fR", "\\fS", "\\fT",
  "\\fU", "\\fV", "\\fW", "\\fX", "\\fY", "\\fZ"}


if sdbs.flag.C_LOG then  logline(LOG_INFO,'SDBS: Player SYSTEM says: Module constants init OK') end