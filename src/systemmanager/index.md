


## AgentMessage
1. Message in MGS is equivalent to MDS' InstanceMessage.
2. All agent messages are sent in this form to the MGS service.
3. MessageType： "interactive_shell", "agent_job", "channel_closed"

```go
type AgentMessage struct {
	HeaderLength   uint32
	MessageType    string
	SchemaVersion  uint32
	CreatedDate    uint64
	SequenceNumber int64
	Flags          uint64
	MessageId      uuid.UUID
	PayloadDigest  []byte
	PayloadType    uint32
	PayloadLength  uint32
	Payload        []byte
}
```
4. AgentJobPayload parallels the structure of a send-command or cancel-command job
```go
type AgentJobPayload struct {
	Payload       string `json:"Content"`
	JobId         string `json:"JobId"`
	Topic         string `json:"Topic"`
	SchemaVersion int    `json:"SchemaVersion"`
}
SendCommandTopicPrefix TopicPrefix = "aws.ssm.sendCommand"
CancelCommandTopicPrefix TopicPrefix = "aws.ssm.cancelCommand"
```
   - SendCommandTopicPrefix is the topic prefix for a send command MDS message.
   - CancelCommandTopicPrefix is the topic prefix for a cancel command MDS message.

5. SendCommandPayload是`AgentJobPayload`中的`Payload`，Topic对应的是sendCommand。
```go
type SendCommandPayload struct {
	Parameters              map[string]interface{}    `json:"Parameters"`
	DocumentContent         contracts.DocumentContent `json:"DocumentContent"`
	CommandID               string                    `json:"CommandId"`
	DocumentName            string                    `json:"DocumentName"`
	OutputS3KeyPrefix       string                    `json:"OutputS3KeyPrefix"`
	OutputS3BucketName      string                    `json:"OutputS3BucketName"`
	CloudWatchLogGroupName  string                    `json:"CloudWatchLogGroupName"`
	CloudWatchOutputEnabled string                    `json:"CloudWatchOutputEnabled"`
}
```

字符串替换：

\u0026 => &
\u003e => >
\u003c => <

   1. AgentJobAck is the acknowledge message sent back to MGS for AgentJobs。agent在接收到message后先进行ack，然后在进行reply、多次reply。reply后启动worker处理。

```go
type AgentJobAck struct {
	JobId        string `json:"jobId"`
	MessageId    string `json:"acknowledgedMessageId"`
	CreatedDate  string `json:"createdDate"`
	StatusCode   string `json:"statusCode"`
	ErrorMessage string `json:"errorMessage"`
}
```

1. AgentJobReplyContent parallels the structure of a send-command or cancel-command job
```go
type AgentJobReplyContent struct {
	SchemaVersion int    `json:"schemaVersion"`
	JobId         string `json:"jobId"`
	Content       string `json:"content"`
	Topic         string `json:"topic"`
}
```

## command 流程

1. 通过control channel收到消息

```json
{
    AgentMessage: {
        id: "fc269fb4-aaf5-45ca-99a9-d6fb9c88b8ec"， 
        MessageType："agent_job"
    }
}
```