---
title: "5c. URL과 세미콜론"
---

세미콜론(;)은 URL에서 사용할 수 있는 문자다. 하지만 path parameter를 구분하는데 사용하고, query parameter에서는 일반 문자로 취급해야 한다.

> In other words, `?foo=bar;baz` means the parameter `foo` will have the value `bar;baz`; whereas `?foo=bar;baz=sna` should result in `foo` being `bar;baz=sna` (although technically illegal since the second `=` should be escaped to `%3D`).
>
> - https://stackoverflow.com/a/40768572

예전에 쿼리 파라미터를 구분할 때 쓰는 암퍼센드(&)를 세미콜론(;)으로 대체하려는 시도가 있었지만, 지금은 obsolete되었고 쿼리 파라미터를 구분할 때는 암퍼센드(&)만 사용해야 한다.

하지만 path parameter를 구분하는데 사용하는 세미콜론(;)은 여전히 유효하다. 예를 들어서 `http://www.blah.com/some/crazy/path.html;param1=foo;param2=bar`

### 참고
- https://stackoverflow.com/a/40768572
- https://stackoverflow.com/a/18830337