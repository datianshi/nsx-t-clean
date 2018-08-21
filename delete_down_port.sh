
USERNAME=$1
PASSWORD=$2
HOST=$3

function delete_down_port() {
  curl -X DELETE \
     -k -u $1:$2 \
     https://$3/api/v1/pools/logical-ports/$4
}

curl -s -k -u "${USERNAME}:${PASSWORD}" \
  https://${HOST}/api/v1/logical-ports \
  | jq '.results[] | select(.admin_state == "DOWN") | .id' \
   | while read ID ; do delete_down_port ${USERNAME} ${PASSWORD} ${HOST} ${ID}; done;
