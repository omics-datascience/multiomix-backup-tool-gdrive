# multiomix-backup-tool-gdrive
A debian based container image with a set of scripts in bash and python for generate multiomix backups and upload them into a google drive account.

## About the Image / Container

The image is based on `debian 12` and define three environment variables that represent mount points to be used by the script logic.

- `SCRIPTS_DIR`: where the main scripts will be allocated.
- `BACKUP_DIR`: where the backups will be allocated.
- `CONFIG_DIR`: where the config files (google, aws, etc) are allocated.

The Image built process is done with `scripts/setup_image.sh` script. The script creates alternative to the main scripts, will install mongo client and several packages defined in bindep.txt file. Also it will make sure that backup folder is created.

By default image can be used right out of the box and the main concern is to create two valid volumes. One for config and other to not loose any backup once the container is stopped. 

## The scripts

### create_archive_folder.sh

This command will create an compressed archive from a parent folder and will save it inside the folder defined in BACKUP_DIR environment variable.

- **Standard usage:**

```
./create_archive_folder.sh <parent-folder-to-archive> [output-filename]
```

- **Inside Container usage:**

```
create_archive_folder <parent-folder-to-archive> [output-filename]
```


If no output file arg is defined, it will use date (`+%Y-%m-%d_%H-%M-%S`) plus parent folder name without spaces.

```
2023-07-19_20-03-40_parent-folder.tar.gz
```

### dump_postgres_db.sh

This command will create a dump file of a postgres database and will save inside a folder called like the db inside BACKUP_DIR environment variable.

- **Standard usage:**

```
./dump_postgres_db.sh <host> <database-name> <username-env-var-name> <password-env-var-name>
```

- **Inside Container usage:**

```
dump_postgres_db <host> <database-name> <username-env-var-name> <password-env-var-name>
```

Credentials will be taken from Environment variables name in the arguments. This is to avoid exposing credentials in bash cli.

### dump_mongo_db.sh

This command will create a dump file of a mongo database and will save inside a folder called like the db inside BACKUP_DIR environment variable.

- **Standard usage:**

```
./dump_mongo_db.sh <host> <database-name> <username-env-var-name> <password-env-var-name>
```

- **Inside Container usage:**

```
dump_mongo_db <host> <database-name> <username-env-var-name> <password-env-var-name>
```

Credentials will be taken from Environment variables name in the arguments. This is to avoid exposing credentials in bash cli.

## Recommendations

- Run the container in background or detached mode.
- Put the credentials file in config and share it as a volume mount.
- Make sure the backup folder is mounted as volume mount.
- Set Postgres and Mongo credentials, host, database name as environment variables.
- You can run all the scripts using exec command in kubectl or docker.
- Make sure to check the backup in the cloud before delete the real ones. Try to restore them!


Have fun :)


