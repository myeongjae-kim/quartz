---
title: "5i. SSR시 캐시 주의"
---

개인화된 페이지를 렌더링하는 경우 캐싱을 하면 안 된다.

캐싱할 페이지와 아닌 페이지를 명확히 구분해야 성능과 보안에서 유리하다.

블로그같은 게시판 형태는 어드민 페이지를 따로 구축하는게 좋다. 특정 path이하는 캐싱하지 않도록 middleware에서 설정하면 된다. `pragma`와 `cache-control` 헤더로.

nextjs에는 [Route Segment Control](https://nextjs.org/docs/app/api-reference/file-conventions/route-segment-config) 관련해서 캐시 설정을 할 수 있다.