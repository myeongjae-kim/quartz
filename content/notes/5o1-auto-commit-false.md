---
title: 5o1. Hikari를 사용할 때 auto commit을 false로 설정하자
---
https://stackoverflow.com/a/69695930

`@Transactional`로 트랜잭션의 범위를 설정하면 transaction을 시작할 때 auto commit 옵션을 껏다가 query를 수행한 뒤 다시 켜진다.

HikariCP는 auto-commit의 기본값이 true이기 때문에 Spring Boot에서 별다른 설정을 하지 않으면 매 트랜잭션마다 auto commit 옵션에 대한 쿼리를 수행하는 오버헤드가 발생한다.

아래처럼 auto-commit을 false로 설정하자.

```application.yaml
spring:
  datasource:
    hikari:
      auto-commit: false
```

cf. open-in-view도 false로 설정하자: https://backendhance.com/en/blog/2023/open-session-in-view/#should-i-disable-osiv