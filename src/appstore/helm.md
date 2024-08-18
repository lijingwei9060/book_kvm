top := map[string]interface{}{
"Chart":        chrt.Metadata,
"Capabilities": caps, # DefaultCapabilities
"Values" : ,
"Release": map[string]interface{}{
	"Name":      options.Name,
	"Namespace": options.Namespace,
	"IsUpgrade": options.IsUpgrade,
	"IsInstall": options.IsInstall,
	"Revision":  options.Revision,
	"Service":   "Helm",
}, 


1. return error if labels array contains system labels, "name", "owner", "status", "version", "createdAt", "modifiedAt"
2. create release object: 
```go
release.Release{
	Name:      i.ReleaseName,
	Namespace: i.Namespace,
	Chart:     chrt,
	Config:    rawVals,
	Info: &release.Info{
		FirstDeployed: ts,
		LastDeployed:  ts,
		Status:        release.StatusUnknown,
	},
	Version: 1,
	Labels:  labels,
}
```
3. renderResources: 
4. release => StatusPendingInstall
5. kubeclient.build(release.Manifest)

createNamespace
replace => replaceRelease()
Releases.Create(rel) # store the release in history before continuing.
pre-install hooks
