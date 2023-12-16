https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Release-Notes

migration은 문서 보면서: https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide


### Spring Data 2022.0

- `GenericJackson2JsonRedisSerializer`, `Jackson2JsonRedisSerializer`
    - redis에 serialize/deserialize할 때 이거 썼으면 됐었구나



https://github.com/spring-projects/spring-framework/wiki/What's-New-in-Spring-Framework-6.x

6.1

- Reactive `@Scheduled` methods (including Kotlin coroutines); see [22924](https://github.com/spring-projects/spring-framework/pull/29924).
    - 오.. 이거 비동기로 도는건 유용하겠다
- Spring MVC and WebFlux now have built-in method validation support for controller method parameters with `@Constraint` annotations. That means you no longer need `@Validated` at the controller class level to enable method validation via AOP proxy. Built-in method validation is layered on top of the existing argument validation for model attribute and request body arguments. The two are more tightly integrated and coordinated, e.g. avoiding cases with double validation. See [Upgrading to 6.1](https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-6.x#web-applications) for migration details, and umbrella issue [30645](https://github.com/spring-projects/spring-framework/issues/30645) for all related tasks and feedback.
    - 더 이상 `@Validated` 안 붙여도 되나!
- New `RestClient`, a synchronous HTTP client that offers an API similar to `WebClient`, but sharing infrastructure with the `RestTemplate`. See [29552](https://github.com/spring-projects/spring-framework/issues/29552).
    -  `RestClient`라는게 새로 생겼네
- Support for recording asynchronous events with `@RecordApplicationEvents`. See [30020](https://github.com/spring-projects/spring-framework/pull/30020).
    - Record events from threads other than the main test thread.
    - Assert events from a separate thread – for example with Awaitility.
    - 비동기 코드 테스트할 때 유용하겠다

6.0

- GraalVM으로 native binary 생성하는거 신기하네.. 쓸 수 있나? 성능 좋나?
    - serverless 코드 작성할 때 이걸로 하면 좋겠네
- 하이버네이트 6.1 지원
- `PathPatternParser` used by default (with the ability to opt into `PathMatcher`).
    - `PathMatcher` 대신에 `PathPatternParser` 써야겠네
- 지표 추적해야 할 때 Micrometer 적극 활용하자

