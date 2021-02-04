# Helm values for deploying two Cloud SDK instances into separate namespaces

## Usage

```bash
helm upgrade --install tip-wlan-1 tip-wlan -f tip-wlan/example-values/local-multi-namespace/ns-tip-1.yaml --namespace tip-wlan-1 --create-namespace
helm upgrade --install tip-wlan-2 tip-wlan -f tip-wlan/example-values/local-multi-namespace/ns-tip-2.yaml --namespace tip-wlan-2 --create-namespace
```

This will create a Cloud SDK instance in each of the namespaces tip-wlan-1 and tip-wlan-2
