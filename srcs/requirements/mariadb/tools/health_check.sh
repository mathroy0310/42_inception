#!/bin/bash
# Script to check if the database file was created
if [ ! -d /var/lib/mysql/$MYSQL_DATABASE ]; then
    exit 1
else
    exit 0
fi