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

SERVER="$1"

HOST=$(grep store.url /opt/coremedia/${SERVER}*-server/*-server.properties|cut -d ' ' -f 3 |sed -e 's/jdbc:mysql:..\(.*\):.*$/\1/g')
PWD=$(grep store.pass /opt/coremedia/${SERVER}*-server/*-server.properties|grep ssword|cut -d ' ' -f 3-10)
ROLE=$(grep store.url /opt/coremedia/${SERVER}*-server/*-server.properties|cut -d ' ' -f 3-10|cut -d '/' -f 4)

TABLES=$(mysql -u $ROLE -p$PWD -h $HOST $ROLE -e 'show tables' | awk '{ print $1}' | grep -v '^Tables' )

if [ "$TABLES" == "" ]
then
 echo "Database seems to be already empty, giving up."
 exit
fi
 
for t in $TABLES ;  do
 echo "Deleting Table $t from $ROLE..."
 mysql -u $ROLE -p$PWD -h $HOST $ROLE -e "drop table $t cascade"
done

VIEWS=$(mysql -u $ROLE -p$PWD -h $HOST $ROLE -e "show full tables where TABLE_TYPE like 'VIEW'" | awk '{ print $1}' | grep -v '^Tables' )

for v in $VIEWS ;  do
 echo "Deleting View $v from $ROLE..."
 mysql -u $ROLE -p$PWD -h $HOST $ROLE -e "drop view $v cascade"
done
