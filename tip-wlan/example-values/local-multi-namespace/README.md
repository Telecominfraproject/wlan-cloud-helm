# Helm values for deploying two Cloud SDK instances into separate namespaces

## Usage

```bash
helm install tip-wlan-1 tip-wlan -f tip-wlan/example-values/local-multi-namespace/ns-tip-1.yaml
helm install tip-wlan-2 tip-wlan -f tip-wlan/example-values/local-multi-namespace/ns-tip-2.yaml
```

This will create a Cloud SDK instance in each of the namespaces _tip-1_ and _tip-2_.
