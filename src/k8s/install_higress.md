# isntall

## 

helm upgrade -i higress -n higress-system higress.io/higress --create-namespace --render-subchart-notes  --set higress-core.gateway.service.type=NodePort  --set global.enableRedis=true

```shell
apiVersion: v1
kind: Service
metadata:
  name: higress-console-nodeport
  namespace: higress-system
spec:
  ports:
  - name: http
    nodePort: 31000 
    port: 8080
    protocol: TCP
    targetPort: http
  selector:
    app.kubernetes.io/instance: higress
    app.kubernetes.io/name: higress-console
  type: NodePort
```
