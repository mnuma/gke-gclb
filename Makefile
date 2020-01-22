help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

setup:
 # create static ip
 gcloud compute addresses create pingstatic-ip --global
 # create ssl certificates
 gcloud beta compute ssl-certificates create ping-ssl --domains ping.example.com
 # create security policies
 gcloud beta compute security-policies create ca-how-to-security-policy \
    --description "policy for Google Cloud Armor how-to topic"
 gcloud beta compute security-policies rules create 1000 \
    --security-policy ca-how-to-security-policy \
    --description "Deny traffic from 192.0.2.0/24." \
    --src-ip-ranges "192.0.2.0/24" \
    --action "deny-404"
