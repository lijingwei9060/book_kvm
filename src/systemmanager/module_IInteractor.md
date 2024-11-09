

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