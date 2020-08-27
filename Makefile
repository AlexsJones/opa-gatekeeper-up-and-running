up:
	kind create cluster
	kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin \
    --user foo@bar.com
down: 
	kind delete cluster
install:
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
uninstall:
	kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
install-constraint-template:
	kubectl apply -f constraint-template.yaml
install-constraint:
	kubectl apply -f constraint.yaml
