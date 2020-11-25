
# https://docs.atlas.mongodb.com/reference/api/auditing/

# https://docs.atlas.mongodb.com/reference/api/monitoring-and-logs/
# https://docs.atlas.mongodb.com/reference/api/logs/

# https://docs.atlas.mongodb.com/reference/api/access-tracking/


curl --user 'hucaecjq:73ad2035-da5f-4799-a7fe-3896f01772bc' --digest \
  --header 'Accept: application/json' \
  --include \
  --request GET "https://cloud.mongodb.com/api/atlas/v1.0?pretty=true"


curl -u "hucaecjq:73ad2035-da5f-4799-a7fe-3896f01772bc" --digest \
 --header "Accept: application/json" \
 --header "Content-Type: application/json" \
 --request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/5fb433e6990b7c78a445712f/auditLog?pretty=true"

# Audit logs
curl --user 'hucaecjq:73ad2035-da5f-4799-a7fe-3896f01772bc' --digest \
 --header 'Accept: application/gzip' \
 --request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/5fb433e6990b7c78a445712f/clusters/cvs2-project-gcp-shard-00-01.inyyw.mongodb.net/logs/mongodb.gz" \
 --output "mongodb.gz"

curl --user 'hucaecjq:73ad2035-da5f-4799-a7fe-3896f01772bc' --digest \
 --header 'Accept: application/gzip' \
 --request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/5fb433e6990b7c78a445712f/clusters/cvs2-project-gcp-shard-00-01.inyyw.mongodb.net/logs/mongodb-audit-log.gz" \
 --output "mongodb-audit-log.gz"