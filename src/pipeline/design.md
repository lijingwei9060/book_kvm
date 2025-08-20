# intro

## 功能设计

Stage Template Type： Deploy， Build ，Approval， Feature Flag， Security Tests， Pipeline， Custom Stage

Step：
    Build： git provider 支持harness、third-party
    Utilities: shell script, container step, http , email, wait, EventListener
    Approval: harness Approval, custom Approval, jira approval, serviceNow approval
    Jira: Jira create, jira update
    flowControl: ba4rrier, queue
    Governance: policy
    ServiceNow: create, update, import set
    Deploy: k8s, helm, lambda, secure shell, winrm, aws auto scale, spot elastic
            Canary Deployment、Cananry Delete
            Rolling Deployment
    Git： update Release repo， merge pr，fetch linked apps， 
    Terraform: Apply, Plan, Rollback, Destroy
    Cloudformation: create, delete, rollback
    Azure: 
    Shell: 
    Chaos
    Helm: Delete


Stage: 包含 overview、Service、Environment、Execution、Advanced

Overview：
    Name、Description、Tags
    Deployment Type

### container
    serial
    loop： 
    conditions：when

### workflow
entrypoint
arguments
    parameter
templates： group of steps
Retry

### Step
    Container： 
        name、command、args、resource（limits-cpu、memory）

## variable

<+pipeline.variables.project_name>
<+pipeline.variables.github_username>
<+pipeline.variables.github_token>
<+pipeline.variables.github_org>
<+pipeline.variables.github_repo>



## UI设计

### Node
indicator：
deletor：
handler：

Group Container



### Canvas

工具： zoot to fit，reset、zoom in、zoom out