#!/bin/bash

REPO_BASE=/var/local/svn
TARGET=/opt/backup/
SVNADMIN=/usr/bin/svnadmin
GZIP=/bin/gzip

cd "$REPO_BASE"
for f in *; do
        FILE="$TARGET$f-$(date +"%Y-%m-%d-%T").dump.gz"
        echo "Dump: $f => $FILE"
    test -d "$f"  &&  $SVNADMIN dump "$f" | "$GZIP" -9 > "$FILE"
done
