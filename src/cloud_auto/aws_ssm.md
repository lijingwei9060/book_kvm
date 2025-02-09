# intro

## SSM Operation

1. add_tags_to_resource

## module

1. health: 5分钟更新一次
   1. isEC2, isECS, isOnPrem, ContainerMode bool
   2. ec2Identity, ecsIdentity, onpremIdentity
   3. availabilityZone, availabilityZoneId
   4. ssmconnectionchannel
   5. version/AgentName/"Active"/
   6. healthCheckStopPolicy: 
   7. ping():  发送一个空的information
2. RunCommandService: Module, the scheduling of the message processor
   1. messagePollJob       *scheduler.Job
   2. processor            processor.Processor
3. MessageService：
4. MDSService(Message Delivery Service)
   1. GetMessages(log log.T, instanceID string) (messages *ssmmds.GetMessagesOutput, err error)
   2. AcknowledgeMessage(log log.T, messageID string) error
   3. SendReply(log log.T, messageID string, payload string) error
   4. SendReplyWithInput(log log.T, sendReply *ssmmds.SendReplyInput) error
   5. FailMessage(log log.T, messageID string, failureType FailureType) error
   6. DeleteMessage(log log.T, messageID string) error
   7. LoadFailedReplies(log log.T) []string
   8. DeleteFailedReply(log log.T, replyId string)
   9. PersistFailedReply(log log.T, sendReply ssmmds.SendReplyInput) error
   10. GetFailedReply(log log.T, replyId string) (*ssmmds.SendReplyInput, error)
5.  MGSInteractor: communicate with MDS
6.  


1. EngineProcessor.Submit(docState contracts.DocumentState) (errorCode ErrorCode)
   1. p.documentMgr.PersistDocumentState(docState.DocumentInformation.DocumentID, appconfig.DefaultLocationOfPending, *docState)
   2. p.sendCommandPool.Submit(log, jobID
2. EngineProcessor.Cancel(docState contracts.DocumentState)
   1. p.documentMgr.PersistDocumentState(docState.DocumentInformation.DocumentID, appconfig.DefaultLocationOfPending, *docState)
   2. p.cancelCommandPool.Submit(log, jobID



## Plugin

path: github.com/aws/amazon-ssm-agent/agent/plugins/
平台无关的
平台相关的

aws:applications
aws:configureDaemon
aws:configurePackage
aws:configureContainers
aws:configureDocker

aws:cloudWatch

aws:domainJoin
aws:downloadContent

aws:psModule

aws:runPowerShellScript
aws:runShellScript

aws:runDockerAction
aws:runDocument
aws:refreshAssociation

aws:softwareInventory

aws:updateSsmAgent
aws:updateAgent



### ExecDocumentImpl

ExecDocumentImpl.ExecuteDocument(config contracts.Configuration, context context.T, pluginInput []contracts.PluginState, documentID string, documentCreatedDate string) (resultChannels chan contracts.DocumentResult, err error)
调用runpluginutil.RunPlugins()





```go
// DocumentState represents information relevant to a command that gets executed by agent
type DocumentState struct {
	DocumentInformation        DocumentInfo
	DocumentType               DocumentType
	SchemaVersion              string
	InstancePluginsInformation []PluginState
	CancelInformation          CancelCommandInfo
	IOConfig                   IOConfiguration
	UpstreamServiceName        UpstreamServiceName
}

const (
	// SendCommand represents document type for send command
	SendCommand DocumentType = "SendCommand"
	// CancelCommand represents document type for cancel command
	CancelCommand DocumentType = "CancelComamnd"
	// Association represents document type for association
	Association DocumentType = "Association"
	// StartSession represents document type for start session
	StartSession DocumentType = "StartSession"
	// TerminateSession represents document type for terminate session
	TerminateSession DocumentType = "TerminateSession"
	// SendCommandOffline represents document type for send command received from offline service
	SendCommandOffline DocumentType = "SendCommandOffline"
	// CancelCommandOffline represents document type for cancel command received from offline service
	CancelCommandOffline DocumentType = "CancelCommandOffline"
)

// DocumentInfo represents information stored as interim state for a document
type DocumentInfo struct {
	// DocumentID is a unique name for file system
	// For Association, DocumentID = AssociationID.RunID
	// For RunCommand, DocumentID = CommandID
	// For Session, DocumentId = SessionId
	DocumentID      string
	CommandID       string
	AssociationID   string
	InstanceID      string
	MessageID       string
	RunID           string
	CreatedDate     string
	DocumentName    string
	DocumentVersion string
	DocumentStatus  ResultStatus
	RunCount        int
	ProcInfo        OSProcInfo
	ClientId        string
	RunAsUser       string
	SessionOwner    string
}
```








OutOfProcExecuter.Run() // prepare the ipc channel, create a data processing backend and start messaging with docment worker


WorkerBackend.runner => runpluginutil.RunPlugins


## AWS SDK Framework

Service
Operation: Route<Body>
		OperationShap// instrumentatin
		handler => async fn(input) -> Result<Output, Error>
		HandlerType: Handler<shape, HandlerType> => tower::Service
		HandlerExtractors
		UpgradeExtractors
		OperationService<OperationShape, ServiceExtractors>: tower::Service
RoutingService
Route
Protocol
config： Layer/HttpPlugins/ModelPlugins


ModelPlugin: Plugin<Service<L>, OperationShape, IntoService<OperationShape, HandleType>>
UpgradePlugin::<Extractors>: Plugin<Service<L>, OperationShape, ModelPlugin::Output>
Upgrade<Protocol, Input, S>
HttpPlugin: Plugin<Service<L>, OperationShape, <UpgradeExtractors, >>

PluginStack
Plugin<Service, Operation, Input, Output>
HttpMarker
ModelMarker
Service

RoutingService
	RestRouter
		RequestSpec


AuthorizationPlugin
	AuthorizeService
		Authorizer