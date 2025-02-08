# 功能

## 数据设计

1. tag 所有资源都有 tag 标签，metadata，每种资源类型会有 tag 标签上限，大部分是 50， 自动化是 5 个。key（128 个字符），value（256 个字符），区分大小小，aws 开头为专供预留
   1. ec2:CreateTags
   2. ec2:DeleteTags
   3. aws:RequestTag：指示请求中必须存在特定的标签键或标签键和值。
   4. aws:TagKeys：强制实施在请求中使用的标签键。
2. Activation

```json
{
  "DefaultInstanceName": "string",
  "Description": "string",
  "ExpirationDate": number,
  "RegistrationLimit": number,
  "RegistrationsCount": number,
  "RegistrationMetadata": [
    {
        "Key": "string",
        "Value": "string"
    }
  ],
  "Tags": [
    {
        "Key": "string",
        "Value": "string"
    }
  ],
  "IamRole": "service-role/role_name",
  "ActivationCode": "Fjz3/sZfSvv78EXAMPLE",
  "ActivationId": "e488f2f6-e686-4afb-8a04-ef6dfEXAMPLE"， // 這個是主鍵
  "CreatedDate": number,
  "Expired": boolean,
}
```


3. Document

```json
{
   "Attachments": [ 
      { 
         "Key": "string",
         "Name": "string",
         "Values": [ "string" ]
      }
   ],
   "Content": "string",
   "DisplayName": "string",
   "DocumentFormat": "string",
   "DocumentType": "string",
   "Name": "string",
   "Requires": [ 
      { 
         "Name": "string",
         "RequireType": "string",
         "Version": "string",
         "VersionName": "string"
      }
   ],
   "Tags": [ 
      { 
         "Key": "string",
         "Value": "string"
      }
   ],
   "TargetType": "string",
   "VersionName": "string",
   "DocumentDescription": {
        "CreatedDate": 1585061751.738,
        "DefaultVersion": "1",
        "Description": "Custom Automation Example",
        "DocumentFormat": "YAML",
        "DocumentType": "Automation",
        "DocumentVersion": "1",
        "Hash": "0d3d879b3ca072e03c12638d0255ebd004d2c65bd318f8354fcde820dEXAMPLE",
        "HashType": "Sha256",
        "LatestVersion": "1",
        "Name": "Example",
        "Owner": "111122223333",
        "Parameters": [
            {
                "DefaultValue": "",
                "Description": "(Optional) The ARN of the role that allows Automation to perform the actions on your behalf. If no role is specified, Systems Manager Automation uses your IAM permissions to execute this document.",
                "Name": "AutomationAssumeRole",
                "Type": "String"
            },
            {
                "DefaultValue": "",
                "Description": "(Required) The Instance Id to create an image of.",
                "Name": "InstanceId",
                "Type": "String"
            }
        ],
        "PlatformTypes": [
            "Windows",
            "Linux"
        ],
        "SchemaVersion": "0.3",
        "Status": "Creating",
        "Tags": []
    }
}
```