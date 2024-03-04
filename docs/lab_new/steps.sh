# Configuring the Environment
# ------------------------------------------------------------------------------------
# install minifabric
curl -o minifab -sL https://tinyurl.com/yxa2q6yr 
chmod +x minifab
sudo mv minifab /usr/local/bin

# clone the code
git clone https://github.com/ct-blockchain/minifabric

# build the new image locally
docker build -t hyperledgerlabs/minifab:latest .

# ------------------------------------------------------------------------------------
# 1) step 1 - Creating two organizations in minifabric on two different computers

##
# site A ( 192.168.0.192 )
##

minifab up -o orgA.com -e 7050  -n samplecc -p ''

##
# site B ( 192.168.0.176 )
##
minifab netup -o orgB.com -e 7060

# ------------------------------------------------------------------------------------
# 2) step 2 - Put both organizations on the same channel

scp /opt/minifabric/docs/lab/site_B/vars/JoinRequest_orgB-com.json rafa@192.168.0.192:/opt/minifabric/docs/lab/site_A/vars/NewOrgJoinRequest.json

##
# site A
##
# 
minifab channelquery,configmerge,channelsign,channelupdate

scp /opt/minifabric/docs/lab/site_A/vars/profiles/endpoints.yaml rafa@192.168.0.176:/opt/minifabric/docs/lab/site_B/vars/

##
# site B
##

minifab nodeimport,join -c mychannel

# ------------------------------------------------------------------------------------
# 3) step 3 - Install contract sample between the two organizations

##
# site B 
##

minifab install,approve -n samplecc

##
# site A
##

minifab approve,commit,discover

##
# site B
##
minifab discover


# ------------------------------------------------------------------------------------
# 4 step - Add more organizations and have them all use the same channel, under construction


##
# site C
##
minifab netup -o orgC.com -e 7070
scp /opt/minifabric/docs/lab/site_C/vars/JoinRequest_orgC-com.json rafa@192.168.0.192:/opt/minifabric/docs/lab/site_A/vars/NewOrgJoinRequest.json
##
# site A
##
#
minifab channelquery,configmerge,channelsign
scp /opt/minifabric/docs/lab/site_A/vars/mychannel_update_envelope.pb rafa@192.168.0.176:/opt/minifabric/docs/lab/site_B/vars/

##
# site B
##
minifab channelsignenvelope
scp /opt/minifabric/docs/lab/site_B/vars/mychannel_update_envelope.pb rafa@192.168.0.192:/opt/minifabric/docs/lab/site_A/vars/

##
# site A
##
#
minifab channelupdate
scp /opt/minifabric/docs/lab/site_A/vars/profiles/endpoints.yaml rafa@192.168.0.114:/opt/minifabric/docs/lab/site_C/vars/

##
# site C
##
minifab nodeimport,join -c mychannel

##
# site B
##
minifab install,approve -n samplecc

##
# site C
##
minifab install,approve -n samplecc

##
# site A
##
minifab approve,commit,discover


scp /opt/minifabric/docs/lab/site_B/vars/core.yaml rafa@192.168.0.114:/opt/minifabric/docs/lab/site_C/vars/core.yaml
##
# site C
##
minifab discover


##
# site B
##
minifab discover


#######################################
# Others
##

minifab ccup -v 1.0.0 -n samplecc -l go -r true -p ''

minifab  invoke -n samplecc -p '"invoke","put", "a","b","1"'
minifab ccup -v 3.0 -n samplecc -l go -r true -p '"init","a","200","b","300"'
minifab invoke -n samplecc -p '"invoke","get","a"'
