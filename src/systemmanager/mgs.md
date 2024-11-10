# intro


## 服务定义
```go
type Service interface {
	CreateControlChannel(log log.T, createControlChannelInput *CreateControlChannelInput, channelId string) (createControlChannelOutput *CreateControlChannelOutput, err error)
	CreateDataChannel(log log.T, createDataChannelInput *CreateDataChannelInput, sessionId string) (createDataChannelOutput *CreateDataChannelOutput, err error)
	GetV4Signer() *v4.Signer
	GetRegion() string
}
```
- getMGSBaseUrl gets the base url of mgs:
  - control-channel: https://ssm-messages.{region}.amazonaws.com/v1/control-channel/{channel_id}
  - data-channel: https://ssm-messages.{region}.amazonaws.com/v1/data-channel/{session_id}
  - channelType can be control-channel or data-channel
  - endpoint从配置文件读取如果有就返回，没有就按照上面的格式构建，要求是https，而且不能有证书问题
- 签名： v4
- CreateControlChannel：rest post， input = CreateControlChannelInput{MessageSchemaVersion： "1", RequestId: ""}, 返回CreateControlChannelOutput：{ MessageSchemaVersion： "1", TokenValue: "token"}
- OpenControlChannelInput
- 
- CreateDataChannel: 类似，rest post， CreateDataChannelInput：{MessageSchemaVersion： "1", RequestId: "16xxx", ClientId: "sss" }, 返回： CreateDataChannelOutput: {MessageSchemaVersion: "1", TokenValue: "sdfiwjief" }
- OpenDataChannelInput

## CreateControlChannel


## OpenControlChannel

- 设置：Channel属性
  - TLS： 可配置的证书
  - Proxy
  - Buffer： 142000 bytes
- 在controlChannel中发送一个OpenControlChannelInput


## 接收AgentMessage

收到后验证，直接转发到incomingAgentMessageChan，这是一个双向通道，谁在监听这个chan呢？只有MGSInteraction支持MGS。