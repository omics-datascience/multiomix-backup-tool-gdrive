#!/bin/bash
SCRIPTS_DIR=${SCRIPTS_DIR:-"/scripts"}

echo "Setting up scripts..."
chmod +x $SCRIPTS_DIR/*.sh

update-alternatives --install /usr/bin/create_archive_folder create_archive_folder $SCRIPTS_DIR/create_archive_folder.sh 10
update-alternatives --install /usr/bin/dump_postgres_db dump_postgres_db $SCRIPTS_DIR/dump_postgres_db.sh 10
update-alternatives --install /usr/bin/dump_mongo_db dump_mongo_db $SCRIPTS_DIR/dump_mongo_db.sh 10
update-alternatives --install /usr/bin/upload_file upload_file $SCRIPTS_DIR/upload_file.sh 10

echo "Installing packages..."
$SCRIPTS_DIR/install_packages.sh
curl https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian11-x86_64-100.7.4.deb --output /root/mongo-db-tools.deb
dpkg -i /root/mongo-db-tools.deb


echo "Create backup folder"
mkdir -p $BACKUP_DIR
ls -ld $BACKUP_DIR