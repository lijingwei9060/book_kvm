https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/customresourcedefinitions?sortBy=createTime&limit=10&page=1

```json
{
 "items": [
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "workspacetemplates.tenant.kubesphere.io",
    "uid": "edd4f1db-1c43-43fc-9f9d-2ae4e2cadad4",
    "resourceVersion": "1850",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "tenant.kubesphere.io",
    "names": {
     "plural": "workspacetemplates",
     "singular": "workspacetemplate",
     "kind": "WorkspaceTemplate",
     "listKind": "WorkspaceTemplateList",
     "categories": [
      "tenant"
     ]
    },
    "scope": "Cluster",
    "versions": [
     {
      "name": "v1alpha2",
      "served": true,
      "storage": false,
      "deprecated": true,
      "schema": {
       "openAPIV3Schema": {
        "type": "object",
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "type": "object",
          "required": [
           "placement",
           "template"
          ],
          "properties": {
           "overrides": {
            "type": "array",
            "items": {
             "type": "object",
             "required": [
              "clusterName"
             ],
             "properties": {
              "clusterName": {
               "type": "string"
              },
              "clusterOverrides": {
               "type": "array",
               "items": {
                "type": "object",
                "required": [
                 "path"
                ],
                "properties": {
                 "op": {
                  "type": "string"
                 },
                 "path": {
                  "type": "string"
                 },
                 "value": {
                  "type": "object",
                  "x-kubernetes-preserve-unknown-fields": true
                 }
                }
               }
              }
             }
            }
           },
           "placement": {
            "type": "object",
            "properties": {
             "clusterSelector": {
              "description": "A label selector is a label query over a set of resources. The result of matchLabels and\nmatchExpressions are ANDed. An empty label selector matches all objects. A null\nlabel selector matches no objects.",
              "type": "object",
              "properties": {
               "matchExpressions": {
                "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                "type": "array",
                "items": {
                 "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                 "type": "object",
                 "required": [
                  "key",
                  "operator"
                 ],
                 "properties": {
                  "key": {
                   "description": "key is the label key that the selector applies to.",
                   "type": "string"
                  },
                  "operator": {
                   "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                   "type": "string"
                  },
                  "values": {
                   "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                   "type": "array",
                   "items": {
                    "type": "string"
                   }
                  }
                 }
                }
               },
               "matchLabels": {
                "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                "type": "object",
                "additionalProperties": {
                 "type": "string"
                }
               }
              },
              "x-kubernetes-map-type": "atomic"
             },
             "clusters": {
              "type": "array",
              "items": {
               "type": "object",
               "required": [
                "name"
               ],
               "properties": {
                "name": {
                 "type": "string"
                }
               }
              },
              "x-kubernetes-list-map-keys": [
               "name"
              ],
              "x-kubernetes-list-type": "map"
             }
            }
           },
           "template": {
            "type": "object",
            "properties": {
             "metadata": {
              "type": "object"
             },
             "spec": {
              "description": "WorkspaceSpec defines the desired state of Workspace",
              "type": "object",
              "properties": {
               "manager": {
                "type": "string"
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
     },
     {
      "name": "v1beta1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "WorkspaceTemplate is the Schema for the workspacetemplates API",
        "type": "object",
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "type": "object",
          "required": [
           "placement",
           "template"
          ],
          "properties": {
           "placement": {
            "type": "object",
            "properties": {
             "clusterSelector": {
              "description": "A label selector is a label query over a set of resources. The result of matchLabels and\nmatchExpressions are ANDed. An empty label selector matches all objects. A null\nlabel selector matches no objects.",
              "type": "object",
              "properties": {
               "matchExpressions": {
                "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                "type": "array",
                "items": {
                 "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                 "type": "object",
                 "required": [
                  "key",
                  "operator"
                 ],
                 "properties": {
                  "key": {
                   "description": "key is the label key that the selector applies to.",
                   "type": "string"
                  },
                  "operator": {
                   "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                   "type": "string"
                  },
                  "values": {
                   "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                   "type": "array",
                   "items": {
                    "type": "string"
                   }
                  }
                 }
                }
               },
               "matchLabels": {
                "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                "type": "object",
                "additionalProperties": {
                 "type": "string"
                }
               }
              },
              "x-kubernetes-map-type": "atomic"
             },
             "clusters": {
              "type": "array",
              "items": {
               "type": "object",
               "required": [
                "name"
               ],
               "properties": {
                "name": {
                 "type": "string"
                }
               }
              },
              "x-kubernetes-list-map-keys": [
               "name"
              ],
              "x-kubernetes-list-type": "map"
             }
            }
           },
           "template": {
            "type": "object",
            "properties": {
             "metadata": {
              "type": "object",
              "properties": {
               "annotations": {
                "type": "object",
                "additionalProperties": {
                 "type": "string"
                }
               },
               "labels": {
                "type": "object",
                "additionalProperties": {
                 "type": "string"
                }
               }
              }
             },
             "spec": {
              "description": "WorkspaceSpec defines the desired state of Workspace",
              "type": "object",
              "properties": {
               "manager": {
                "type": "string"
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "workspacetemplates",
     "singular": "workspacetemplate",
     "kind": "WorkspaceTemplate",
     "listKind": "WorkspaceTemplateList",
     "categories": [
      "tenant"
     ]
    },
    "storedVersions": [
     "v1beta1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "workspaces.tenant.kubesphere.io",
    "uid": "22894f88-4939-42f6-abee-4b688f24f5a2",
    "resourceVersion": "1847",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "tenant.kubesphere.io",
    "names": {
     "plural": "workspaces",
     "singular": "workspace",
     "kind": "Workspace",
     "listKind": "WorkspaceList",
     "categories": [
      "tenant"
     ]
    },
    "scope": "Cluster",
    "versions": [
     {
      "name": "v1alpha1",
      "served": true,
      "storage": false,
      "deprecated": true,
      "schema": {
       "openAPIV3Schema": {
        "type": "object",
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "type": "object",
          "properties": {
           "manager": {
            "type": "string"
           },
           "networkIsolation": {
            "type": "boolean"
           }
          }
         },
         "status": {
          "type": "object"
         }
        }
       }
      }
     },
     {
      "name": "v1beta1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "Workspace is the Schema for the workspaces API",
        "type": "object",
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "description": "WorkspaceSpec defines the desired state of Workspace",
          "type": "object",
          "properties": {
           "manager": {
            "type": "string"
           }
          }
         },
         "status": {
          "description": "WorkspaceStatus defines the observed state of Workspace",
          "type": "object"
         }
        }
       }
      }
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "workspaces",
     "singular": "workspace",
     "kind": "Workspace",
     "listKind": "WorkspaceList",
     "categories": [
      "tenant"
     ]
    },
    "storedVersions": [
     "v1beta1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "workspaceroles.iam.kubesphere.io",
    "uid": "b19f01e9-2554-4231-8838-d4ad601bcf5e",
    "resourceVersion": "1806",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "iam.kubesphere.io",
    "names": {
     "plural": "workspaceroles",
     "singular": "workspacerole",
     "kind": "WorkspaceRole",
     "listKind": "WorkspaceRoleList",
     "categories": [
      "iam"
     ]
    },
    "scope": "Cluster",
    "versions": [
     {
      "name": "v1alpha2",
      "served": true,
      "storage": false,
      "deprecated": true,
      "schema": {
       "openAPIV3Schema": {
        "type": "object",
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "rules": {
          "description": "Rules holds all the PolicyRules for this WorkspaceRole",
          "type": "array",
          "items": {
           "description": "PolicyRule holds information that describes a policy rule, but does not contain information\nabout who the rule applies to or which namespace the rule applies to.",
           "type": "object",
           "required": [
            "verbs"
           ],
           "properties": {
            "apiGroups": {
             "description": "APIGroups is the name of the APIGroup that contains the resources.  If multiple API groups are specified, any action requested against one of\nthe enumerated resources in any API group will be allowed. \"\" represents the core API group and \"*\" represents all API groups.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "nonResourceURLs": {
             "description": "NonResourceURLs is a set of partial urls that a user should have access to.  *s are allowed, but only as the full, final step in the path\nSince non-resource URLs are not namespaced, this field is only applicable for ClusterRoles referenced from a ClusterRoleBinding.\nRules can either apply to API resources (such as \"pods\" or \"secrets\") or non-resource URL paths (such as \"/api\"),  but not both.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "resourceNames": {
             "description": "ResourceNames is an optional white list of names that the rule applies to.  An empty set means that everything is allowed.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "resources": {
             "description": "Resources is a list of resources this rule applies to. '*' represents all resources.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "verbs": {
             "description": "Verbs is a list of Verbs that apply to ALL the ResourceKinds contained in this rule. '*' represents all verbs.",
             "type": "array",
             "items": {
              "type": "string"
             }
            }
           }
          }
         }
        }
       }
      },
      "subresources": {},
      "additionalPrinterColumns": [
       {
        "name": "Workspace",
        "type": "string",
        "jsonPath": ".metadata.labels.kubesphere\\.io/workspace"
       },
       {
        "name": "Alias",
        "type": "string",
        "jsonPath": ".metadata.annotations.kubesphere\\.io/alias-name"
       }
      ]
     },
     {
      "name": "v1beta1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "WorkspaceRole is the Schema for the workspaceroles API",
        "type": "object",
        "properties": {
         "aggregationRoleTemplates": {
          "description": "AggregationRoleTemplates means which RoleTemplates are composed this Role",
          "type": "object",
          "properties": {
           "roleSelector": {
            "description": "RoleSelectors select rules from RoleTemplate`s rules by labels",
            "type": "object",
            "properties": {
             "matchExpressions": {
              "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
              "type": "array",
              "items": {
               "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
               "type": "object",
               "required": [
                "key",
                "operator"
               ],
               "properties": {
                "key": {
                 "description": "key is the label key that the selector applies to.",
                 "type": "string"
                },
                "operator": {
                 "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                 "type": "string"
                },
                "values": {
                 "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                 "type": "array",
                 "items": {
                  "type": "string"
                 }
                }
               }
              }
             },
             "matchLabels": {
              "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
              "type": "object",
              "additionalProperties": {
               "type": "string"
              }
             }
            },
            "x-kubernetes-map-type": "atomic"
           },
           "templateNames": {
            "description": "TemplateNames select rules from RoleTemplate`s rules by RoleTemplate name",
            "type": "array",
            "items": {
             "type": "string"
            },
            "x-kubernetes-list-type": "set"
           }
          }
         },
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "rules": {
          "description": "Rules holds all the PolicyRules for this WorkspaceRole",
          "type": "array",
          "items": {
           "description": "PolicyRule holds information that describes a policy rule, but does not contain information\nabout who the rule applies to or which namespace the rule applies to.",
           "type": "object",
           "required": [
            "verbs"
           ],
           "properties": {
            "apiGroups": {
             "description": "APIGroups is the name of the APIGroup that contains the resources.  If multiple API groups are specified, any action requested against one of\nthe enumerated resources in any API group will be allowed. \"\" represents the core API group and \"*\" represents all API groups.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "nonResourceURLs": {
             "description": "NonResourceURLs is a set of partial urls that a user should have access to.  *s are allowed, but only as the full, final step in the path\nSince non-resource URLs are not namespaced, this field is only applicable for ClusterRoles referenced from a ClusterRoleBinding.\nRules can either apply to API resources (such as \"pods\" or \"secrets\") or non-resource URL paths (such as \"/api\"),  but not both.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "resourceNames": {
             "description": "ResourceNames is an optional white list of names that the rule applies to.  An empty set means that everything is allowed.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "resources": {
             "description": "Resources is a list of resources this rule applies to. '*' represents all resources.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "verbs": {
             "description": "Verbs is a list of Verbs that apply to ALL the ResourceKinds contained in this rule. '*' represents all verbs.",
             "type": "array",
             "items": {
              "type": "string"
             }
            }
           }
          }
         }
        }
       }
      },
      "subresources": {},
      "additionalPrinterColumns": [
       {
        "name": "Workspace",
        "type": "string",
        "jsonPath": ".metadata.labels.kubesphere\\.io/workspace"
       },
       {
        "name": "Alias",
        "type": "string",
        "jsonPath": ".metadata.annotations.kubesphere\\.io/alias-name"
       }
      ]
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "workspaceroles",
     "singular": "workspacerole",
     "kind": "WorkspaceRole",
     "listKind": "WorkspaceRoleList",
     "categories": [
      "iam"
     ]
    },
    "storedVersions": [
     "v1beta1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "workspacerolebindings.iam.kubesphere.io",
    "uid": "831dd6fd-b933-4dc8-b2b0-ebdf4e34f913",
    "resourceVersion": "1800",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "iam.kubesphere.io",
    "names": {
     "plural": "workspacerolebindings",
     "singular": "workspacerolebinding",
     "kind": "WorkspaceRoleBinding",
     "listKind": "WorkspaceRoleBindingList",
     "categories": [
      "iam"
     ]
    },
    "scope": "Cluster",
    "versions": [
     {
      "name": "v1alpha2",
      "served": true,
      "storage": false,
      "deprecated": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "WorkspaceRoleBinding is the Schema for the workspacerolebindings API",
        "type": "object",
        "required": [
         "roleRef"
        ],
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "roleRef": {
          "description": "RoleRef can only reference a WorkspaceRole.\nIf the RoleRef cannot be resolved, the Authorizer must return an error.",
          "type": "object",
          "required": [
           "apiGroup",
           "kind",
           "name"
          ],
          "properties": {
           "apiGroup": {
            "description": "APIGroup is the group for the resource being referenced",
            "type": "string"
           },
           "kind": {
            "description": "Kind is the type of resource being referenced",
            "type": "string"
           },
           "name": {
            "description": "Name is the name of resource being referenced",
            "type": "string"
           }
          },
          "x-kubernetes-map-type": "atomic"
         },
         "subjects": {
          "description": "Subjects holds references to the objects the role applies to.",
          "type": "array",
          "items": {
           "description": "Subject contains a reference to the object or user identities a role binding applies to.  This can either hold a direct API object reference,\nor a value for non-objects such as user and group names.",
           "type": "object",
           "required": [
            "kind",
            "name"
           ],
           "properties": {
            "apiGroup": {
             "description": "APIGroup holds the API group of the referenced subject.\nDefaults to \"\" for ServiceAccount subjects.\nDefaults to \"rbac.authorization.k8s.io\" for User and Group subjects.",
             "type": "string"
            },
            "kind": {
             "description": "Kind of object being referenced. Values defined by this API group are \"User\", \"Group\", and \"ServiceAccount\".\nIf the Authorizer does not recognized the kind value, the Authorizer should report an error.",
             "type": "string"
            },
            "name": {
             "description": "Name of the object being referenced.",
             "type": "string"
            },
            "namespace": {
             "description": "Namespace of the referenced object.  If the object kind is non-namespace, such as \"User\" or \"Group\", and this value is not empty\nthe Authorizer should report an error.",
             "type": "string"
            }
           },
           "x-kubernetes-map-type": "atomic"
          }
         }
        }
       }
      },
      "subresources": {},
      "additionalPrinterColumns": [
       {
        "name": "Workspace",
        "type": "string",
        "jsonPath": ".metadata.labels.kubesphere\\.io/workspace"
       }
      ]
     },
     {
      "name": "v1beta1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "WorkspaceRoleBinding is the Schema for the workspacerolebindings API",
        "type": "object",
        "required": [
         "roleRef"
        ],
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "roleRef": {
          "description": "RoleRef can only reference a WorkspaceRole.\nIf the RoleRef cannot be resolved, the Authorizer must return an error.",
          "type": "object",
          "required": [
           "apiGroup",
           "kind",
           "name"
          ],
          "properties": {
           "apiGroup": {
            "description": "APIGroup is the group for the resource being referenced",
            "type": "string"
           },
           "kind": {
            "description": "Kind is the type of resource being referenced",
            "type": "string"
           },
           "name": {
            "description": "Name is the name of resource being referenced",
            "type": "string"
           }
          },
          "x-kubernetes-map-type": "atomic"
         },
         "subjects": {
          "description": "Subjects holds references to the objects the role applies to.",
          "type": "array",
          "items": {
           "description": "Subject contains a reference to the object or user identities a role binding applies to.  This can either hold a direct API object reference,\nor a value for non-objects such as user and group names.",
           "type": "object",
           "required": [
            "kind",
            "name"
           ],
           "properties": {
            "apiGroup": {
             "description": "APIGroup holds the API group of the referenced subject.\nDefaults to \"\" for ServiceAccount subjects.\nDefaults to \"rbac.authorization.k8s.io\" for User and Group subjects.",
             "type": "string"
            },
            "kind": {
             "description": "Kind of object being referenced. Values defined by this API group are \"User\", \"Group\", and \"ServiceAccount\".\nIf the Authorizer does not recognized the kind value, the Authorizer should report an error.",
             "type": "string"
            },
            "name": {
             "description": "Name of the object being referenced.",
             "type": "string"
            },
            "namespace": {
             "description": "Namespace of the referenced object.  If the object kind is non-namespace, such as \"User\" or \"Group\", and this value is not empty\nthe Authorizer should report an error.",
             "type": "string"
            }
           },
           "x-kubernetes-map-type": "atomic"
          }
         }
        }
       }
      },
      "subresources": {},
      "additionalPrinterColumns": [
       {
        "name": "Workspace",
        "type": "string",
        "jsonPath": ".metadata.labels.kubesphere\\.io/workspace"
       }
      ]
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "workspacerolebindings",
     "singular": "workspacerolebinding",
     "kind": "WorkspaceRoleBinding",
     "listKind": "WorkspaceRoleBindingList",
     "categories": [
      "iam"
     ]
    },
    "storedVersions": [
     "v1beta1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "users.iam.kubesphere.io",
    "uid": "94eb8008-0106-44f2-a0fb-328e2876cf21",
    "resourceVersion": "1798",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "iam.kubesphere.io",
    "names": {
     "plural": "users",
     "singular": "user",
     "kind": "User",
     "listKind": "UserList",
     "categories": [
      "iam"
     ]
    },
    "scope": "Cluster",
    "versions": [
     {
      "name": "v1alpha2",
      "served": true,
      "storage": false,
      "deprecated": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "User is the Schema for the users API",
        "type": "object",
        "required": [
         "spec"
        ],
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "description": "UserSpec defines the desired state of User",
          "type": "object",
          "required": [
           "email"
          ],
          "properties": {
           "description": {
            "description": "Description of the user.",
            "type": "string"
           },
           "displayName": {
            "type": "string"
           },
           "email": {
            "description": "Unique email address(https://www.ietf.org/rfc/rfc5322.txt).",
            "type": "string"
           },
           "groups": {
            "type": "array",
            "items": {
             "type": "string"
            }
           },
           "lang": {
            "description": "The preferred written or spoken language for the user.",
            "type": "string"
           },
           "password": {
            "description": "password will be encrypted by mutating admission webhook\nPassword pattern is tricky here.\nThe rule is simple: length between [6,64], at least one uppercase letter, one lowercase letter, one digit.\nThe regexp in console(javascript) is quite straightforward: ^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[^]{6,64}$\nBut in Go, we don't have ?= (back tracking) capability in regexp (also in CRD validation pattern)\nSo we adopted an alternative scheme to achieve.\nUse 6 different regexp to combine to achieve the same effect.\nThese six schemes enumerate the arrangement of numbers, uppercase letters, and lowercase letters that appear for the first time.\n- ^(.*[a-z].*[A-Z].*[0-9].*)$ stands for lowercase letter comes first, then followed by an uppercase letter, then a digit.\n- ^(.*[a-z].*[0-9].*[A-Z].*)$ stands for lowercase letter comes first, then followed by a digit, then an uppercase leeter.\n- ^(.*[A-Z].*[a-z].*[0-9].*)$ ...\n- ^(.*[A-Z].*[0-9].*[a-z].*)$ ...\n- ^(.*[0-9].*[a-z].*[A-Z].*)$ ...\n- ^(.*[0-9].*[A-Z].*[a-z].*)$ ...\nLast but not least, the bcrypt string is also included to match the encrypted password. ^(\\$2[ayb]\\$.{56})$",
            "type": "string",
            "maxLength": 64,
            "minLength": 8,
            "pattern": "^(.*[a-z].*[A-Z].*[0-9].*)$|^(.*[a-z].*[0-9].*[A-Z].*)$|^(.*[A-Z].*[a-z].*[0-9].*)$|^(.*[A-Z].*[0-9].*[a-z].*)$|^(.*[0-9].*[a-z].*[A-Z].*)$|^(.*[0-9].*[A-Z].*[a-z].*)$|^(\\$2[ayb]\\$.{56})$"
           }
          }
         },
         "status": {
          "description": "UserStatus defines the observed state of User",
          "type": "object",
          "properties": {
           "lastLoginTime": {
            "description": "Last login attempt timestamp",
            "type": "string",
            "format": "date-time"
           },
           "lastTransitionTime": {
            "type": "string",
            "format": "date-time"
           },
           "reason": {
            "type": "string"
           },
           "state": {
            "description": "The user status",
            "type": "string"
           }
          }
         }
        }
       }
      },
      "subresources": {},
      "additionalPrinterColumns": [
       {
        "name": "Email",
        "type": "string",
        "jsonPath": ".spec.email"
       },
       {
        "name": "Status",
        "type": "string",
        "jsonPath": ".status.state"
       }
      ]
     },
     {
      "name": "v1beta1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "User is the Schema for the users API",
        "type": "object",
        "required": [
         "spec"
        ],
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "description": "UserSpec defines the desired state of User",
          "type": "object",
          "required": [
           "email"
          ],
          "properties": {
           "description": {
            "description": "Description of the user.",
            "type": "string"
           },
           "displayName": {
            "type": "string"
           },
           "email": {
            "description": "Unique email address(https://www.ietf.org/rfc/rfc5322.txt).",
            "type": "string"
           },
           "groups": {
            "type": "array",
            "items": {
             "type": "string"
            }
           },
           "lang": {
            "description": "The preferred written or spoken language for the user.",
            "type": "string"
           },
           "password": {
            "description": "password will be encrypted by mutating admission webhook\nPassword pattern is tricky here.\nThe rule is simple: length between [6,64], at least one uppercase letter, one lowercase letter, one digit.\nThe regexp in console(javascript) is quite straightforward: ^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[^]{6,64}$\nBut in Go, we don't have ?= (back tracking) capability in regexp (also in CRD validation pattern)\nSo we adopted an alternative scheme to achieve.\nUse 6 different regexp to combine to achieve the same effect.\nThese six schemes enumerate the arrangement of numbers, uppercase letters, and lowercase letters that appear for the first time.\n- ^(.*[a-z].*[A-Z].*[0-9].*)$ stands for lowercase letter comes first, then followed by an uppercase letter, then a digit.\n- ^(.*[a-z].*[0-9].*[A-Z].*)$ stands for lowercase letter comes first, then followed by a digit, then an uppercase leeter.\n- ^(.*[A-Z].*[a-z].*[0-9].*)$ ...\n- ^(.*[A-Z].*[0-9].*[a-z].*)$ ...\n- ^(.*[0-9].*[a-z].*[A-Z].*)$ ...\n- ^(.*[0-9].*[A-Z].*[a-z].*)$ ...\nLast but not least, the bcrypt string is also included to match the encrypted password. ^(\\$2[ayb]\\$.{56})$",
            "type": "string",
            "maxLength": 64,
            "minLength": 8,
            "pattern": "^(.*[a-z].*[A-Z].*[0-9].*)$|^(.*[a-z].*[0-9].*[A-Z].*)$|^(.*[A-Z].*[a-z].*[0-9].*)$|^(.*[A-Z].*[0-9].*[a-z].*)$|^(.*[0-9].*[a-z].*[A-Z].*)$|^(.*[0-9].*[A-Z].*[a-z].*)$|^(\\$2[ayb]\\$.{56})$"
           }
          }
         },
         "status": {
          "description": "UserStatus defines the observed state of User",
          "type": "object",
          "properties": {
           "lastLoginTime": {
            "description": "Last login attempt timestamp",
            "type": "string",
            "format": "date-time"
           },
           "lastTransitionTime": {
            "type": "string",
            "format": "date-time"
           },
           "reason": {
            "type": "string"
           },
           "state": {
            "description": "The user status",
            "type": "string"
           }
          }
         }
        }
       }
      },
      "subresources": {},
      "additionalPrinterColumns": [
       {
        "name": "Email",
        "type": "string",
        "jsonPath": ".spec.email"
       },
       {
        "name": "Status",
        "type": "string",
        "jsonPath": ".status.state"
       }
      ]
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "users",
     "singular": "user",
     "kind": "User",
     "listKind": "UserList",
     "categories": [
      "iam"
     ]
    },
    "storedVersions": [
     "v1beta1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "subscriptions.marketplace.kubesphere.io",
    "uid": "8290f1eb-451b-49cf-bdcd-0f0b22346280",
    "resourceVersion": "1826",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "marketplace.kubesphere.io",
    "names": {
     "plural": "subscriptions",
     "singular": "subscription",
     "kind": "Subscription",
     "listKind": "SubscriptionList",
     "categories": [
      "marketplace"
     ]
    },
    "scope": "Cluster",
    "versions": [
     {
      "name": "v1alpha1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "type": "object",
        "required": [
         "spec"
        ],
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "type": "object",
          "required": [
           "extensionName"
          ],
          "properties": {
           "extensionName": {
            "type": "string"
           }
          }
         },
         "status": {
          "type": "object",
          "required": [
           "createdAt",
           "expiredAt",
           "extensionID",
           "extraInfo",
           "orderID",
           "startedAt",
           "subscriptionID",
           "updatedAt",
           "userID",
           "userSubscriptionID"
          ],
          "properties": {
           "createdAt": {
            "type": "string",
            "format": "date-time"
           },
           "expiredAt": {
            "type": "string",
            "format": "date-time"
           },
           "extensionID": {
            "type": "string"
           },
           "extraInfo": {
            "type": "string"
           },
           "orderID": {
            "type": "string"
           },
           "startedAt": {
            "type": "string",
            "format": "date-time"
           },
           "subscriptionID": {
            "type": "string"
           },
           "updatedAt": {
            "type": "string",
            "format": "date-time"
           },
           "userID": {
            "type": "string"
           },
           "userSubscriptionID": {
            "type": "string"
           }
          }
         }
        }
       }
      }
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "subscriptions",
     "singular": "subscription",
     "kind": "Subscription",
     "listKind": "SubscriptionList",
     "categories": [
      "marketplace"
     ]
    },
    "storedVersions": [
     "v1alpha1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "storageclasscapabilities.storage.kubesphere.io",
    "uid": "c080e625-57d8-43ef-842c-61771a78cbbe",
    "resourceVersion": "1837",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "storage.kubesphere.io",
    "names": {
     "plural": "storageclasscapabilities",
     "singular": "storageclasscapability",
     "kind": "StorageClassCapability",
     "listKind": "StorageClassCapabilityList"
    },
    "scope": "Cluster",
    "versions": [
     {
      "name": "v1alpha1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "StorageClassCapability is the Schema for the storage class capability API",
        "type": "object",
        "required": [
         "spec"
        ],
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "description": "StorageClassCapabilitySpec defines the desired state of StorageClassCapability",
          "type": "object",
          "required": [
           "features",
           "provisioner"
          ],
          "properties": {
           "features": {
            "description": "CapabilityFeatures describe storage features",
            "type": "object",
            "required": [
             "snapshot",
             "topology",
             "volume"
            ],
            "properties": {
             "snapshot": {
              "description": "SnapshotFeature describe snapshot features",
              "type": "object",
              "required": [
               "create",
               "list"
              ],
              "properties": {
               "create": {
                "type": "boolean"
               },
               "list": {
                "type": "boolean"
               }
              }
             },
             "topology": {
              "type": "boolean"
             },
             "volume": {
              "description": "VolumeFeature describe volume features",
              "type": "object",
              "required": [
               "attach",
               "clone",
               "create",
               "expandMode",
               "list",
               "stats"
              ],
              "properties": {
               "attach": {
                "type": "boolean"
               },
               "clone": {
                "type": "boolean"
               },
               "create": {
                "type": "boolean"
               },
               "expandMode": {
                "type": "string"
               },
               "list": {
                "type": "boolean"
               },
               "stats": {
                "type": "boolean"
               }
              }
             }
            }
           },
           "provisioner": {
            "type": "string"
           }
          }
         }
        }
       }
      },
      "subresources": {},
      "additionalPrinterColumns": [
       {
        "name": "Provisioner",
        "type": "string",
        "jsonPath": ".spec.provisioner"
       },
       {
        "name": "Volume",
        "type": "boolean",
        "jsonPath": ".spec.features.volume.create"
       },
       {
        "name": "Expand",
        "type": "string",
        "jsonPath": ".spec.features.volume.expandMode"
       },
       {
        "name": "Clone",
        "type": "boolean",
        "jsonPath": ".spec.features.volume.clone"
       },
       {
        "name": "Snapshot",
        "type": "boolean",
        "jsonPath": ".spec.features.snapshot.create"
       },
       {
        "name": "Age",
        "type": "date",
        "jsonPath": ".metadata.creationTimestamp"
       }
      ]
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "storageclasscapabilities",
     "singular": "storageclasscapability",
     "kind": "StorageClassCapability",
     "listKind": "StorageClassCapabilityList"
    },
    "storedVersions": [
     "v1alpha1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "serviceaccounts.kubesphere.io",
    "uid": "a1c950ca-90ae-4fe8-b955-8192084a9490",
    "resourceVersion": "1823",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "kubesphere.io",
    "names": {
     "plural": "serviceaccounts",
     "singular": "serviceaccount",
     "kind": "ServiceAccount",
     "listKind": "ServiceAccountList"
    },
    "scope": "Namespaced",
    "versions": [
     {
      "name": "v1alpha1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "type": "object",
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "secrets": {
          "type": "array",
          "items": {
           "description": "ObjectReference contains enough information to let you inspect or modify the referred object.\n---\nNew uses of this type are discouraged because of difficulty describing its usage when embedded in APIs.\n 1. Ignored fields.  It includes many fields which are not generally honored.  For instance, ResourceVersion and FieldPath are both very rarely valid in actual usage.\n 2. Invalid usage help.  It is impossible to add specific help for individual usage.  In most embedded usages, there are particular\n    restrictions like, \"must refer only to types A and B\" or \"UID not honored\" or \"name must be restricted\".\n    Those cannot be well described when embedded.\n 3. Inconsistent validation.  Because the usages are different, the validation rules are different by usage, which makes it hard for users to predict what will happen.\n 4. The fields are both imprecise and overly precise.  Kind is not a precise mapping to a URL. This can produce ambiguity\n    during interpretation and require a REST mapping.  In most cases, the dependency is on the group,resource tuple\n    and the version of the actual struct is irrelevant.\n 5. We cannot easily change it.  Because this type is embedded in many locations, updates to this type\n    will affect numerous schemas.  Don't make new APIs embed an underspecified API type they do not control.\n\n\nInstead of using this type, create a locally provided and used type that is well-focused on your reference.\nFor example, ServiceReferences for admission registration: https://github.com/kubernetes/api/blob/release-1.17/admissionregistration/v1/types.go#L533 .",
           "type": "object",
           "properties": {
            "apiVersion": {
             "description": "API version of the referent.",
             "type": "string"
            },
            "fieldPath": {
             "description": "If referring to a piece of an object instead of an entire object, this string\nshould contain a valid JSON/Go field access statement, such as desiredState.manifest.containers[2].\nFor example, if the object reference is to a container within a pod, this would take on a value like:\n\"spec.containers{name}\" (where \"name\" refers to the name of the container that triggered\nthe event) or if no container name is specified \"spec.containers[2]\" (container with\nindex 2 in this pod). This syntax is chosen only to have some well-defined way of\nreferencing a part of an object.\nTODO: this design is not final and this field is subject to change in the future.",
             "type": "string"
            },
            "kind": {
             "description": "Kind of the referent.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
             "type": "string"
            },
            "name": {
             "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names",
             "type": "string"
            },
            "namespace": {
             "description": "Namespace of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/",
             "type": "string"
            },
            "resourceVersion": {
             "description": "Specific resourceVersion to which this reference is made, if any.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency",
             "type": "string"
            },
            "uid": {
             "description": "UID of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#uids",
             "type": "string"
            }
           },
           "x-kubernetes-map-type": "atomic"
          }
         }
        }
       }
      }
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "serviceaccounts",
     "singular": "serviceaccount",
     "kind": "ServiceAccount",
     "listKind": "ServiceAccountList"
    },
    "storedVersions": [
     "v1alpha1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "roletemplates.iam.kubesphere.io",
    "uid": "55fd9b5f-1ef8-451b-b451-b0329d4571f5",
    "resourceVersion": "1794",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "iam.kubesphere.io",
    "names": {
     "plural": "roletemplates",
     "singular": "roletemplate",
     "kind": "RoleTemplate",
     "listKind": "RoleTemplateList",
     "categories": [
      "iam"
     ]
    },
    "scope": "Cluster",
    "versions": [
     {
      "name": "v1beta1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "RoleTemplate is the Schema for the roletemplates API",
        "type": "object",
        "properties": {
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "spec": {
          "description": "RoleTemplateSpec defines the desired state of RoleTemplate",
          "type": "object",
          "required": [
           "rules"
          ],
          "properties": {
           "description": {
            "type": "object",
            "additionalProperties": {
             "type": "string"
            }
           },
           "displayName": {
            "description": "DisplayName represent the name displays at console, this field",
            "type": "object",
            "additionalProperties": {
             "type": "string"
            }
           },
           "rules": {
            "type": "array",
            "items": {
             "description": "PolicyRule holds information that describes a policy rule, but does not contain information\nabout who the rule applies to or which namespace the rule applies to.",
             "type": "object",
             "required": [
              "verbs"
             ],
             "properties": {
              "apiGroups": {
               "description": "APIGroups is the name of the APIGroup that contains the resources.  If multiple API groups are specified, any action requested against one of\nthe enumerated resources in any API group will be allowed. \"\" represents the core API group and \"*\" represents all API groups.",
               "type": "array",
               "items": {
                "type": "string"
               }
              },
              "nonResourceURLs": {
               "description": "NonResourceURLs is a set of partial urls that a user should have access to.  *s are allowed, but only as the full, final step in the path\nSince non-resource URLs are not namespaced, this field is only applicable for ClusterRoles referenced from a ClusterRoleBinding.\nRules can either apply to API resources (such as \"pods\" or \"secrets\") or non-resource URL paths (such as \"/api\"),  but not both.",
               "type": "array",
               "items": {
                "type": "string"
               }
              },
              "resourceNames": {
               "description": "ResourceNames is an optional white list of names that the rule applies to.  An empty set means that everything is allowed.",
               "type": "array",
               "items": {
                "type": "string"
               }
              },
              "resources": {
               "description": "Resources is a list of resources this rule applies to. '*' represents all resources.",
               "type": "array",
               "items": {
                "type": "string"
               }
              },
              "verbs": {
               "description": "Verbs is a list of Verbs that apply to ALL the ResourceKinds contained in this rule. '*' represents all verbs.",
               "type": "array",
               "items": {
                "type": "string"
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "roletemplates",
     "singular": "roletemplate",
     "kind": "RoleTemplate",
     "listKind": "RoleTemplateList",
     "categories": [
      "iam"
     ]
    },
    "storedVersions": [
     "v1beta1"
    ]
   }
  },
  {
   "kind": "CustomResourceDefinition",
   "apiVersion": "apiextensions.k8s.io/v1",
   "metadata": {
    "name": "roles.iam.kubesphere.io",
    "uid": "9fd6037c-dd47-4963-970d-5574e1b5a800",
    "resourceVersion": "1791",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
     "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:controller-gen.kubebuilder.io/version": {}
        }
       },
       "f:spec": {
        "f:conversion": {
         ".": {},
         "f:strategy": {}
        },
        "f:group": {},
        "f:names": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:scope": {},
        "f:versions": {}
       }
      }
     },
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "apiextensions.k8s.io/v1",
      "time": "2024-07-09T07:00:26Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:acceptedNames": {
         "f:categories": {},
         "f:kind": {},
         "f:listKind": {},
         "f:plural": {},
         "f:singular": {}
        },
        "f:conditions": {
         "k:{\"type\":\"Established\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"NamesAccepted\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        }
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "group": "iam.kubesphere.io",
    "names": {
     "plural": "roles",
     "singular": "role",
     "kind": "Role",
     "listKind": "RoleList",
     "categories": [
      "iam"
     ]
    },
    "scope": "Namespaced",
    "versions": [
     {
      "name": "v1beta1",
      "served": true,
      "storage": true,
      "schema": {
       "openAPIV3Schema": {
        "description": "Role is the Schema for the roles API",
        "type": "object",
        "properties": {
         "aggregationRoleTemplates": {
          "description": "AggregationRoleTemplates means which RoleTemplates are composed this Role",
          "type": "object",
          "properties": {
           "roleSelector": {
            "description": "RoleSelectors select rules from RoleTemplate`s rules by labels",
            "type": "object",
            "properties": {
             "matchExpressions": {
              "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
              "type": "array",
              "items": {
               "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
               "type": "object",
               "required": [
                "key",
                "operator"
               ],
               "properties": {
                "key": {
                 "description": "key is the label key that the selector applies to.",
                 "type": "string"
                },
                "operator": {
                 "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                 "type": "string"
                },
                "values": {
                 "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                 "type": "array",
                 "items": {
                  "type": "string"
                 }
                }
               }
              }
             },
             "matchLabels": {
              "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
              "type": "object",
              "additionalProperties": {
               "type": "string"
              }
             }
            },
            "x-kubernetes-map-type": "atomic"
           },
           "templateNames": {
            "description": "TemplateNames select rules from RoleTemplate`s rules by RoleTemplate name",
            "type": "array",
            "items": {
             "type": "string"
            },
            "x-kubernetes-list-type": "set"
           }
          }
         },
         "apiVersion": {
          "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
          "type": "string"
         },
         "kind": {
          "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
          "type": "string"
         },
         "metadata": {
          "type": "object"
         },
         "rules": {
          "description": "Rules holds all the PolicyRules for this WorkspaceRole",
          "type": "array",
          "items": {
           "description": "PolicyRule holds information that describes a policy rule, but does not contain information\nabout who the rule applies to or which namespace the rule applies to.",
           "type": "object",
           "required": [
            "verbs"
           ],
           "properties": {
            "apiGroups": {
             "description": "APIGroups is the name of the APIGroup that contains the resources.  If multiple API groups are specified, any action requested against one of\nthe enumerated resources in any API group will be allowed. \"\" represents the core API group and \"*\" represents all API groups.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "nonResourceURLs": {
             "description": "NonResourceURLs is a set of partial urls that a user should have access to.  *s are allowed, but only as the full, final step in the path\nSince non-resource URLs are not namespaced, this field is only applicable for ClusterRoles referenced from a ClusterRoleBinding.\nRules can either apply to API resources (such as \"pods\" or \"secrets\") or non-resource URL paths (such as \"/api\"),  but not both.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "resourceNames": {
             "description": "ResourceNames is an optional white list of names that the rule applies to.  An empty set means that everything is allowed.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "resources": {
             "description": "Resources is a list of resources this rule applies to. '*' represents all resources.",
             "type": "array",
             "items": {
              "type": "string"
             }
            },
            "verbs": {
             "description": "Verbs is a list of Verbs that apply to ALL the ResourceKinds contained in this rule. '*' represents all verbs.",
             "type": "array",
             "items": {
              "type": "string"
             }
            }
           }
          }
         }
        }
       }
      }
     }
    ],
    "conversion": {
     "strategy": "None"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "NamesAccepted",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "NoConflicts",
      "message": "no conflicts found"
     },
     {
      "type": "Established",
      "status": "True",
      "lastTransitionTime": "2024-07-09T07:00:26Z",
      "reason": "InitialNamesAccepted",
      "message": "the initial names have been accepted"
     }
    ],
    "acceptedNames": {
     "plural": "roles",
     "singular": "role",
     "kind": "Role",
     "listKind": "RoleList",
     "categories": [
      "iam"
     ]
    },
    "storedVersions": [
     "v1beta1"
    ]
   }
  }
 ],
 "totalItems": 58
}
```

https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/apis/apiextensions.k8s.io/v1/customresourcedefinitions/workspacerolebindings.iam.kubesphere.io
```json
{
  "kind": "CustomResourceDefinition",
  "apiVersion": "apiextensions.k8s.io/v1",
  "metadata": {
    "name": "workspacerolebindings.iam.kubesphere.io",
    "uid": "831dd6fd-b933-4dc8-b2b0-ebdf4e34f913",
    "resourceVersion": "1800",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:26Z",
    "annotations": {
      "controller-gen.kubebuilder.io/version": "(unknown)"
    },
    "managedFields": [
      {
        "manager": "helm",
        "operation": "Update",
        "apiVersion": "apiextensions.k8s.io/v1",
        "time": "2024-07-09T07:00:26Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:annotations": {
              ".": {},
              "f:controller-gen.kubebuilder.io/version": {}
            }
          },
          "f:spec": {
            "f:conversion": {
              ".": {},
              "f:strategy": {}
            },
            "f:group": {},
            "f:names": {
              "f:categories": {},
              "f:kind": {},
              "f:listKind": {},
              "f:plural": {},
              "f:singular": {}
            },
            "f:scope": {},
            "f:versions": {}
          }
        }
      },
      {
        "manager": "kube-apiserver",
        "operation": "Update",
        "apiVersion": "apiextensions.k8s.io/v1",
        "time": "2024-07-09T07:00:26Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:status": {
            "f:acceptedNames": {
              "f:categories": {},
              "f:kind": {},
              "f:listKind": {},
              "f:plural": {},
              "f:singular": {}
            },
            "f:conditions": {
              "k:{\"type\":\"Established\"}": {
                ".": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {},
                "f:type": {}
              },
              "k:{\"type\":\"NamesAccepted\"}": {
                ".": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {},
                "f:type": {}
              }
            }
          }
        },
        "subresource": "status"
      }
    ]
  },
  "spec": {
    "group": "iam.kubesphere.io",
    "names": {
      "plural": "workspacerolebindings",
      "singular": "workspacerolebinding",
      "kind": "WorkspaceRoleBinding",
      "listKind": "WorkspaceRoleBindingList",
      "categories": [
        "iam"
      ]
    },
    "scope": "Cluster",
    "versions": [
      {
        "name": "v1alpha2",
        "served": true,
        "storage": false,
        "deprecated": true,
        "schema": {
          "openAPIV3Schema": {
            "description": "WorkspaceRoleBinding is the Schema for the workspacerolebindings API",
            "type": "object",
            "required": [
              "roleRef"
            ],
            "properties": {
              "apiVersion": {
                "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
                "type": "string"
              },
              "kind": {
                "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
                "type": "string"
              },
              "metadata": {
                "type": "object"
              },
              "roleRef": {
                "description": "RoleRef can only reference a WorkspaceRole.\nIf the RoleRef cannot be resolved, the Authorizer must return an error.",
                "type": "object",
                "required": [
                  "apiGroup",
                  "kind",
                  "name"
                ],
                "properties": {
                  "apiGroup": {
                    "description": "APIGroup is the group for the resource being referenced",
                    "type": "string"
                  },
                  "kind": {
                    "description": "Kind is the type of resource being referenced",
                    "type": "string"
                  },
                  "name": {
                    "description": "Name is the name of resource being referenced",
                    "type": "string"
                  }
                },
                "x-kubernetes-map-type": "atomic"
              },
              "subjects": {
                "description": "Subjects holds references to the objects the role applies to.",
                "type": "array",
                "items": {
                  "description": "Subject contains a reference to the object or user identities a role binding applies to.  This can either hold a direct API object reference,\nor a value for non-objects such as user and group names.",
                  "type": "object",
                  "required": [
                    "kind",
                    "name"
                  ],
                  "properties": {
                    "apiGroup": {
                      "description": "APIGroup holds the API group of the referenced subject.\nDefaults to \"\" for ServiceAccount subjects.\nDefaults to \"rbac.authorization.k8s.io\" for User and Group subjects.",
                      "type": "string"
                    },
                    "kind": {
                      "description": "Kind of object being referenced. Values defined by this API group are \"User\", \"Group\", and \"ServiceAccount\".\nIf the Authorizer does not recognized the kind value, the Authorizer should report an error.",
                      "type": "string"
                    },
                    "name": {
                      "description": "Name of the object being referenced.",
                      "type": "string"
                    },
                    "namespace": {
                      "description": "Namespace of the referenced object.  If the object kind is non-namespace, such as \"User\" or \"Group\", and this value is not empty\nthe Authorizer should report an error.",
                      "type": "string"
                    }
                  },
                  "x-kubernetes-map-type": "atomic"
                }
              }
            }
          }
        },
        "subresources": {},
        "additionalPrinterColumns": [
          {
            "name": "Workspace",
            "type": "string",
            "jsonPath": ".metadata.labels.kubesphere\\.io/workspace"
          }
        ]
      },
      {
        "name": "v1beta1",
        "served": true,
        "storage": true,
        "schema": {
          "openAPIV3Schema": {
            "description": "WorkspaceRoleBinding is the Schema for the workspacerolebindings API",
            "type": "object",
            "required": [
              "roleRef"
            ],
            "properties": {
              "apiVersion": {
                "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
                "type": "string"
              },
              "kind": {
                "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
                "type": "string"
              },
              "metadata": {
                "type": "object"
              },
              "roleRef": {
                "description": "RoleRef can only reference a WorkspaceRole.\nIf the RoleRef cannot be resolved, the Authorizer must return an error.",
                "type": "object",
                "required": [
                  "apiGroup",
                  "kind",
                  "name"
                ],
                "properties": {
                  "apiGroup": {
                    "description": "APIGroup is the group for the resource being referenced",
                    "type": "string"
                  },
                  "kind": {
                    "description": "Kind is the type of resource being referenced",
                    "type": "string"
                  },
                  "name": {
                    "description": "Name is the name of resource being referenced",
                    "type": "string"
                  }
                },
                "x-kubernetes-map-type": "atomic"
              },
              "subjects": {
                "description": "Subjects holds references to the objects the role applies to.",
                "type": "array",
                "items": {
                  "description": "Subject contains a reference to the object or user identities a role binding applies to.  This can either hold a direct API object reference,\nor a value for non-objects such as user and group names.",
                  "type": "object",
                  "required": [
                    "kind",
                    "name"
                  ],
                  "properties": {
                    "apiGroup": {
                      "description": "APIGroup holds the API group of the referenced subject.\nDefaults to \"\" for ServiceAccount subjects.\nDefaults to \"rbac.authorization.k8s.io\" for User and Group subjects.",
                      "type": "string"
                    },
                    "kind": {
                      "description": "Kind of object being referenced. Values defined by this API group are \"User\", \"Group\", and \"ServiceAccount\".\nIf the Authorizer does not recognized the kind value, the Authorizer should report an error.",
                      "type": "string"
                    },
                    "name": {
                      "description": "Name of the object being referenced.",
                      "type": "string"
                    },
                    "namespace": {
                      "description": "Namespace of the referenced object.  If the object kind is non-namespace, such as \"User\" or \"Group\", and this value is not empty\nthe Authorizer should report an error.",
                      "type": "string"
                    }
                  },
                  "x-kubernetes-map-type": "atomic"
                }
              }
            }
          }
        },
        "subresources": {},
        "additionalPrinterColumns": [
          {
            "name": "Workspace",
            "type": "string",
            "jsonPath": ".metadata.labels.kubesphere\\.io/workspace"
          }
        ]
      }
    ],
    "conversion": {
      "strategy": "None"
    }
  },
  "status": {
    "conditions": [
      {
        "type": "NamesAccepted",
        "status": "True",
        "lastTransitionTime": "2024-07-09T07:00:26Z",
        "reason": "NoConflicts",
        "message": "no conflicts found"
      },
      {
        "type": "Established",
        "status": "True",
        "lastTransitionTime": "2024-07-09T07:00:26Z",
        "reason": "InitialNamesAccepted",
        "message": "the initial names have been accepted"
      }
    ],
    "acceptedNames": {
      "plural": "workspacerolebindings",
      "singular": "workspacerolebinding",
      "kind": "WorkspaceRoleBinding",
      "listKind": "WorkspaceRoleBindingList",
      "categories": [
        "iam"
      ]
    },
    "storedVersions": [
      "v1beta1"
    ]
  }
}

```

