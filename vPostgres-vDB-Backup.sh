#!/bin/bash
# Path to vPostgres backup script (download from http://kb.vmware.com/kb/2091961)
VPOSTGRES_BACKUP_SCRIPT=/root/backup_lin.py
# Directory to store backup before uploading
BACKUP_DIRECTORY=/storage/core
# Name of the Backup file
BACKUP_FILE=${BACKUP_DIRECTORY}/backup-$(date +%F_%H-%M-%S)
# FQDN or IP of FTP Server
FTP=#######
 
 
log() {
                MESSAGE=$1
                echo "${MESSAGE}"
                logger -t 'VCSA-BACKUP' "${MESSAGE}"
}
 
# Ensure backup script exists before moving forward
if [ ! -f ${VPOSTGRES_BACKUP_SCRIPT} ]; then
                log "Unable to locate vPostgres DB backup script: ${VPOSTGRES_BACKUP_SCRIPT} ... exiting"
                exit 1
fi
 
# Start vPostgres DB backup
log "Starting vPostgres DB backup ..."
python ${VPOSTGRES_BACKUP_SCRIPT} -f ${BACKUP_FILE} > /dev/null 2>&1
if [ $? -eq 0 ]; then
                log "vPostgres DB backup completed successfully"
fi
 
# Upload vPostgres DB Backup
log "Uploading vPostgres DB backup ${BACKUP_FILE} to ${FTP}"
curl -T ${BACKUP_FILE} ftp://ftp@${FTP} > /dev/null 2>&1
if [ $? -eq 0 ]; then
                log "vPostgres DB backup file uploaded successfully"
fi
 
# Clean up
log "Cleaning up backup file ..."
rm -f ${BACKUP_FILE}