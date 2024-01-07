# react

## 概念

- useMemo
- useCallback
- useRef
- useImperativeHandle
- useLayoutEffect
- useDebugValue
- useReducer
- useContext
- useErrorBoundary
- useTransition
- useDeferredValue
- useTransition
- useDeferredValue

- React.ChangeEvent<HTMLFormElement>
- React.MouseEvent<HTMLButtonElement>
- React.KeyboardEvent<HTMLInputElement>
- React.FocusEvent<HTMLInputElement>
- React.DragEvent<HTMLDivElement>
- React.PointerEvent<HTMLDivElement>
- React.TouchEvent<HTMLDivElement>
- React.FormEvent<HTMLFormElement>

## route- react-router-dom

- useSearchParams: 获取url参数
- useNavigate: 跳转
- useLocation: 获取当前url
- useParams: 获取url参数
- useMatch: 匹配url
- useHistory: 历史记录
- useRouteMatch: 匹配url
- useResolvedPath: 解析url
- useLocation: 获取当前url
- useOutlet: 匹配路由
- useRoutes: 匹配路由
- <Outlet /> 组件: 路由需要渲染的位置组件
- <Route /> 路由器组件, 不能单独使用必须放在 <Routes/> 组件里面，给 <Routes /> 组件提供数据
- <Routes /> 路由器容器组件
- <Await />用于在加载器函数中从返回 defer() 中呈现延迟加载的数据的组件
- <AwaitErrorBoundary /> 组件是一个 Promise， 捕获的时 <Await /> 组件的错误边界
- ResolveAwait 间接利用<Await>上的渲染道具 API 的 useAsyncValue

useHref返回给定"to"值的完整 href。这对于构建自定义链接非常有用，这些链接也可以访问并保留右键单击行为。
useInRouterContext如果此组件是<Router>的后代，则返回 true。
useLocation返回当 location 对象，该对象表示 Web 中的当前 URL浏览器。
useNavigationType返回当前导航操作，该操作描述路由器如何通过历史堆栈上的弹出、推送或替换到达当前位置。
useMatch如果给定模式与当前 URL 匹配，则返回 PathMatch 对象。这对于需要知道“活动”状态的组件很有用，例如<NavLink>。
useNavigate返回用于更改位置的命令式方法。由 <Link>s 使用，但也可以被其他元素用来更改位置。
useOutletContext返回路由层次结构此级别的子路由的上下文（如果提供）。
useOutlet返回路由层次结构此级别的子路由的元素。在内部用于 <Outlet> 呈现子路由。
useParams返回当前 URL 中与路由路径匹配的动态参数的键/值对的对象。
useResolvedPath根据当前位置解析给定"to"值的路径名。
useRoutes返回与当前位置匹配的路由元素，已准备好使用正确的上下文来呈现路由树的其余部分。树中的路由元素必须呈现 才能<Outlet>呈现其子路由的元素。
useDataRouterContextDataRouter 上下文useDataRouterStateDataRouter 对应 stateuseNavigation返回当前导航，默认为“空闲”导航没有正在进行的导航
useRevalidator返回用于手动触发重新验证的重新验证函数，以及任何手动重新验证的当前状态
useMatches返回活动路由匹配项，这对于访问父/子路由的 loaderData 或路由“handle”属性很有用
useLoaderData返回最近的祖先路由加载器的加载程序数据
useRouteLoaderData返回给定路由 ID 的加载器数据
useActionData返回最近祖先路由操作的操作数据
useRouteError返回最近的祖先路由错误，该错误可能是加载程序/操作错误或呈现错误。 这旨在从您的 errorElement 调用以显示正确的错误消息。
useAsyncValue返回来自最近祖先的快乐路径数据<Await /> 值
useAsyncError返回来自最接近祖先的错误 <Await /> 值


### Loader function
loader属性传入一个函数（允许是 async function），每次渲染「该路由对应的element」前执行函数。在「该路由对应的element」内，可以使用 hook useLoaderData （下文会介绍）来获取这个函数的返回值（通常是http请求的response）。
```typescript
<Route loader={async ({ request }) => {
    // loaders can be async functions
    const res = await fetch("/api/user.json", {
      signal: request.signal,
    });
    const user = await res.json();
    return user;
  }}
  element={<Xxxxxx />}
/>
```

#### loader 参数
loader属性传入的函数，允许有2个参数：

- params: 如果Route中包含参数（例如path是/user/:userId，参数就是:userId，可以通过params.userId获取到路由参数的值）。
- request: 是 Web 规范中，Fetch API 的 Request，代表一个请求。注意：这里指的不是你在 loader 内部发的 fetch 请求，而是当用户路由到当前路径时，发出的“请求”（其实在Single-Page App中，router已经拦截了这个真实的请求，只有Multi-Page App中才会有这个请求），这里是 React Router 6.4 为了方便开发者获取当前路径信息提供的参数，他们按照 Web规范，制造了一个假的 request。你可以通过 request 方便的获取当前页面的参数:
```typescript
<Route
  loader={async ({ request }) => {
    const url = new URL(request.url);
    const searchTerm = url.searchParams.get("q");
    return searchProducts(searchTerm);
  }}
/>
```
不要这个 request 参数行吗？不行，因为如果你用window.location获取的信息是当前最新的值，如果用户快速的点击按钮，让页面路由到A，并立马路由到B，这时候路由A对应的Route的loader获取window.location时，就可能拿到错误的值。

注意，传递 request，还有个好处，它有个 request.signal，当用户快速的点击按钮，让页面路由到A，并立马路由到B，页面A的loader的请求应该被取消掉，可以通过 signal 实现，如下：
```typescript
<Route
  loader={async ({ request }) => {
    return fetch("/api/teams.json", {
      signal: request.signal,
    });
  }}
/>
```

#### loader 返回值
函数的返回值，将可以在element中通过hook useLoaderData （下文会介绍）来获取。你返回什么，它就拿到什么。

但是 React Router 官方建议，返回一个 Web规范 中的 Fetch API 的 Response。

你可以直接 return fetch(url, config);，也可以自己构造一个假的 Response:
```typescript

function loader({ request, params }) {
  const data = { some: "thing" };
  return new Response(JSON.stringify(data), {
    status: 200,
    headers: {
      "Content-Type": "application/json; utf-8",
    },
  });
}
//...
<Route loader={loader} />
```

也可以通过 React Router 提供的 json 来构造：
```typescript

import { json } from "react-router-dom";

function loader({ request, params }) {
  const data = { some: "thing" };
  return json(data, { status: 200 });
}
//...
<Route loader={loader} />
```
#### 特殊返回值: redirect
在 loader 中，可能校验后需要重定向，React Router 不建议你用 useNavigation 完成，建议直接在 loader 中直接 return redirect，跳转到新的网址。

import { redirect } from "react-router-dom";

const loader = async () => {
  const user = await getUser();
  if (!user) {
    return redirect("/login");
  }
};

#### loader 内抛出异常
如果数据获取失败，或者其它任何原因，你认为不能让 Route 对应的 element 正常渲染了，你都可以在 loader 中 throw 异常。这时候，「errorElement」就会被渲染。

function loader({ request, params }) {
  const res = await fetch(`/api/properties/${params.id}`);
  if (res.status === 404) {
    throw new Response("Not Found", { status: 404 });
  }
  return res.json();
}
//...
<Route loader={loader} />

注意：你可以抛出任何异常，都可以在 errorElement 内通过 hook useRouteError 来获取到异常。

但是，React Router 官方建议你 throw Response：

<Route
  path="/properties/:id"
  element={<PropertyForSale />}
  errorElement={<PropertyError />}
  loader={async ({ params }) => {
    const res = await fetch(`/api/properties/${params.id}`);
    if (res.status === 404) {
      throw new Response("Not Found", { status: 404 });
    }
    const home = res.json();
    return { home };
  }}
/>

你依然可以用 React Router 提供的 json 方法，方便的构造个 Response：

throw json(
  { message: "email is required" },
  { status: 400 },
);

### Element元素

内部可用 useLoaderData 获取 loader 返回值，如果 loader 返回值是 Response，并且 Response 的 Content Type 是 application/json，React Router 内部会自动调用 .json() 方法，开发者不必写 .json() 了。
内部可调用 useRouteLoaderData 获取 其它 Route 的 loader 返回值

### errorElement
当 loader 内抛出异常，<Route>就不渲染它的 element 了，而是渲染它的 errorElement。
<Route> 是可以嵌套的，每一层都可以定义 errorElement，异常发生后，会找到最近的 errorElement，并渲染它，然后停止冒泡。
在 errorElement 内，可用 useRouteError 获取异常。
React Router 给了一个函数 isRouteErrorResponse，帮你在开发 errorElement 时，可以判断当前异常是否是 Response 异常。因为 Response 异常 通常是开发者自己抛出的，是可以展示原因的（包括后端接口返回错误码和错误提示文案，也可在这里处理）。其它异常，通常是未知的，就直接展示兜底的报错文案即可。

```typescript
function RootBoundary() {
  const error = useRouteError();

  if (isRouteErrorResponse(error)) {
    if (error.status === 404) {
      return <div>This page doesn't exist!</div>;
    }
    if (error.status === 503) {
      return <div>Looks like our API is down</div>;
    }
  }

  return <div>Something went wrong</div>;
}
```

### Action Function

它很像 laoder，你看：

- 它也有2个参数：params 和 request。定义跟 loader 一样。
- 你可以 return 任何东西，同样 React Router 建议你 return Response。
- 你也可以 return redirect，实现重定向。
- 在element内，你可以用hook useActionData 获取 action 返回值。（类似 useLoaderData）

不同点在于，它们执行时机不同：

- loader 是用户通过 GET 导航至某路由时，执行的。
- action 是用户提交 form 时，做 POST PUT DELETE 等操作时，执行的。

以前写过<form>的都知道，它有 action 和 method 参数，在以前，提交表单也是在浏览器内做了一次改变URL的操作。使用React后，几乎没人这么做，大家都是AJAX或Fetch提交表单了。

现在，React Router 提供了 <Form> 组件，并给 <Route> 组件增加了 action 属性，让提交表单也变成一次路由。

实在是忍不住了，想发表个人观点：感觉没用，屁用没有。

如果你想了解 Route 的 action 属性，一定要看 React Router Form，注意 Form 里也有个 action 属性，不要搞混了。
## Navigation

```typescript
import { useNavigate } from "react-router-dom";
const navigate = useNavigate();
navigate("/music_play/1");
```

```typescript
export type RelativeRoutingType = "route" | "path";

export interface NavigateOptions {
  replace?: boolean;
  state?: any;
  preventScrollReset?: boolean;
  relative?: RelativeRoutingType;
}

export interface Navigator {
  createHref: History["createHref"];
  encodeLocation?: History["encodeLocation"];
  go: History["go"];
  push(to: To, state?: any, opts?: NavigateOptions): void;
  replace(to: To, state?: any, opts?: NavigateOptions): void;
}

interface NavigationContextObject {
  basename: string;
  navigator: Navigator;
  static: boolean;
}

```

fetcher.Form

### Deferred Data
由于引入了 loader，内部有 API 请求，必然导致路由切换时，页面需要时间去加载。加载时间长了怎么办？需要展示 Loading 态。

解决方案一：不要在 loader 内发 API 请求，在 Route 对应的 element 里发请求，并展示 Loading 态。React Router 提供了贴心的 useFetcher，可以在element内发请求。
解决方案二：针对 loader，提供一种配置方案，允许开发者定义 Loading 态。
React Router 这两种方案都提供了。方案一就是 useFetcher。为了实现方案二，它引入了defer函数和<Await>组件。

3.1 defer 函数
在 loader 内使用，表明这个 loader 需要展示 Loading 态。如果 loader 返回了 defer，那么就会直接渲染 <Route> 的 element。

<Route
  loader={async () => {
    let book = await getBook(); // 这个不会展示 Loading 态，因为它被 await 了，会等它执行完并拿到数据
    let reviews = getReviews(); // 这个会展示 Loading 态
    return defer({
      book, // 这是数据
      reviews, // 这是 promise
    });
  }}
  element={<Book />}
/>;
复制
3.2 <Await> 组件
在 <Route> 的 element 中使用，用于展示 Loading 态。需要结合<Suspense>使用，Loading 态展示在<Suspense> 的 fallback 中。

function Book() {
  const {
    book,
    reviews, // this is the same promise
  } = useLoaderData();
  return (
    <div>
      <h1>{book.title}</h1>
      <p>{book.description}</p>
      <React.Suspense fallback={<ReviewsSkeleton />}>
        <Await
          // and is the promise we pass to Await
          resolve={reviews}
        >
          <Reviews />
        </Await>
        />
      </React.Suspense>
    </div>
  );
}
复制
等 loader 加载完毕，就会展示 Await 的 children 里的内容了。

3.2.1 <Await> 组件的 children 属性
可以是函数，也可以是 React 组件。

如果是函数，Promise 结果就是参数：

<Await resolve={reviewsPromise}>
  {(resolvedReviews) => <Reviews items={resolvedReviews} />}
</Await>
复制
如果是组件，内部通过useAsyncValue 获取 Promise 的结果。

<Await resolve={reviewsPromise}>
  <Reviews />
</Await>;

function Reviews() {
  const resolvedReviews = useAsyncValue();
  return <div>{/* ... */}</div>;
}

## JSON

JSON.stringify()
JSON.parse()



