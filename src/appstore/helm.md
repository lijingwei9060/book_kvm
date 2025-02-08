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

```go
type Chart struct {
	// Raw contains the raw contents of the files originally contained in the chart archive.
	//
	// This should not be used except in special cases like `helm show values`,
	// where we want to display the raw values, comments and all.
	Raw []*File `json:"-"`
	// Metadata is the contents of the Chartfile.
	Metadata *Metadata {
			// The name of the chart. Required.
			Name string `json:"name,omitempty"`
			// The URL to a relevant project page, git repo, or contact person
			Home string `json:"home,omitempty"`
			// Source is the URL to the source code of this chart
			Sources []string `json:"sources,omitempty"`
			// A SemVer 2 conformant version string of the chart. Required.
			Version string `json:"version,omitempty"`
			// A one-sentence description of the chart
			Description string `json:"description,omitempty"`
			// A list of string keywords
			Keywords []string `json:"keywords,omitempty"`
			// A list of name and URL/email address combinations for the maintainer(s)
			Maintainers []*Maintainer `json:"maintainers,omitempty"`
			// The URL to an icon file.
			Icon string `json:"icon,omitempty"`
			// The API Version of this chart. Required.
			APIVersion string `json:"apiVersion,omitempty"`
			// The condition to check to enable chart
			Condition string `json:"condition,omitempty"`
			// The tags to check to enable chart
			Tags string `json:"tags,omitempty"`
			// The version of the application enclosed inside of this chart.
			AppVersion string `json:"appVersion,omitempty"`
			// Whether or not this chart is deprecated
			Deprecated bool `json:"deprecated,omitempty"`
			// Annotations are additional mappings uninterpreted by Helm,
			// made available for inspection by other applications.
			Annotations map[string]string `json:"annotations,omitempty"`
			// KubeVersion is a SemVer constraint specifying the version of Kubernetes required.
			KubeVersion string `json:"kubeVersion,omitempty"`
			// Dependencies are a list of dependencies for a chart.
			Dependencies []*Dependency {
				// Name is the name of the dependency.
				//
				// This must mach the name in the dependency's Chart.yaml.
				Name string `json:"name"`
				// Version is the version (range) of this chart.
				//
				// A lock file will always produce a single version, while a dependency
				// may contain a semantic version range.
				Version string `json:"version,omitempty"`
				// The URL to the repository.
				//
				// Appending `index.yaml` to this string should result in a URL that can be
				// used to fetch the repository index.
				Repository string `json:"repository"`
				// A yaml path that resolves to a boolean, used for enabling/disabling charts (e.g. subchart1.enabled )
				Condition string `json:"condition,omitempty"`
				// Tags can be used to group charts for enabling/disabling together
				Tags []string `json:"tags,omitempty"`
				// Enabled bool determines if chart should be loaded
				Enabled bool `json:"enabled,omitempty"`
				// ImportValues holds the mapping of source values to parent key to be imported. Each item can be a
				// string or pair of child/parent sublist items.
				ImportValues []interface{} `json:"import-values,omitempty"`
				// Alias usable alias to be used for the chart
				Alias string `json:"alias,omitempty"`
			}
			// Specifies the chart type: application or library
			Type string `json:"type,omitempty"`
			}
	// Lock is the contents of Chart.lock.
	Lock *Lock `json:"lock"`
	// Templates for this chart.
	Templates []*File `json:"templates"`
	// Values are default config for this chart.
	Values map[string]interface{} `json:"values"`
	// Schema is an optional JSON schema for imposing structure on Values
	Schema []byte `json:"schema"`
	// Files are miscellaneous files in a chart archive,
	// e.g. README, LICENSE, etc.
	Files []*File `json:"files"`

	parent       *Chart
	dependencies []*Chart
}
```
1. i.availableName() # name是否可用，empty, too long, already in use will return an error.
2. chartutil.ProcessDependenciesWithMerge(chrt, vals)
   1. processDependencyEnabled(c, v, "")	# removes disabled charts from dependencies
      1. 更新chartDependencies，chart.Metadata.Dependencies和chart.dependencies
      2. CoalesceValues(c, v) **
      3. //   - Values in a higher level chart always override values in a lower-level dependency chart
				 //   - Scalar values and arrays are replaced, maps are merged
				 //   - A chart has access to all of the variables for it, as well as all of the values destined for its dependencies.
      4. processDependencyTags(c.Metadata.Dependencies, cvals) // Tags 中是否有disable或者enable的标签，修改c.Metadata.Dependency.Enalbe值
      5. processDependencyConditions(c.Metadata.Dependencies, cvals, path) // c.Metadata.Dependency.Condition 逗号分隔的path+Condition如果为cvals中为disable就会禁用
      6. copy(cd, c.Dependencies()[:0]) // remove disabled chart
      7. copy(cdMetadata, c.Metadata.Dependencies[:0])// don't keep disabled charts in new slice
      8. processDependencyEnabled(t, cvals, path + t.Metadata.Name + "."); // recursively call self to process sub dependencies
      9. c.Metadata.Dependencies = append(c.Metadata.Dependencies, cdMetadata...) // set the correct dependencies in metadata
      10. c.SetDependencies(cd...)
3. i.installCRDs(crds); # Pre-install anything in the crd/ directory. We do this before Helm contacts the upstream server and builds the capabilities object.
4. chartutil.ToRenderValuesWithSchemaValidation(chrt, vals, options, caps, i.SkipSchemaValidation)
5. return error if labels array contains system labels, "name", "owner", "status", "version", "createdAt", "modifiedAt"
6. create release object: 
```go
release.Release{
	Name:      i.ReleaseName,
	// Namespace is the kubernetes namespace of the release.
	Namespace: i.Namespace,
	Chart:     chrt,
	// Config is the set of extra Values added to the chart.
	// These values override the default values inside of the chart.
	Config:    rawVals,
	// Info provides information about a release
	Info: &release.Info{
		FirstDeployed: ts,
		LastDeployed:  ts,
		Status:        release.StatusUnknown,
	},
	// Version is an int which represents the revision of the release.
	Version: 1,
	// Labels of the release.
	// Disabled encoding into Json cause labels are stored in storage driver metadata field.
	Labels:  labels,
	// Manifest is the string representation of the rendered template.
	// Hooks are all of the hooks declared for this release.
	
}
```
3. renderResources: 
4. release => StatusPendingInstall
5. kubeclient.build(release.Manifest)

createNamespace
replace => replaceRelease()
Releases.Create(rel) # store the release in history before continuing.


Install
1. i.cfg.execHook(rel, release.HookPreInstall, i.Timeout); # pre-install hooks
2. i.cfg.KubeClient.Create(resources)
3. i.cfg.KubeClient.WaitWithJobs(resources, i.Timeout) # wait for resource
4. i.cfg.execHook(rel, release.HookPostInstall, i.Timeout)
5. rel.SetStatus(release.StatusDeployed, i.Description) or  "Install complete"
6. i.recordRelease(rel)

FailRelease:


## Storage

key = "sh.helm.release.v1.{name}.v{version}"

cfgmap
memory
sql
Secret