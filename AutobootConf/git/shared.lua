-- Constants

APP_REPO = "DavisDev"
APP_PROJECT = "AutobootConf"

APP_VERSION_MAJOR = 0x01 -- major.minor
APP_VERSION_MINOR = 0x20

APP_VERSION = ((APP_VERSION_MAJOR << 0x18) | (APP_VERSION_MINOR << 0x10)) -- Union Binary
