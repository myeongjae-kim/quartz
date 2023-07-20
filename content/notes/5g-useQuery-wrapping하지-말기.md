---
title: "5g. useQuery wrapping하지 말기"
---

react-query contributor가 useQuery함수의 옵션을 다 받을 수 있는 커스텀훅 만들지 말고 그냥 useQuery를 쓰라고 한다: [https://twitter.com/tkdodo/status/1680944472694169603?s=46&t=WWPMzoEtNZZ_eqp7T45DPQ](https://twitter.com/tkdodo/status/1680944472694169603?s=46&t=WWPMzoEtNZZ_eqp7T45DPQ)

> creating a custom hook over useQuery that accepts all options is a mess. Nobody gets this right because it's complex, and you probably don't want to let users pass all options anyways. I have to constantly talk everybody out of doing this.  

예를 들면 이런거: [https://slash.page/ko/libraries/react/react-query/src/hooks/usesuspendedquery.i18n/](https://slash.page/ko/libraries/react/react-query/src/hooks/usesuspendedquery.i18n/)토스에서 useQuery를 확장해서 useSuspendedQuery를 만들었는데 이거 쓰다가 undefined에러 겪었다.

관련 트윗: https://twitter.com/TkDodo/status/1491451513264574501

![[notes/images/FLKwGYRWYA8rUF0.jpeg]]