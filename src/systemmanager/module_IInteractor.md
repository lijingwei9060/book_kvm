

## module IInteractor: 消息解析器，有MGS和MDS

1. MGSInteractor支持ssm-document-worker ssm-session-worker
2. MDSInteractor支持ssm-document-worker

### MGSInteractor

1. messagehandler
2. controlChannel
3. 
4. ackSkipCodes：
5. go mgs.listenIncomingAgentMessages() // listens incoming channel for agent related messages
6. go mgs.startReplyProcessingQueue()   // starts the reply queue
7. go mgs.listenReply()                 // listen to the replies received from message handler and pushes to the reply queue
8. setupControlChannel()                // 创建控制通道 
9. go mgs.startUpdateReplyFileWatcher() // 初始化完成后启动监听线程
10. mgs.startSendFailedReplyJob()



消息类型：
AgentMessag：
1. AgentJobReply
2. AgentJobAcknowledgeMessage


## IControlChannel 控制channel

### 接口

```go
type IControlChannel interface {
	Initialize(context context.T, mgsService service.Service, instanceId string, agentMessageIncomingMessageChan chan mgsContracts.AgentMessage)
	SetWebSocket(context context.T, mgsService service.Service, ableToOpenMGSConnection *uint32) error
	SendMessage(log log.T, input []byte, inputType int) error
	Reconnect(context context.T, ableToOpenMGSConnection *uint32) error
	Close(log log.T) error
	Open(context context.T, ableToOpenMGSConnection *uint32) error
}
```

1. getControlChannelToken calls CreateControlChannel to get the token for this instance
2. wsChannel.SetChannelToken(tokenValue)
3. controlChannel.Reconnect()
4. controlChannelIncomingMessageHandler handles the incoming messages coming to the agent.

## IMessageHandler

### 接口

```go
type IMessageHandler interface {
	GetName() string
	Initialize() error
	InitializeAndRegisterProcessor(proc processorWrapperTypes.IProcessorWrapper) error
	RegisterReply(name contracts.UpstreamServiceName, reply chan contracts.DocumentResult)
	Submit(message *contracts.DocumentState) ErrorCode
	Stop() (err error)
}
```