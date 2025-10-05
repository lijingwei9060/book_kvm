/api/v2.0/projects/casoul/repositories/postgrest%252Fpostgrest/artifacts/sha256:be3b6ab31a94e3e89f08edad40be0234ae0951e3297f2043d797c219165f5afa/tags?page_size=8&page=1
```json
[
    {
        "artifact_id": 1,
        "id": 1,
        "immutable": false,
        "name": "v12.2.12",
        "pull_time": "0001-01-01T00:00:00.000Z",
        "push_time": "2025-07-17T04:16:48.320Z",
        "repository_id": 1
    }
]
```

/api/v2.0/projects/casoul/repositories/postgrest%252Fpostgrest/artifacts?with_tag=false&with_scan_overview=true&with_sbom_overview=true&with_label=true&with_accessory=false&page_size=15&page=1
```json
[
    {
        "accessories": null,
        "addition_links": {
            "build_history": {
                "absolute": false,
                "href": "/api/v2.0/projects/casoul/repositories/postgrest%252Fpostgrest/artifacts/sha256:be3b6ab31a94e3e89f08edad40be0234ae0951e3297f2043d797c219165f5afa/additions/build_history"
            }
        },
        "artifact_type": "application/vnd.docker.container.image.v1+json",
        "digest": "sha256:be3b6ab31a94e3e89f08edad40be0234ae0951e3297f2043d797c219165f5afa",
        "extra_attrs": {
            "architecture": "amd64",
            "author": "",
            "config": {
                "Cmd": [
                    "/bin/postgrest"
                ],
                "ExposedPorts": {
                    "3000/tcp": {}
                },
                "User": "1000"
            },
            "created": "2024-11-06T17:47:05Z",
            "os": "linux"
        },
        "icon": "sha256:0048162a053eef4d4ce3fe7518615bef084403614f8bca43b40ae2e762e11e06",
        "id": 1,
        "labels": null,
        "manifest_media_type": "application/vnd.docker.distribution.manifest.v2+json",
        "media_type": "application/vnd.docker.container.image.v1+json",
        "project_id": 2,
        "pull_time": "0001-01-01T00:00:00.000Z",
        "push_time": "2025-07-17T04:16:48.294Z",
        "references": null,
        "repository_id": 1,
        "repository_name": "casoul/postgrest/postgrest",
        "size": 5320231,
        "tags": null,
        "type": "IMAGE"
    }
]
```

/api/v2.0/projects/2/members?page_size=15&page=1&entityname=
```json
[
    {
        "entity_id": 1,
        "entity_name": "admin",
        "entity_type": "u",
        "id": 2,
        "project_id": 2,
        "role_id": 1,
        "role_name": "projectAdmin"
    }
]
```

/api/v2.0/projects/casoul/repositories?page_size=15&page=1
```json
[
    {
        "artifact_count": 1,
        "creation_time": "2025-07-17T04:16:48.259Z",
        "id": 1,
        "name": "casoul/postgrest/postgrest",
        "project_id": 2,
        "pull_count": 0,
        "update_time": "2025-07-17T04:16:48.259Z"
    }
]
```

/api/v2.0/systeminfo
```json
{
    "auth_mode": "db_auth",
    "banner_message": "",
    "current_time": "2025-07-17T07:50:39.530Z",
    "external_url": "https://10.16.161.21.nip.io",
    "harbor_version": "v2.13.1-9384ed0e",
    "has_ca_root": false,
    "notification_enable": true,
    "oidc_provider_name": "",
    "primary_auth_mode": false,
    "project_creation_restriction": "everyone",
    "read_only": false,
    "registry_storage_provider_name": "filesystem",
    "registry_url": "10.16.161.21.nip.io",
    "self_registration": false
}
```

/api/v2.0/projects/2/summary
```json
{
    "project_admin_count": 1,
    "quota": {
        "hard": {
            "storage": -1
        },
        "used": {
            "storage": 5320231
        }
    },
    "repo_count": 1
}
```
/api/v2.0/users/current/permissions?scope=/project/2&relative=true
```json
[
    {
        "action": "read",
        "resource": "."
    },
    {
        "action": "update",
        "resource": "."
    },
    {
        "action": "delete",
        "resource": "."
    },
    {
        "action": "create",
        "resource": "member"
    },
    {
        "action": "read",
        "resource": "member"
    },
    {
        "action": "update",
        "resource": "member"
    },
    {
        "action": "delete",
        "resource": "member"
    },
    {
        "action": "list",
        "resource": "member"
    },
    {
        "action": "create",
        "resource": "metadata"
    },
    {
        "action": "read",
        "resource": "metadata"
    },
    {
        "action": "update",
        "resource": "metadata"
    },
    {
        "action": "delete",
        "resource": "metadata"
    },
    {
        "action": "list",
        "resource": "log"
    },
    {
        "action": "create",
        "resource": "label"
    },
    {
        "action": "read",
        "resource": "label"
    },
    {
        "action": "update",
        "resource": "label"
    },
    {
        "action": "delete",
        "resource": "label"
    },
    {
        "action": "list",
        "resource": "label"
    },
    {
        "action": "read",
        "resource": "quota"
    },
    {
        "action": "create",
        "resource": "repository"
    },
    {
        "action": "read",
        "resource": "repository"
    },
    {
        "action": "update",
        "resource": "repository"
    },
    {
        "action": "delete",
        "resource": "repository"
    },
    {
        "action": "list",
        "resource": "repository"
    },
    {
        "action": "pull",
        "resource": "repository"
    },
    {
        "action": "push",
        "resource": "repository"
    },
    {
        "action": "create",
        "resource": "tag-retention"
    },
    {
        "action": "read",
        "resource": "tag-retention"
    },
    {
        "action": "update",
        "resource": "tag-retention"
    },
    {
        "action": "delete",
        "resource": "tag-retention"
    },
    {
        "action": "list",
        "resource": "tag-retention"
    },
    {
        "action": "operate",
        "resource": "tag-retention"
    },
    {
        "action": "create",
        "resource": "immutable-tag"
    },
    {
        "action": "update",
        "resource": "immutable-tag"
    },
    {
        "action": "delete",
        "resource": "immutable-tag"
    },
    {
        "action": "list",
        "resource": "immutable-tag"
    },
    {
        "action": "read",
        "resource": "configuration"
    },
    {
        "action": "update",
        "resource": "configuration"
    },
    {
        "action": "create",
        "resource": "robot"
    },
    {
        "action": "read",
        "resource": "robot"
    },
    {
        "action": "update",
        "resource": "robot"
    },
    {
        "action": "delete",
        "resource": "robot"
    },
    {
        "action": "list",
        "resource": "robot"
    },
    {
        "action": "create",
        "resource": "notification-policy"
    },
    {
        "action": "update",
        "resource": "notification-policy"
    },
    {
        "action": "delete",
        "resource": "notification-policy"
    },
    {
        "action": "list",
        "resource": "notification-policy"
    },
    {
        "action": "read",
        "resource": "notification-policy"
    },
    {
        "action": "create",
        "resource": "scan"
    },
    {
        "action": "read",
        "resource": "scan"
    },
    {
        "action": "stop",
        "resource": "scan"
    },
    {
        "action": "create",
        "resource": "sbom"
    },
    {
        "action": "stop",
        "resource": "sbom"
    },
    {
        "action": "read",
        "resource": "sbom"
    },
    {
        "action": "read",
        "resource": "scanner"
    },
    {
        "action": "create",
        "resource": "scanner"
    },
    {
        "action": "create",
        "resource": "artifact"
    },
    {
        "action": "read",
        "resource": "artifact"
    },
    {
        "action": "delete",
        "resource": "artifact"
    },
    {
        "action": "list",
        "resource": "artifact"
    },
    {
        "action": "read",
        "resource": "artifact-addition"
    },
    {
        "action": "list",
        "resource": "tag"
    },
    {
        "action": "create",
        "resource": "tag"
    },
    {
        "action": "delete",
        "resource": "tag"
    },
    {
        "action": "list",
        "resource": "accessory"
    },
    {
        "action": "create",
        "resource": "artifact-label"
    },
    {
        "action": "delete",
        "resource": "artifact-label"
    },
    {
        "action": "create",
        "resource": "preheat-policy"
    },
    {
        "action": "read",
        "resource": "preheat-policy"
    },
    {
        "action": "update",
        "resource": "preheat-policy"
    },
    {
        "action": "delete",
        "resource": "preheat-policy"
    },
    {
        "action": "list",
        "resource": "preheat-policy"
    },
    {
        "action": "create",
        "resource": "export-cve"
    },
    {
        "action": "read",
        "resource": "export-cve"
    },
    {
        "action": "list",
        "resource": "export-cve"
    }
]
```

/api/v2.0/projects/2
```json
{
    "creation_time": "2025-07-17T04:16:06.008Z",
    "current_user_role_id": 1,
    "current_user_role_ids": [
        1
    ],
    "cve_allowlist": {
        "creation_time": "0001-01-01T00:00:00.000Z",
        "id": 2,
        "items": [],
        "project_id": 2,
        "update_time": "0001-01-01T00:00:00.000Z"
    },
    "metadata": {
        "auto_sbom_generation": "true",
        "auto_scan": "false",
        "enable_content_trust": "false",
        "enable_content_trust_cosign": "false",
        "prevent_vul": "false",
        "public": "true",
        "reuse_sys_cve_allowlist": "true",
        "severity": "low"
    },
    "name": "casoul",
    "owner_id": 1,
    "owner_name": "admin",
    "project_id": 2,
    "repo_count": 1,
    "update_time": "2025-07-17T04:16:06.008Z"
}
```

/api/v2.0/projects?page=1&page_size=15

```json
[
    {
        "creation_time": "2025-07-17T04:16:06.008Z",
        "current_user_role_id": 1,
        "current_user_role_ids": [
            1
        ],
        "cve_allowlist": {
            "creation_time": "0001-01-01T00:00:00.000Z",
            "id": 2,
            "items": [],
            "project_id": 2,
            "update_time": "0001-01-01T00:00:00.000Z"
        },
        "metadata": {
            "auto_sbom_generation": "true",
            "auto_scan": "false",
            "enable_content_trust": "false",
            "enable_content_trust_cosign": "false",
            "prevent_vul": "false",
            "public": "true",
            "reuse_sys_cve_allowlist": "true",
            "severity": "low"
        },
        "name": "casoul",
        "owner_id": 1,
        "owner_name": "admin",
        "project_id": 2,
        "repo_count": 1,
        "update_time": "2025-07-17T04:16:06.008Z"
    },
    {
        "creation_time": "2025-07-17T03:41:01.293Z",
        "current_user_role_id": 1,
        "current_user_role_ids": [
            1
        ],
        "cve_allowlist": {
            "creation_time": "0001-01-01T00:00:00.000Z",
            "id": 1,
            "items": [],
            "project_id": 1,
            "update_time": "0001-01-01T00:00:00.000Z"
        },
        "metadata": {
            "public": "true"
        },
        "name": "library",
        "owner_id": 1,
        "owner_name": "admin",
        "project_id": 1,
        "repo_count": 0,
        "update_time": "2025-07-17T03:41:01.293Z"
    }
]
```

/api/v2.0/registries?q=type%3D%7Bdocker-hub%20harbor%20azure-acr%20ali-acr%20aws-ecr%20google-gcr%20quay%20docker-registry%20github-ghcr%20jfrog-artifactory%7D&page_size=100&page=1

q: type={docker-hub harbor azure-acr ali-acr aws-ecr google-gcr quay docker-registry github-ghcr jfrog-artifactory}
page_size: 100
page: 1
```json
[]
```

/api/v2.0/statistics
```json
{
    "private_project_count": 0,
    "private_repo_count": 0,
    "public_project_count": 2,
    "public_repo_count": 1,
    "total_project_count": 2,
    "total_repo_count": 1,
    "total_storage_consumption": 5320231
}
```
/api/v2.0/configurations

```json
{
    "audit_log_forward_endpoint": {
        "editable": true,
        "value": ""
    },
    "auth_mode": {
        "editable": true,
        "value": "db_auth"
    },
    "banner_message": {
        "editable": true,
        "value": ""
    },
    "disabled_audit_log_event_types": {
        "editable": true,
        "value": ""
    },
    "http_authproxy_admin_groups": {
        "editable": true,
        "value": ""
    },
    "http_authproxy_admin_usernames": {
        "editable": true,
        "value": ""
    },
    "http_authproxy_endpoint": {
        "editable": true,
        "value": ""
    },
    "http_authproxy_server_certificate": {
        "editable": true,
        "value": ""
    },
    "http_authproxy_skip_search": {
        "editable": true,
        "value": false
    },
    "http_authproxy_tokenreview_endpoint": {
        "editable": true,
        "value": ""
    },
    "http_authproxy_verify_cert": {
        "editable": true,
        "value": true
    },
    "ldap_base_dn": {
        "editable": true,
        "value": ""
    },
    "ldap_filter": {
        "editable": true,
        "value": ""
    },
    "ldap_group_admin_dn": {
        "editable": true,
        "value": ""
    },
    "ldap_group_attach_parallel": {
        "editable": true,
        "value": false
    },
    "ldap_group_attribute_name": {
        "editable": true,
        "value": ""
    },
    "ldap_group_base_dn": {
        "editable": true,
        "value": ""
    },
    "ldap_group_membership_attribute": {
        "editable": true,
        "value": "memberof"
    },
    "ldap_group_search_filter": {
        "editable": true,
        "value": ""
    },
    "ldap_group_search_scope": {
        "editable": true,
        "value": 2
    },
    "ldap_scope": {
        "editable": true,
        "value": 2
    },
    "ldap_search_dn": {
        "editable": true,
        "value": ""
    },
    "ldap_timeout": {
        "editable": true,
        "value": 5
    },
    "ldap_uid": {
        "editable": true,
        "value": "cn"
    },
    "ldap_url": {
        "editable": true,
        "value": ""
    },
    "ldap_verify_cert": {
        "editable": true,
        "value": true
    },
    "notification_enable": {
        "editable": true,
        "value": true
    },
    "oidc_admin_group": {
        "editable": true,
        "value": ""
    },
    "oidc_auto_onboard": {
        "editable": true,
        "value": false
    },
    "oidc_client_id": {
        "editable": true,
        "value": ""
    },
    "oidc_endpoint": {
        "editable": true,
        "value": ""
    },
    "oidc_extra_redirect_parms": {
        "editable": true,
        "value": "{}"
    },
    "oidc_group_filter": {
        "editable": true,
        "value": ""
    },
    "oidc_groups_claim": {
        "editable": true,
        "value": ""
    },
    "oidc_logout": {
        "editable": true,
        "value": false
    },
    "oidc_name": {
        "editable": true,
        "value": ""
    },
    "oidc_scope": {
        "editable": true,
        "value": ""
    },
    "oidc_user_claim": {
        "editable": true,
        "value": ""
    },
    "oidc_verify_cert": {
        "editable": true,
        "value": true
    },
    "primary_auth_mode": {
        "editable": true,
        "value": false
    },
    "project_creation_restriction": {
        "editable": true,
        "value": "everyone"
    },
    "quota_per_project_enable": {
        "editable": true,
        "value": true
    },
    "read_only": {
        "editable": true,
        "value": false
    },
    "robot_name_prefix": {
        "editable": true,
        "value": "robot$"
    },
    "robot_token_duration": {
        "editable": true,
        "value": 30
    },
    "scan_all_policy": {},
    "scanner_skip_update_pulltime": {
        "editable": true,
        "value": false
    },
    "self_registration": {
        "editable": true,
        "value": false
    },
    "session_timeout": {
        "editable": true,
        "value": 60
    },
    "skip_audit_log_database": {
        "editable": true,
        "value": false
    },
    "storage_per_project": {
        "editable": true,
        "value": -1
    },
    "token_expiration": {
        "editable": true,
        "value": 30
    },
    "uaa_client_id": {
        "editable": true,
        "value": ""
    },
    "uaa_client_secret": {
        "editable": true,
        "value": ""
    },
    "uaa_endpoint": {
        "editable": true,
        "value": ""
    },
    "uaa_verify_cert": {
        "editable": true,
        "value": false
    }
}
```