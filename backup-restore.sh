#!/bin/bash

BACKUP_NAME="vps_backup.tar.gz"
BACKUP_URL="https://transfer.sh/vps_backup.tar.gz"

function restore_backup() {
  echo "🔄 Restoring backup..."
  curl -s --fail $BACKUP_URL -o $BACKUP_NAME || {
    echo "No previous backup found, starting fresh."
    return 1
  }
  tar -xzf $BACKUP_NAME || {
    echo "Failed to extract backup."
    return 1
  }
  echo "✅ Backup restored."
}

function backup_and_upload() {
  echo "💾 Creating backup and uploading..."
  # Adjust the folders you want to backup here
  tar czf $BACKUP_NAME ./data ./scripts ./configs 2>/dev/null || {
    echo "Nothing to backup or folders do not exist."
    return 1
  }
  UPLOAD_LINK=$(curl --upload-file $BACKUP_NAME https://transfer.sh/$BACKUP_NAME)
  echo "🆙 Backup uploaded: $UPLOAD_LINK"
  echo $UPLOAD_LINK > last_backup_url.txt
}

# Restore on start
restore_backup || true

# Run your VPS session here or from GitHub Action workflow

# Before exit: backup (you can call this explicitly when you want)
backup_and_upload || true
