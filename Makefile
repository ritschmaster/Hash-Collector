PROJECT_NAME = hash-collector
INSTALL_DEST_DIR = $(HOME)/quicklisp/local-projects

SQLITE_CMD = sqlite3
DB_FILE = hash.db
SQL_FILE = create-db.sql

all:
	"$(SQLITE_CMD)" "$(DB_FILE)" < "$(SQL_FILE)"

clean:
	rm "$(DB_FILE)"

install:
	cp -r . "$(INSTALL_DEST_DIR)/$(PROJECT_NAME)"

uninstall:
	rm -rf "$(INSTALL_DEST_DIR)/$(PROJECT_NAME)"

