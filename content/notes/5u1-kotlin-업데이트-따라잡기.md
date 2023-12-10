---
title: 5u1. Kotlin 업데이트 따라잡기
---
1.4버전까지는 책 [Atomic Kotlin](https://www.atomickotlin.com/)으로 커버했으므로 1.5 변경사항부터 유용해보이는걸 정리해보자.


TODO: 1.5.2부터 추가


# [What's new in Kotlin 1.5.20](https://kotlinlang.org/docs/whatsnew1520.html)





## [What's new in Kotlin 1.5.0](https://kotlinlang.org/docs/whatsnew15.html)

### `@JvmRecord`

`data class`에 `@JvmRecord` 애노테이션을 붙이면 자바에서 record 클래스처럼 사용할 수 있음.

### `sealed interface`

`sealed class`와 동일함. 이 인터페이스는 같은 파일 내에서만 implement 할 수 있다. 인터페이스를 구현하는 장소가 하나의 파일로 제한되므로 컴파일러가 구현의 모든 케이스를 검증할 수 있어서 `when`에서 모든 케이스를 다루는지 다루지 않는지 검사할 수 있다.

상속을 피하라는 이유중 하나는 누가 어디서 어떻게 상속하는지 추적이 안 되어서 자바의 `instanceof`를 사용해 타입으로 분기하는 코드가 변경에 취약하다는 것이다. 하지만 컴파일러가 상속의 모든 케이스를 알 수 있어서 코딩할 때 컴파일러의 도움을 받을 수 있다면 타입으로 분기하는 코드를 안전하게 사용할 수 있다.

패턴매칭(`when`)을 활용하기 편해짐.

### `sealed class`를 상속한 클래스를 선언할 수 있는 범위가 파일에서 패키지 단위로 넓어졌다

동일한 파일에서 동일한 컴파일 단위(=패키지, 동일한 디렉토리)로 범위가 넓어졌다. 좋네.

### inline classes

`value class Password(val s: String)`

프로퍼티를 하나만 갖는 value class를 선언할 수 있다. `typealias`와 유사한 용도로 사용하면 된다. 어떤 타입을 다른 이름으로 선언해서 도메인 언어를 더 풍부하게 사용하고 싶을 때 `value class`를 사용하면 됨. `typealias`와 다른 점은 다른 타입을 할당할 수 없다는 점이다. https://kotlinlang.org/docs/inline-classes.html#inline-classes-vs-type-aliases

```kotlin
var password = Password("don't do this on production")
password = "plain string" // 불가능
```

inline class라고 불리는 이유는 실행시간(runtime)에 `Password`라는 클래스의 인스턴스를 생성하는게 아니기 때문이다.

```kotlin
class UseInlineClass {  
    fun useInlineClass() {  
        val inlineClass = InlineClass("inline class")  
        println(inlineClass.getValue())  
  
        val basicClass = BasicClass("basic class")  
        println(basicClass.getValue())  
    }  
}
```

위 코드를 컴파일하고 자바 코드로 디컴파일하면 아래처럼 나온다.

```java
public final class UseInlineClass {  
   public final void useInlineClass() {  
      String inlineClass = InlineClass.constructor-impl("inline class");  
      System.out.println(InlineClass.getValue-impl(inlineClass));  
      
      BasicClass basicClass = new BasicClass("basic class");  
      System.out.println(basicClass.getValue());  
   }  
}
```

`new`로 클래스를 만드는게 아니라 `constructor-impl`함수를 호출해서 `String`을 받는다. `constructor-impl`함수는 아래처럼 생겼음.

```java
public final class InlineClass {
  ...
  
@NotNull  
  public static String constructor_impl/* $FF was: constructor-impl*/(@NotNull String value) {  
     Intrinsics.checkNotNullParameter(value, "value");  
     return value;  
  }
  
  ...
}
```

함수 호출을 하는 오버헤드는 있지만 객체 생성을 하지 않기 때문에 추가로 메모리를 사용하지 않는다.

최범균님의 책에서는 id클래스를 자바 기본 타입인 `Long`이 아니라 엔티티별로 id 클래스를 만들어서 사용한다. id를 구분할 때 타입으로 구분할 수 있어서 함수 매개변수에 여러 개의 id를 넣어야 할 때 실수하지 않을 수 있지만 `@GeneratedValue(strategy = GenerationType.IDENTITY)`를 사용할 수 없어서 auto increment를 적용할 수 없었기 때문에 사용하지 못했다.

spring-data-commons 3.2.0부터는 kotlin value class를 지원하기 때문에 위 문제를 해결할 수 있을 것으로 보임: https://github.com/spring-projects/spring-data-commons/releases , - Add support for Kotlin Value Classes [#2866](https://github.com/spring-projects/spring-data-commons/pull/2866)




### SAM(Single Abstract Method) adapters via invokedynamic

https://kotlinlang.org/docs/whatsnew15.html#sam-adapters-via-invokedynamic

SAM 인터페이스를 구현하는 객체에 대해서 컴파일 할 때 wrapper 클래스를 생성하지 않고 `invokedynamic` jvm instruction을 사용한다.

kotlin lambda에 대해서도 `invokedynamic`을 사용할 수 있긴 하지만 아직 experimental.

### 자바의 nullability 애노테이션에 대한 처리 향상

https://kotlinlang.org/docs/whatsnew15.html#improvements-to-handling-nullability-annotations

코틀린에서 자바로 작성된 클래스를 사용할 때 `@Nullable`, `@NullMarked`등 Java 코드에 붙어있는 nullability 관련 애노테이션을 의미있는 정보로 처리해준다.

지원하는 nullability annotations: https://kotlinlang.org/docs/java-interop.html#nullability-annotations

자바 코드에 JSpecify 써보면 괜찮겠다. 패키지나 클래스에 `@NullMarked` 애노테이션 붙이면 `@Nullable` 애노테이션이 붙어있지 않은 매개변수와 리턴타입은 not null이라고 표현할 수 있음. https://jspecify.dev/docs/user-guide, https://github.com/jspecify/jspecify/blob/eff8f186a7036d5f18108d27e09011a4f1198f05/src/main/java/org/jspecify/annotations/NullMarked.java#L115


### locale에 영향받지 않는 대소문자 변환 함수 추가

https://kotlinlang.org/docs/whatsnew15.html#stable-locale-agnostic-api-for-upper-lowercasing-text

String

|**Earlier versions**|**1.5.0 alternative**|
|---|---|
|`String.toUpperCase()`|`String.uppercase()`|
|`String.toLowerCase()`|`String.lowercase()`|
|`String.capitalize()`|`String.replaceFirstChar { it.uppercase() }`|
|`String.decapitalize()`|`String.replaceFirstChar { it.lowercase() }`|

Char

|**Earlier versions**|**1.5.0 alternative**|
|---|---|
|`Char.toUpperCase()`|`Char.uppercaseChar(): Char`  <br>`Char.uppercase(): String`|
|`Char.toLowerCase()`|`Char.lowercaseChar(): Char`  <br>`Char.lowercase(): String`|
|`Char.toTitleCase()`|`Char.titlecaseChar(): Char`  <br>`Char.titlecase(): String`|


### Path 표현할 때 나누기(`/`) operator를 사용할 수 있음

https://kotlinlang.org/docs/whatsnew15.html#stable-path-api

```
// construct path with the div (/) operator

val baseDir = Path("/base")
val subDir = baseDir / "subdirectory" // list files in a directory

val kotlinFiles: List<Path> = Path("/home/user").listDirectoryEntries("*.kt")
```

예전부터 됐었나본데 1.5.0에서 stable이 되었다.


### 문자 타입(Char)에 메서드 추가

유용한 메서드들이 있네. 숫자인지 문자인지 구분한다든지 

https://kotlinlang.org/docs/whatsnew15.html#new-api-for-getting-a-char-category-now-available-in-multiplatform-code


### `Collections.firstNotNullOf()`

https://kotlinlang.org/docs/whatsnew15.html#new-collections-function-firstnotnullof

`mapNotNull().first()`를 합쳐놓았다.