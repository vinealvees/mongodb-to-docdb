#!/bin/bash

#Configure MongoDB Repository
cat <<EOF >> /etc/yum.repos.d/mongodb-org-6.0.repo
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
EOF

#Install MongoDB packagtes and GIT
sudo yum install -y mongodb-org git

#Start MongoDB
sudo systemctl start mongod
sudo systemctl daemon-reload

#Enable on boot
sudo systemctl enable mongod

#Get Public Hostname
publichostname=$(curl http://169.254.169.254/latest/meta-data/public-hostname)

#Modify the bindIp to public-dns-name
sed -i "s/127.0.0.1/$publichostname/g" /etc/mongod.conf

#Restart Service
sudo service mongod restart

#Populate MongoDB
wget http://media.mongodb.org/zips.json
mongoimport --host "$publichostname":27017 --db zips-db --file zips.json

#Show data

#mongosh --host "$publichostname":27017

# use zips-db

# db.zips.count()

# db.zips.aggregate( [
#    { $group: { _id: { state: "$state", city: "$city" }, pop: { $sum: "$pop" } } },
#    { $group: { _id: "$_id.state", avgCityPop: { $avg: "$pop" } } }
# ] )

# exit

#Cloning Tools
toolsdir="/tmp/amazon-documentdb-tools/"
git clone https://github.com/awslabs/amazon-documentdb-tools.git $toolsdir

#Dump Indexes
indextooldir="${toolsdir}index-tool/"
dumpdir="/tmp/mongodbdump/"
mkdir $dumpdir
cd $indextooldir || exit
pip3 install -r requirements.txt
python3 migrationtools/documentdb_index_tool.py --dump-indexes --uri "$publichostname":27017 --dir $dumpdir

#Check Compatibility
python3 migrationtools/documentdb_index_tool.py --show-issues --dir "$dumpdir" >> "$dumpdir"compatibility_check.txt

#Restore Indexes to DocumentDB
wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
clusterendpoint=$(aws docdb describe-db-clusters --db-cluster-identifier docdb-cluster-demo --region us-west-2 | jq -r .DBClusters[0].Endpoint)
pass="barbut8chars"
uri="mongodb://foo:$pass@$clusterendpoint:27017/?ssl=true&ssl_ca_certs=rds-combined-ca-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false&tlsAllowInvalidCertificates=true"
python3 migrationtools/documentdb_index_tool.py --restore-indexes --uri "$uri" --dir "$dumpdir"

