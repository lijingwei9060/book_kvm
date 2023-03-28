# 内容

## 系统trait

- 自动 Trait
- 泛型 Trait
- 格式化 Trait
- 操作符 Trait
- 转换 Trait
- 错误处理
- 迭代器 Trait
- I/O Trait

## 派生宏（Derive Macros）

- Clone
- Copy
- Debug
- Default
- Eq
- Hash
- Ord
- PartialEq
- PartialOrd

## 泛型覆盖实现（Generic Blanket Impls）

```rust
use std::fmt::Debug;
use std::convert::TryInto;
use std::ops::Rem;

trait Even {
    fn is_even(self) -> bool;
}

// generic blanket impl
impl<T> Even for T
where
    T: Rem<Output = T> + PartialEq<T> + Sized,
    u8: TryInto<T>,
    <u8 as TryInto<T>>::Error: Debug,
{
    fn is_even(self) -> bool {
        // these unwraps will never panic
        self % 2.try_into().unwrap() == 0.try_into().unwrap()
    }
}
```

## Subtraits & Supertraits

```C
trait Subtrait: Supertrait {}
```