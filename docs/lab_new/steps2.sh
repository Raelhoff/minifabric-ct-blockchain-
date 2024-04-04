##
# site A ( 192.168.0.192 )
##

minifab cleanup
 

mkdir /opt/minifabric/docs/lab/site_A/var/chaincode

cp -rf ../../../chaincode ./vars/
 
    OR
 
cp -rf /opt/minifabric/hyperLedger/CouchDB/smart* /opt/minifabric/chaincode/
 
minifab up  -s couchdb -e 7050 -i 2.3.0 -o orgA.com  -n smartalerthash -p ''


##
# site B ( 192.168.0.123 )
##

minifab netup -s couchdb  -o orgB.com -e 7060

# ------------------------------------------------------------------------------------
# 2) step 2 - Put both organizations on the same channel

scp /opt/minifabric/docs/lab/site_B/vars/JoinRequest_orgB-com.json specto@192.168.0.192:/opt/minifabric/docs/lab/site_A/vars/NewOrgJoinRequest.json

##
# site A
##
#

minifab channelquery,configmerge,channelsign,channelupdate

scp /opt/minifabric/docs/lab/site_A/vars/profiles/endpoints.yaml rafael@192.168.0.123:/opt/minifabric/docs/lab/site_B/vars/

##
# site B
##

minifab nodeimport,join -c mychannel

--------------------

2) Install contract

cp -rf /home/workspace/HybridBlockchain/hyperLedger/CouchDB/smart* ./vars/chaincode/

minifab install,approve -n smartalerthash

##
# site A
##
#

minifab approve,commit,discover

##
# site B
##
#

minifab discover
minifab profilegen

-------------------------------------------------------------------------------------

 minifab invoke -n smartalerthash -p '"CreateAsset","06122023"'
 minifab query -n smartalerthash -p '"GetAllAssets"'
 minifab query -n smartalerthash -p '"AssetExists","06122023"'
 minifab query -n smartalerthash -p   '"QueryAssets", "{\"selector\":{\"HASH\":\"06122023\"}}"'


 minifab query -n smartalerthash -p '"AssetExists","65792454094"'
65792454094

********************** INSTALL APP ******************************************
 minifab apprun -l go
 
  cd vars/app/go/
 
  nano connection.json
 
  adicionar ordenador no arquivo
 
  ,
  "orderers": {
    "orderer1.orgA-orderer.com": {
      "url": "grpcs://192.168.0.192:7055",
      "grpcOptions": {
        "ssl-target-name-override": "orderer1.orgA-orderer.com"
      },
      "tlsCACerts": {
        "pem": "-----BEGIN CERTIFICATE-----\nMIICwDCCAmagAwIBAgIUNt5mz7n6V2Mz9Gpb1dGSls9IYuwwCgYIKoZIzj0EAwIw\ndDELMAkGA1UEBhMCVVMxFzAVBgNVBAgMDk5vcnRoIENhcm9saW5hMRAwDgYDVQQH\nDAdSYWxlaWdoMRkwFwYDVQQKDBBvcmdBLW9yZGVyZXIuY29tMR8wHQYDVQQDDBZ0\nbHNjYS5vcmdBLW9yZGVyZXIuY29tMB4XDTI0MDMyMzIzMzk1M1oXDTM0MDMyMTIz\nMzk1M1owdDELMAkGA1UEBhMCVVMxFzAVBgNVBAgMDk5vcnRoIENhcm9saW5hMRAw\nDgYDVQQHDAdSYWxlaWdoMRkwFwYDVQQKDBBvcmdBLW9yZGVyZXIuY29tMR8wHQYD\nVQQDDBZ0bHNjYS5vcmdBLW9yZGVyZXIuY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0D\nAQcDQgAEiI8v8CTa7t56rgiBF/pnuQIQJKqZQTRI8kQutyH3vZV8Kr9jApPaNvCT\n7kPIDmmhxvO3ioOt4T0zT+DE+F/ZdaOB1TCB0jAdBgNVHQ4EFgQUSMaMRupL7EtV\ne7YCpx5qjQr3KM8wHwYDVR0jBBgwFoAUSMaMRupL7EtVe7YCpx5qjQr3KM8wDwYD\nVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAaYwHQYDVR0lBBYwFAYIKwYBBQUH\nAwEGCCsGAQUFBwMCMFAGA1UdEQRJMEeHBMCoAMCCFnRsc2NhLm9yZ0Etb3JkZXJl\nci5jb22CFnRsc2NhLW9yZ0Etb3JkZXJlci1jb22CCWxvY2FsaG9zdIcEfwAAATAK\nBggqhkjOPQQDAgNIADBFAiEAmoZ03uJFehpyob6Ikx0MkyKjc1dSObnwsXwbWuMc\nXlMCIHLSDbgiwEu5/KP3hwu1AtNB7+mHN05TFHr63iPciB1v\n-----END CERTIFICATE-----"
      }
    }
  },
 