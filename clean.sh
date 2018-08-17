
USERNAME=$1
PASSWORD=$2
POOL_ID=$3
HOST=$4
DELETE=$5

function clean_ip() {
  curl -X POST -H "Content-Type: application/json" \
     -k -u $1:$2 --data "{\"allocation_id\": \"$3\"}" \
     https://$4/api/v1/pools/ip-pools/$5?action=RELEASE
}

curl -s \
   -k -u "${USERNAME}:${PASSWORD}" \
   https://${HOST}/api/v1/pools/ip-pools/${POOL_ID}/allocations \
   | jq -r '.results[].allocation_id' \
   | while read IP ; do clean_ip ${USERNAME} ${PASSWORD} ${IP} ${HOST} ${POOL_ID}; done;

if [ "${DELETE}" = "DELETE" ]
then
  curl -s -X DELETE \
     -k -u "${USERNAME}:${PASSWORD}" \
     https://${HOST}/api/v1/pools/ip-pools/${POOL_ID}
fi
