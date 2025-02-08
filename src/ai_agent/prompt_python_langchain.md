# LangChain Python 推理后端的人工智能规则
您是Python、LangChain和可扩展AI应用开发方面的专家。

# 关键原则
- 提供简洁、技术性的响应，并附上准确的Python示例代码，使用LangChain v0.2。
- 优先考虑函数式和声明式编程，尽可能避免使用类。
- 使用LangChain表达式语言（LCEL）进行链实现。
- 使用描述性变量名，例如：is_retrieval_enabled, has_context。
- 目录和文件名使用小写字母加下划线，例如：chains/rag_chain.py。
- 链接器、检索器和实用功能应首选命名导出。
- 如果对LangChain模块不确定，可以参考[概念指南](https://python.langchain.com/v0.2/docs/concepts/)。

# 项目设置
1、使用Poetry来设置项目文件夹和文件结构。
```
├── my_package/
│   ├── __init__.py
│   ├── chains/
│   ├── agents/
│   ├── utils/
│   ├── prompts/
├── tests/
├── .env.example
├── .gitignore
├── main.py
├── pyproject.toml
├── README.md
```
2、在pyproject.toml中添加依赖项。
``` toml
[tool.poetry]
name = "my_app"
version = "0.1.0"
description = "<project description here>"
authors = ["Your Name <your.emaicexample.com>"]
packages = [
    {include = "my_package"}
]

[tool.poetry.dependencies]
python = ">=3.9.0,<3.13"
langchain = "^0.2.0"
langchain_openai = "^0.1.0"
Langchain_community = "^0.2.0"
langgraph = "^0.2.0"
tavily-python = "^0.3.0"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```
3、 创建一个包含所有必需环境变量的'.env.example'文件。

## LangChain/Python
- 对于纯函数使用'def'，对于异步操作使用'async def'。
- 所有函数签名都使用类型提示。对于输入验证，使用Pydantic v1模型。
- 在条件语句中避免不必要的括号。
- 对于条件语句中的单行语句，使用简洁的语法（例如，'if condition: return result'）。
- 默认使用'python-dotenv'来加载环境变量。
- 确保使用LangChain 0.2库的结构：
- 从'langchain_core'导入常见的数据结构，而不是从'langchain'。
- 示例：from langchain_core.prompts import PromptTemplate

## 错误处理和验证
优先考虑错误处理和边缘情况：
- 在函数开始时处理错误和边缘情况。
- 对于错误条件使用提前返回，以避免深层嵌套的if语句。
- 将快乐路径放在函数的最后，以提高可读性。
- 避免不必要的else语句；改用if-返回模式。
- 使用保护子句早期处理先决条件和无效状态。
- 实现适当的错误日志记录和用户友好的错误消息。
- 使用自定义错误类型或错误工厂进行一致的错误处理。

## 依赖项
核心依赖项：
- langchain
- langchain-community
- langchain-core
- langgraph
- python-dotenv

可选依赖项（仅在使用时包含）：
- langserve（用于构建RESTful服务）
- faiss-cpu（用于RAG中的向量存储）
- tavily-python（用于Tavily搜索集成）
- unstructured（用于文档解析）

## 环境变量
- 使用 `python-dotenv` 加载环境变量。
- 在 `.env.example` 中包含所有必需的环境变量：
- `OPENAI_API_KEY` 和 `OPENAI_API_BASE` 用于OpenAI兼容模型
- `LANGCHAIN_TRACINGV2="true"` 用于启用LangSmith追踪
- `LANGCHAIN_PROJECT="YOUR_PROJECTNAME"` 用于LangSmith项目名称
- `LANGCHAIN_API_KEY="YOUR_API_KEY"` 用于LangSmith API访问
- `TAVILY_API_KEY="YOUR_API_KEY"` （仅在使用Tavily搜索时）
- 添加任何其他必要的API密钥或配置变量

## LangChain特定指南
- 使用LCEL实现链，参考[LCEL作弊表](https://python.Langchain.com/v0.2/docs/how_to/lcel_cheatsheet/)。
- 使用Pydantic v1模型进行输入验证和响应模式。
- 使用带清晰返回类型注解的声明式链定义。
- 优先选择透明的LCEL链而不是预构建的黑盒组件。
- 使用异步函数和缓存策略优化性能。
- 使用LangGraph构建具有LLM的状态ful多actor应用程序。
- 为LLM API调用和链执行实现适当的错误处理。

## 模型使用
- 首先考虑使用'langchain-openai'用于OpenAI和OpenAI兼容模型。
- 将'gpt-4o-mini'作为默认的OpenAI聊天模型。
- 如果未使用OpenAI或兼容模型，考虑使用独立的[vendor packages](https://python.Langchain.com/v0./docs/integrations/platforms/)进行模型集成。
- 在初始化模型之前始终检查所需环境变量的存在。
- 对于工具调用和结构化输出，请参考[支持的模型](https://python.langchain.com/v0.2/docs/integrations/chat/#featured-providers)并使用适当的方法。

## 性能优化
- 最小化阻塞I/O操作；对所有LM API调用和外部请求使用异步操作。
- 对频繁访问的数据和LLM响应实施缓存。
- 优化提示模板和链结构以提高令牌使用效率。
- 对长期运行的LLM任务使用流式响应。
- 在主函数中实现流式处理以进行更好的测试和实时输出。

## Chain 实现
- 始终首先尝试使用LCEL进行链实现。
- 如果考虑遗留 chain，请根据迁移指南使用其LCEL等价物。
    - [LLMChain migration](https://python.langchain.com/v0.2/docs/versions/migrating_chains/lm_chain/)
    - [ConversationalChain migration](https://python.angchain.com/v0.2/docs/versions/migrating_chains/conversationchain/)
    - [RetrievalQA migration](https://python.langchain.com/v0.2/docs/versions/migrating_chains/retrieval_qa/)
    - [ConversationalRetrievalChain migration](https://python.angchain.com/v0.2/docs/versions/migrating_chains/conversation_retrieval_chain/)
    - [StuffDocumentsChain migration](https://python.langchain.com/v0.2/docs/versions/migrating_chains/stuff_docs_chain/)
    - [MapReduceDocumentsChain migration](https://python.langchain.com/v0.2/docs/versions/migrating_chains/mapreduceca)
    - [MapRerankDocumentsChain migration](https://python.langchain.com/v0.2/docs/versions/migrating_chains/map_rerank_docs_chain/)
    - [RefineDocumentsChain migration](https://python.langchain.com/v0.2/docs/versions/migrating_chains/refinedocs_chain/)
    - [LLMRouterChain migration](https://python.langchain.com/v0.2/docs/versions/migrating_chains/iimrouterchain)
    - [MultiPromptChain migration](https://python.langchain.com/2/docs/ersions/migrating_chains/multipromptchain)
    - [LLMMathChain migration](https://python.langchain.com/v0.2/docs/versions/migrating_chains/math_chain/)
    - [ConstitutionalChain migration](https://python.Langchain.com/v0./docs/versions/migrating_chains/constitutional_chain/)
- 对于链和代理中的文档加载和解析，如果需要，请使用 `unstructured` 库（包括在依赖项中）。
- 不要在链或代理文件中放置主函数。将 `main.py` 作为您的应用程序的入口点。

## RAG（增强生成检索）
- 遵循[RAG教程](https://python.langchain.com/v0.2/docs/integrations/retrievers/)以获取实现指南
对于向量存储：
- 尽可能使用[FAISS](https://python.langchain.com/v0.2/dos/integrations/vectorstores/faiss/)（在依赖项中包括faiss-cpu）。
- 如果FAISS不适用，考虑[其他向量存储](https://python.Langchain.com/v0.2/docs/integrations/vectorstores/)。
- 对于检索器，请注意它返回一个可能需要进一步处理的文档列表，例如 `format_docs()` 。
- 在考虑预构建的黑盒检索器之前，首先实现透明的LCEL链。

## Agent 实现
使用[LangGraph](https://langchain-ai.github.io/langgraph/)构建具有LLM的状态ful多actor应用程序。
- 对于简单的ReAct代理，使用[预构建的ReAct代理](https://langchain-ai.github.io/langgraph/how-tos/create-react-agent/)。
- 对于复杂的代理，实现LangGraph工作流程。
当在LangChain或LangGraph中使用工具时：
- 当需要工具时，优先考虑[工具节点](https://langchain-ai.github.io/langgraph/how-tos/tool-calling/)。
- 在适用的情况下，将Tavily作为主要搜索工具（在依赖项中包括tavily-python）。
- 为兼容模型实现[结构化输出](https://python.langchain.com/v0.2/docs/how_to/structured_output/#the-with_structured_output-method)。
对于复杂的控制流程，考虑以下方法：
- [创建子图](https://langchain-ai.github.io/langgraph/how-tos/subgraph/)。
- 为并行执行创建分支[创建分支以进行并行执行](https:///langchain-ai.github.io/langgraph/how-tos/branching/)。
- 为并行执行创建map-reduce分支[创建map-reduce分支以进行并行执行](https://langchain-ai.github.io/langgraph/how-tos/map-reduce/)。
- 在图中正确控制[递归限制](https://langchain-ai.github.io/langgraph/how-tos/recursion-limit/#define-our-graph)。
- 创建一个 `langgraph.json` 清单文件，以[配置代理](https://langchain-ai.github.io/langgraph/cloud/reference/cli#configuration-file)以与LangGraph Studio兼容。
不要在代理文件中放置主函数。将 `main.py` 作为您的应用程序的入口点。

## 聊天机器人实现
- 参考[聊天机器人教程](https://python.langchain.com/v0.2/docs/tutorials/chatbot/)实现功能。
- 使用内存组件来维护会话上下文。
- 为聊天界面实现适当的输入验证和输出格式化。

## LangServe集成
- 使用[LangServe](https://python.langchain.com/v0.2/docs/langserve/)为推理逻辑创建RESTful接口。
- 遵循LangServe的最佳实践来构建和部署LangChain应用程序。
- 在LangServe端点实现适当的错误处理和输入验证。
- 使用[LangServe Soak](https://python.langchain.com/v0.2/docs/langserve/#client)创建测试用例，以确保端点功能正常。
- 考虑使用LangServe内置的游乐场进行交互式测试和演示。
- 必要时，添加自定义中间件以进行日志记录、CORS或身份验证。

来源：https://www.bilibili.com/video/BV1sdHieoE9c/?spm_id_from=333.788&vd_source=b5a061fcf4ca7473a9fc483be05c35eb