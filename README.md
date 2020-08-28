# opa-gatekeeper-up-and-running

This is a step by step distillation of information available [here](https://github.com/open-policy-agent/gatekeeper#installation-instructions)


1. `make up`
2. `make install`
3. `make install-constraint-template`
4. `make install-constraint`

Once a constraint template has been configured, a constraint can be request using said template.

```bash
 kubectl get constraint -o wide
NAME              AGE
ns-must-have-gk   15s
```

Now let's test it...

```bash
 kubectl create ns test
Error from server ([denied by ns-must-have-gk] you must provide labels: {"gatekeeper"}): admission webhook "validation.gatekeeper.sh" denied the request: [denied by ns-must-have-gk] you must provide labels: {"gatekeeper"}
```

Here you can see the constraint is honoring the requirements within the Constraint...

```
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredLabels
metadata:
  name: ns-must-have-gk
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Namespace"]
  parameters: 
    labels: ["gatekeeper"]
```

The `gatekeeper` parameter is passed through to the rego policy within the ConstraintTemplate.

```
package k8srequiredlabels

        violation[{"msg": msg, "details": {"missing_labels": missing}}] {
          provided := {label | input.review.object.metadata.labels[label]}
          required := {label | label := input.parameters.labels[_]}
          missing := required - provided
          count(missing) > 0
          msg := sprintf("you must provide labels: %v", [missing])
        }
```

## Requirements
- kubectl 
- docker

### Further reading

https://github.com/AlexsJones/opa-gatekeeper-up-and-running
