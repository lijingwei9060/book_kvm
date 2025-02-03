# version

RDP的设计建构于国际电信联盟T.share协议（又称为T.128），发展以来各个版本大致为

- 4.0版：这是第一个版本。随同终端服务（Terminal Services）出现在Windows NT 4.0 Server、Terminal Server Edition。
- 5.0版：由Windows 2000 Server引入。加入了许多新功能，包括打印到客户端打印机，针对网络带宽使用的改进等等。
- 5.1版：由Windows XP Professional（XP Home不支持服务端功能）引入。支持24位颜色显示及声音的支持。该版本的客户端可以是Windows 2000，Windows 9x，Windows NT 4.0[1]。
- 5.2版：由Windows Server 2003引入，包括了console mode connections，session directory，以及客户端资源的取用。Windows CE 5.0及6.0均有这个版本的客户端部分，但Windows CE没有作为服务端的功能。该版本内置于Windows XP Professional x64 Edition和Windows Server 2003中。
- 6.0版：由Windows Vista引入。该版本的客户端可以是Windows XP SP2，Windows Server 2003 SP1/SP2（x64或x86版），Windows XP Professional x64 Edition。包括许多重大改进，最值得注意的是可以从远程使用单一应用程序，而非整个桌面；以及32位颜色显示的支持。
- 6.1版：由Windows Server 2008和Windows Vista SP1引入。该版本的客户端可以是Windows XP SP3。Windows XP SP2须安装KB952155。
- 7.0版：由Windows Server 2008 R2或Windows 7引入。该版本的客户端可以是Windows XP SP3、Windows Vista SP1/SP2，但须安装KB969084。该版本的客户端不支持Windows Server 2003 x86和Windows Server 2003 / Windows XP Professional x64 editions。
- 7.1版：必须要有Windows 7 SP1或Windows Server 2008 R2 SP1，主要增加了RemoteFX（英语：RemoteFX）的功能。
- 8.0版：由Windows 8或者Windows Server 2012引入。Windows 7 SP1和Windows Server 2008 R2 SP1要支持该协议须先安装KB2574819，再安装KB2592687。
- 8.1版：由Windows 8.1和Windows Server 2012 R2引入。Windows 7 SP1和Windows Server 2008 R2 SP1要支持该协议须先安装KB2574819、KB2857650，再安装KB2830477。之后最好再安装KB2913751。
- 10.0版本：由Windows 10引入。增加了H.264/AVC视频压缩。


## features

- 多种显示支持，包括8，15，16，24，32位色。
- 128位加密，使用RC4、3DES或AES加密算法。（此为内定的加密方式；比较旧版的客户端可能使用较弱的加密强度）
- 支持TLS（Transport Layer Security，前身为SSL）。
- 声音转向（redirection）支持，用户可以在远程电脑执行有声音的应用程序，但是将声音导引至客户端电脑来听。
- 文件系统转向支持，用户可在使用远程电脑的过程中，取用本地（客户端）电脑上的文件系统。
- 打印机转向支持，在使用远程电脑时，可以使用本地（客户端）电脑上的打印机输出，包括直接连在客户端电脑的打印机或网络共享打印机。
- 端口转向支持，远程电脑上的应用程序可以使用本地（客户端）电脑上的串行端口或并行端口。
- Windows的剪贴板资料可以在远程及本地电脑之间互通。


## 协议结构

TPKT协议的全称是"Transport Protocol Data Unit"，它在RDP中负责对RDP数据进行分割、传输和重组。TPKT协议主要用于在网络中可靠地传输RDP数据。TPKT协议具体定义了如何将RDP数据分割成数据单元（称为数据包）以及如何在网络中传输这些数据包。每个TPKT数据包包含一个特定的头部，用于标识包的开始和结束，并提供错误检测和纠正机制。TPKT头部中包含了数据包长度、版本号和其他必要的控制信息。

X.224协议是一种用于远程桌面协议（RDP）中的传输层协议。它提供了在网络中建立和管理RDP会话的功能，是RDP协议栈中的关键组成部分。X.224负责连接的建立和维护、可靠的数据传输、错误检测和纠正、会话管理以及安全性支持等功能。比如，X.224协议可以与其他安全协议结合使用，如SSL（Secure Sockets Layer）或TLS（Transport Layer Security），以提供传输层的数据加密和身份验证机制。通过这些安全协议，X.224可以确保RDP会话的机密性和保密性。


## 连接建立过程

1. Connection Initiation
2. Basic Settings Exchange
3. Channel Connection
4. Security Commencement
5. Secure Settings Exchange
6. Licensing
7. Capabilities Exchange
8. Connection Finalization
9. Data Exchange

### Connection Initiation

an X.224 Connection request PDU包含连接flag和安全协议： 
安全协议包含两种：
1. Standard RDP Security： Default of RSA’s RC4 encryption
2. Enhanced RDP Security： TLS， CredSSP (TLS + NTLM/Kerberos)，RDSTLS – RDP enhanced with TLS

Client X.224 Connection Request PDU： 
1. tpktHeader (4 bytes): A TPKT Header, as specified in [T123] section 8.
2. x224Crq (7 bytes): An X.224 Class 0 Connection Request transport protocol data unit (TPDU), as specified in [X224] section 13.3.
3. routingToken (variable): An optional and variable-length routing token (used for load balancing) terminated by a 0x0D0A two-byte sequence. For more information about the routing token format, see [MSFT-SDLBTS] "Routing Token Format". The length of the routing token and CR+LF sequence is included in the X.224 Connection Request Length Indicator field. If this field is present, then the cookie field MUST NOT be present.
4. cookie (variable): An optional and variable-length ANSI character string terminated by a 0x0D0A two-byte sequence. This text string MUST be "Cookie: mstshash=IDENTIFIER", where IDENTIFIER is an ANSI character string (an example cookie string is shown in section 4.1.1). The length of the entire cookie string and CR+LF sequence is included in the X.224 Connection Request Length Indicator field. This field MUST NOT be present if the routingToken field is present.
5. rdpNegReq (8 bytes): An optional RDP Negotiation Request (section 2.2.1.1.1) structure. The length of this field is included in the X.224 Connection Request Length Indicator field.
6. rdpCorrelationInfo (36 bytes): An optional Correlation Info (section 2.2.1.1.2) structure. The length of this field is included in the X.224 Connection Request Length Indicator field. This field MUST be present if the CORRELATION_INFO_PRESENT (0x08) flag is set in the flags field of the RDP Negotiation Request structure, encapsulated within the optional rdpNegReq field. If the CORRELATION_INFO_PRESENT (0x08) flag is not set, then this field MUST NOT be present.

an X.224 Connection Confirm PDU. This packet contains the RDP Negotiation Response which is used to inform the client of the selected security protocol (chosen from the client’s supported protocols) that will be used throughout the entire connection lifetime.

后续的数据包封装在an X.224 Data PDU中。

### Basic Settings Exchange

an MCS Connect Initial PDU and an MCS Connect Response PDU (respectively)： 

settings (both from the client and the server) include:

1. Core Data – RDP Version, Desktop resolution, color depth, keyboard information, hostname, client software information (product ID, build number), etc.
2. Security Data – Encryption methods, size of session keys, server random (used later to create session keys) and server’s certificate (some of this is only relevant when using Standard RDP Security).
3. Network Data – Information about the requested and allocated virtual channels. This contains the number of channels and an array of specific virtual channels. The client requests the exact type of channels in the request, and the server supplies the actual channel IDs in the response. For more information about those channels see the Channels in RDP section below.


### Channel Connection

After establishing the list of virtual channels that will be used in the RDP session, here comes the stage at which every individual channel connection is made. This has a few sub-stages:

1. MCS Erect Domain Request – Height in the MCS Domain. Since RDP doesn’t take advantage of advanced MCS topologies, it will be 0.
2. MCS Attach User Request – request for a User Channel ID
3. MCS Attach User Confirm – ID of the User Channel
4. (+5) MCS Channel Join Requests and Confirmations – The client will start to request joining the virtual channels by using their IDs. Starting with the User Channel, I/O Channel and continuing with the virtual channels negotiated in the basic settings exchange. The server will, in turn, confirm every successful channel join.

后续客户端发送的数据包封装在 an MCS Send Data Request PDU, 服务器端返回封装在an MCS Send Data Indication PDU， 数据可以转发到virtual channels。


### Security Commencement

The client sends a Security Exchange PDU containing the client random encrypted with the server’s public key. The client and server then use the random numbers (both from the Basic Settings Exchange’s Security Data and from the Security Exchange PDU) in order to create session encryption keys.

From this point on, subsequent RDP traffic can be encrypted.

### Secure Settings Exchange

At this point, the client sends an encrypted Client Info PDU containing information about supported types of compression, user domain, username, password, working directory, etc.

### Licensing

This stage is designed to allow authorized users to connect to a terminal server. That is to support more than 2 simultaneous connections (which is the default for “Windows’ RDP Server”) to a server. This requires purchasing a license from Microsoft.

In a lot of cases, no licensing server is configured for the RDP server, in that case, the RDP server will simply send a PDU to the client that “approves” its license (up to 2 sessions only).

You can find more information about the extended licensing phase and the communication between the RDP server and the license server here [MS-RDPELE](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-rdpele/3d3f160a-3ab3-4dfb-ba4e-47c27cd79409).

### Capabilities Exchange

The server sends its supported capabilities in a Demand Active PDU. This PDU contains a structure that has many capabilities of different types. According to Microsoft, we have 28 types of capability sets. Major types are general (OS version, general compression), input (keyboard type and features, fast-path support, etc.), fonts, virtual channels, bitmap codecs and many more. Then, the server may or may not send a Monitor Layout PDU to describe the display monitors on the server. The client will then respond with a Confirm Active PDU containing its own set of capabilities.

### Connection Finalization

The client and the server exchange a few types of PDUs in order to finalize the connection. All those PDUs originate from the client (PDU can be sent one after the other without waiting for a response). The PDUs are:

1. Client/Server Synchronize PDU – Used to synchronize user identifiers between the client the server.
2. Client/Server Control PDU (Cooperate) – Both the client and the server send this PDU to indicate shared control over the session.
3. Client Control PDU (Request/Grant Control) – Client sends the request for control, server grants it.
4. Persistent Key List PDU/PDUs (optional) – The client sends the server a list of keys, each key identifies a cached bitmap. This enables the bitmap cache to be persistent (as opposed to being limited to the lifetime of the connection). Bitmap caching is a mechanism used to reduce network traffic needed to transfer a graphical output from the server to the client.
5. Font List/Map PDU – these PDUs were meant to hold information about fonts for the RDP session (font name, average width, signature, etc.), however, it seems like Microsoft is not using it. Having said that, those PDUs are still exchanged between the client and the server at that point, but with no actual data in it (even if there was any data, Microsoft’s documentation specifies you should ignore it).

### Data Exchange

After the connection has been finalized, the major part of the data sent between the client and the server will be input data (client->server) and graphics data (server->client). Additional data that can be transferred includes connection management information and virtual channel messages.

1. Synchronize PDUs are used to synchronize the client and the server’s clocks.
2. Control cooperate PDUs are used to indicate shared control over the session.
3. control request control PDUs are used to request control of the session.
4. persistent key list PDUs are used to indicate the client’s bitmap cache.
5. font list PDUs are used to indicate the client’s font cache.


## Basic Input and Output

The client is sending the input and the server sends the output.

1. Input Data – This contains mouse and keyboard information, as well as periodic synchronization (e.g. NAM_LOCK / CAPS_LOCK keys state)
2. Output Data – The fundamental output data contains bitmap images of the user’s session on the server. In addition, the server can send sound information (only in the form of very basic “beep” – frequency + duration).

This basic input/output data can be transmitted in one of two ways: slow-path or fast-path.

1. Slow-Path – Normal PDU with all RDP protocol stack headers
2. Fast-Path – As the name suggests, it was created to reduce both the amount of data transmitted and the amount of processing required to process it. This is done by reducing/removing PDU headers from certain PDU types (e.g. keyboard/mouse input).

## Channels in RDP

In RDP, most of the data is being transported through different channels (MCS Layer). There are two main types of channels: Static Virtual Channels and Dynamic Virtual Channels.

### Static Virtual Channels (SVC)
SVCs allow communication between different client and server components over the main RDP data connection. There is a maximum of 31 Static Virtual Channels per connection and each channel acts as an independent data stream. Those channels are static because they are requested and created at the Basic Settings Exchange phase during the connection initiation, and they do not change at all during the session.

Not all SVCs are created equal, some are opened by default, and some are negotiated during the Basic Settings Exchange Phase. The SVCs that are being created by default are crucial to the functionality of an RDP connection, while the others enable different extensions for the protocol.

Examples for SVCs created by default:

- I/O Channel
- Message Channel
- User Channel
- Server Channel

Extension SVCs are identified by an 8-byte name, for example:

- rdpdr – Filesystem extension. Allows the redirection of access from the server to the client file system.
- rdpsnd – Sound output extension.
- cliprdr – Clipboard extension. Allows sharing the clipboard between the client and the server.
- drdynvc – Dynamic Virtual Channel Extension (see DVCs below)

All the SVCs channel IDs are supplied during the Basic Settings Exchange phase excluding 2 SVCs: the User Channel which is supplied during the Channel Connection phase in the Attach User Confirm PDU, and the Server Channel which has a fixed value of 0x03EA (1002).

### Dynamic Virtual Channels (DVC)
Since the Static Virtual Channels number is limited to 31, RDP also supports Dynamic Virtual Channels. Dynamic Virtual Channels are transported over one specific Static Virtual Channel – DRDYNVC. Those channels are dynamic since you can create and destroy them at any stage of the connection lifetime (after initialization). Developers can create extensions that will transport data over a Dynamic Virtual Channel quite easily. Common uses for DVCs are audio input (client -> server), PnP redirection, graphics rendering, echo channel, video redirection and more.

The following figure describes the relationship between the different types of channels in RDP:

## Data Compression

RDP can use compression in output data (both fast-path and slow-path) and in virtual channels. Both the client and the server need to support compression in general, and the specific type of compression negotiated for the connection. The client advertises the compression types it supports in the Client Info PDU during the Secure Settings Exchange.

Every PDU that contains compressed data, needs to have some compression flags (containing the type of compression, etc.) set in the header of that specific PDU.

## RDP Security
As mentioned briefly before, the security of the RDP protocol can be one of two types:

### Standard Security
Traffic is encrypted using RSA’s RC4 encryption algorithm, using client and server random values that are exchanged during the Basic Settings Exchange phase in the connection initialization.

### Enhanced Security
This type of security enables RDP to outsource all security operations (encryption/decryption, integrity checks, etc.) to an external security protocol. This can be one of the following:

- TLS 1.0/1.1/1.2
- CredSSP
- RDSTLS

Deciding on an enhanced security protocol can be either negotiation-based or direct. The negotiation-based means that the connection initialization (x.224 connection request and response) is outside of the scope of the security protocol. After the initialization, the client and server choose a security protocol, do the external security protocol handshake and from now on all the other stages of the RDP connection will be encapsulated within that external security protocol.

The other option – the direct approach favors security over compatibility. In this approach, the client will start with the external security protocol handshake before sending any RDP related data.

Choosing enhanced security means that the Security Commencement stage will not be executed.

The key benefit of using RDP Enhanced Security is that it enables Network Layer Authentication (details available below).

### Network Level Authentication
Network Level Authentication (NLA) refers to the usage of CredSSP to authenticate the user before the initiation of the RDP connection. This allows the server to dedicate resources only to authenticated users.

In case of a critical vulnerability in the RDP protocol, NLA can limit the exploitation of this vulnerability to authenticated users only.


## References

[Remote Desktop Protocol: Basic Connectivity and Graphics Remoting](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-rdpbcgr/)

https://learn.microsoft.com/en-us/openspecs/windows_protocols/MS-WINPROTLP/e36c976a-6263-42a8-b119-7a3cc41ddd2a