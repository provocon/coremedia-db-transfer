#!/bin/bash
#
# Copyright 2019 Martin Goellnitz.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SERVER=$1
HOST=$(grep store.url /opt/coremedia/${SERVER}*-server/*-server.properties|cut -d ' ' -f 3 |sed -e 's/jdbc:mysql:..\(.*\):.*$/\1/g')
PWD=$(grep store.pass /opt/coremedia/${SERVER}*-server/*-server.properties|grep ssword|cut -d ' ' -f 3-10)
ROLE=$(grep store.url /opt/coremedia/${SERVER}*-server/*-server.properties|cut -d ' ' -f 3-10|cut -d '/' -f 4)
mysqldump -p$PWD $ROLE -u $ROLE -h $HOST --set-gtid-purged=OFF > /var/coremedia/backup/$ROLE.sql
rm -f /var/coremedia/backup/$ROLE.sql.xz
cat /var/coremedia/backup/$ROLE.sql | parallel --block 256m --pipe --recend '' -k xz -9 > /var/coremedia/backup/$ROLE.sql.xz
chmod 644 /var/coremedia/backup/$ROLE.sql.xz
