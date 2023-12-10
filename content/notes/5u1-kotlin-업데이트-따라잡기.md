---
title: 5u1. Kotlin 업데이트 따라잡기
---
1.4버전까지는 책 [Atomic Kotlin](https://www.atomickotlin.com/)으로 커버했으므로 1.5 변경사항부터 유용해보이는걸 정리해보자.


TODO: 1.5.2부터 추가


## [What's new in Kotlin 1.8.20](https://kotlinlang.org/docs/whatsnew1820.html)

### inline class의 생성자에 body 추가 (experimental)

이전까지는 생성자만 사용할 수 있고 생성자 내부에서 



## [What's new in Kotlin 1.8.0](https://kotlinlang.org/docs/whatsnew18.html)

K2 컴파일러 작업하느라 언어 변경사항이 많지 않은듯.

### Java Optional 객체에 추가한 확장함수가 stable

1.7.0에 experimental이었던 기능



## [What's new in Kotlin 1.7.20](https://kotlinlang.org/docs/whatsnew1720.html)

### 열린 구간(open-ended) operator `..<` 추가 (experimental)

```kotlin
when (value) {
    in 0.0..<0.25 -> // First quarter
    in 0.25..<0.5 -> // Second quarter
    in 0.5..<0.75 -> // Third quarter
    in 0.75..1.0 ->  // Last quarter  <- Note closed range here
}
```


### inline class에 generic 추가 (experimental)

```kotlin
@JvmInline
value class UserId<T>(val value: T)

fun compute(s: UserId<String>) {} // Compiler generates fun compute-<hashcode>(s: Any?)
```


### kapt도 IR Backend를 사용할 수 있다 (experimental)

코틀린 컴파일러 백엔드

gradle.properties

```
kapt.use.jvm.ir=true
```



## [What's new in Kotlin 1.7.0](https://kotlinlang.org/docs/whatsnew18.html)

### Kotlin K2 컴파일러 alpha버전 릴리즈

https://kotlinlang.org/docs/whatsnew17.html#new-kotlin-k2-compiler-for-the-jvm-in-alpha

기존 컴파일러보다 2배 이상 빠르네

`-Xuse-k2`

### inline class에 delegation을 쓸 수 있다

```kotlin
interface Bar {
    fun foo() = "foo"
}

@JvmInline
value class BarWrapper(val bar: Bar): Bar by bar

fun main() {
    val bw = BarWrapper(object: Bar {})
    println(bw.foo())
}
```


### 타입 파라미터에 `_` 로 추론을 할 수 있다

```kotlin
abstract class SomeClass<T> {
    abstract fun execute(): T
}

class SomeImplementation : SomeClass<String>() {
    override fun execute(): String = "Test"
}

class OtherImplementation : SomeClass<Int>() {
    override fun execute(): Int = 42
}

object Runner {
    inline fun <reified S: SomeClass<T>, T> run(): T {
        return S::class.java.getDeclaredConstructor().newInstance().execute()
    }
}

fun main() {
    // T is inferred as String because SomeImplementation derives from SomeClass<String>
    val s = Runner.run<SomeImplementation, _>()
    assert(s == "Test")

    // T is inferred as Int because OtherImplementation derives from SomeClass<Int>
    val n = Runner.run<OtherImplementation, _>()
    assert(n == 42)
}
```


### Definitely non-nullable types (stable)

generic 타입 파라미터에 nullable 타입을 넣어도 매개변수에 null값이 들어오지 않도록 강제할 수 있다. `T & Any`

```kotlin
fun <T> elvisLike(x: T, y: T & Any): T & Any = x ?: y

fun main() {
    // OK
    elvisLike<String>("", "").length
    // Error: 'null' cannot be a value of a non-null type
    elvisLike<String>("", null).length

    // OK
    elvisLike<String?>(null, "").length
    // Error: 'null' cannot be a value of a non-null type
    elvisLike<String?>(null, null).length
}
```


### `DeepRecursiveFunction`이 stable

1.4.0에 추가된 `DeepRecursiveFunction`이 stable이 되었다.

`DeepRecursiveFunction` 을 사용하는 재귀함수는 stack을 heap에 쌓기 때문에 깊게 재귀를 들어가도 stack overflow를 피할 수 있다.

```kotlin
class Tree(val left: Tree?, val right: Tree?)

val calculateDepth = DeepRecursiveFunction<Tree?, Int> { t ->
    if (t == null) 0 else maxOf(
        callRecursive(t.left),
        callRecursive(t.right)
    ) + 1
}

fun main() {
    // Generate a tree with a depth of 100_000
    val deepTree = generateSequence(Tree(null, null)) { prev ->
        Tree(prev, null)
    }.take(100_000).last()

    println(calculateDepth(deepTree)) // 100000
}
```

위 예제에서는 10만번을 들어가지만 stack overflow가 발생하지 않는다.

1000이상의 깊이에서는 `DeepRecursiveFunction`을 사용하는걸 추천.


### Java의 `Optional` 타입에 대한 확장함수 추가 (experimental)

https://kotlinlang.org/docs/whatsnew17.html#new-experimental-extension-functions-for-java-optionals

- getOrNull
- getOrDefault
- getOrElse
- toList
- toSet
- asSequence
- toCollection


### 정규표현식에서 group에 이름 짓기

이런게 됐었구나.. JS와 Native에서도 된다고 함.

```kotlin
fun main() {
    val regex = "\\b(?<city>[A-Za-z\\s]+),\\s(?<state>[A-Z]{2}):\\s(?<areaCode>[0-9]{3})\\b".toRegex()
    val input = "Coordinates: Austin, TX: 123"
    val match = regex.find(input)!!
    println(match.groups["city"]?.value) // "Austin" — by name
    println(match.groups[2]?.value) // "TX" — by number
}
```

backrefernce. 이전에 찾은 값과 동일해야만 매칭이 된다.

```kotlin
fun backRef() {
    val regex = "(?<title>\\w+), yes \\k<title>".toRegex()
    val match = regex.find("Do you copy? Sir, yes Sir!")!!
    println(match.value) // "Sir, yes Sir"
    println(match.groups["title"]?.value) // "Sir"
}
```

replace에서도 named group을 사용할 수 있음

```kotlin
fun dateReplace() {
    val dateRegex = Regex("(?<dd>\\d{2})-(?<mm>\\d{2})-(?<yyyy>\\d{4})")
    val input = "Date of birth: 27-04-2022"
    println(dateRegex.replace(input, "\${yyyy}-\${mm}-\${dd}")) // "Date of birth: 2022-04-27" — by name
    println(dateRegex.replace(input, "\$3-\$2-\$1")) // "Date of birth: 2022-04-27" — by number
}
```


### 자바의 SAM 메서드의 첫 번째 매개변수를 코틀린에서  `this`로 받을 수 있는 gradle plugin

https://kotlinlang.org/docs/whatsnew17.html#the-sam-with-receiver-plugin-is-available-via-the-plugins-api

```java
public @interface SamWithReceiver {}

@SamWithReceiver
public interface TaskRunner {
    void run(Task task);
}
```


```kotlin
fun test(context: TaskContext) {
    val runner = TaskRunner {
        // Here 'this' is an instance of 'Task'

        println("$name is started")
        context.executeTask(this)
        println("$name is finished")
    }
}
```




## [What's new in Kotlin 1.6.20](https://kotlinlang.org/docs/whatsnew1620.html)

### context receiver prototype 추가

React의 Context API와 유사하네. 아직 prototype이라 production code에서 사용할 수 없음.

```kotlin
interface LoggingContext {
  val log: Logger // This context provides a reference to a logger
}

context(LoggingContext)
fun startBusinessOperation() {
  // You can access the log property since LoggingContext is an implicit receiver
  log.info("Operation has started")
}

fun test(loggingContext: LoggingContext) {
  with(loggingContext) {
    // You need to have LoggingContext in a scope as an implicit receiver
    // to call startBusinessOperation()
    startBusinessOperation()
  }
}
```


### Definitely non-nullable types (beta)

generic 타입 파라미터에 nullable 타입을 넣어도 매개변수에 null값이 들어오지 않도록 강제할 수 있다. `T & Any`

아직 beta

```kotlin
fun <T> elvisLike(x: T, y: T & Any): T & Any = x ?: y

fun main() {
    // OK
    elvisLike<String>("", "").length
    // Error: 'null' cannot be a value of a non-null type
    elvisLike<String>("", null).length

    // OK
    elvisLike<String?>(null, "").length
    // Error: 'null' cannot be a value of a non-null type
    elvisLike<String?>(null, null).length
}
```

### 코틀린 인터페이스에 선언한 non-abstract property를 Java에서 default method로 사용할 수 있게 하는 방법 추가

원래는 컴파일러 옵션에 `-Xjvm-default=all-compatibility`를 추가하고 인터페이스에 `@JvmDefaultWithoutCompatibility`를 붙여야만 했었다. 이렇게 하면 새로 추가되는 모든 인터페이스에 `@JvmDefaultWithoutCompatibility`를 붙여줘야 해서 까먹기 쉬웠음.

1.6.20부터는 컴파일러 옵션에 `-Xjvm-default=all` 을 추가해서 모든 interface에 `@JvmDefaultWithoutCompatibility`를 붙일 수 있음. 컴파일러 옵션만 추가하면 non-abstract property를 Java에서 default method로 사용할 수 있다.


### 하나의 모듈에 대한 병렬 컴파일 옵션 추가

https://kotlinlang.org/docs/whatsnew1620.html#support-for-parallel-compilation-of-a-single-module-in-the-jvm-backend

`-Xbackend-threads`

거대한 single module에 대해서 병렬 컴파일을 하면 속도가 최대 15% 상승할 수 있음.

이미 gradle module로 여러 개의 모듈을 쪼개놓은 상태라면 gradle에서 모듈별로 알아서 병렬로 컴파일하므로 이 옵션을 켜면 오히려 속도가 느려질 수 있다, thread의 context switch때문에.

`kapt`를 사용하고 있으면 적용 못함.


### annotation class에 대한 객체 생성 기능이 stable

https://kotlinlang.org/docs/whatsnew1620.html#instantiation-of-annotation-classes




## [What's new in Kotlin 1.6.0](https://kotlinlang.org/docs/whatsnew16.html)

### experimental -> stable

- 1.5.30에 추가되었던 `when`절의 sealed, boolean 객체에 대한 경고 처리
- 1.5.30에 추가되었던 `suspend`함수를 부모타입으로 가질 수 있는 기능

더 이상 experimental이 아니다

### 클래스 타입 파라미터에 대한 어노테이션 추가

https://kotlinlang.org/docs/whatsnew16.html#support-for-annotations-on-class-type-parameters

```kotlin

@Target(AnnotationTarget.TYPE_PARAMETER)
annotation class BoxContent

class Box<@BoxContent T> {}
```


### `@Repeatable` 어노테이션에 대한 자바 호환성 향상

- `@java.lang.annotation.Repeatable`
- `@kotlin.annotation.Repeatable`

동일한 어노테이션을 여러 번 선언할 수 있게 해주는 `@Repeatable` 어노테이션. 자바와 코틀린 둘다 있었지만 코틀린 1.6.0 전까지는 자바의 `@Repeatable` 어노테이션을 코틀린에서 인식하지 못했음. 이제는 된다.


### `readln(), readlnOrNull()` 함수 추가

|**Earlier versions**|**1.6.0 alternative**|**Usage**|
|---|---|---|
|`readLine()!!`|`readln()`|Reads a line from stdin and returns it, or throws a `RuntimeException` if EOF has been reached.|
|`readLine()`|`readlnOrNull()`|Reads a line from stdin and returns it, or returns `null` if EOF has been reached.|


### `typeof<T>()`가 stable

`KType` 객체를 리턴하는 `typeof<T>()`

```kotlin
inline fun <reified T> renderType(): String {
  val type = typeOf<T>()
  return type.toString()
}

fun main() {
  val fromExplicitType = typeOf<Int>()
  val fromReifiedType = renderType<List<Int>>()
}
```

### collection builder가 stable

`buildMap()`, `buildList()`, `buildSet()` 을 더 이상 opt-in 어노테이션 없이도 사용할 수 있다.


### `Regex.splitToSequence(CharSequence)`, `CharSequence.splitToSequence(Regex)`가 stable


### Bit rotation 함수가 stable

```kotlin
val number: Short = 0b10001
println(number
        .rotateRight(2)
        .toString(radix = 2)) // 100000000000100
println(number
        .rotateLeft(2)
        .toString(radix = 2))  // 1000100
```

### Kover, 코틀린을 위한 코드 커버리지 툴 (JaCoCo같은거)

https://kotlinlang.org/docs/whatsnew16.html#kover-a-code-coverage-tool-for-kotlin

gradle plugin으로 사용할 수 있다. 아직 experimental

JaCoCo에서 잘 처리하지 못했던 inline function등에 대한 처리를 할 수 있음.




## [What's new in Kotlin 1.5.30](https://kotlinlang.org/docs/whatsnew1530.html)


### selaed 객체 및 boolean 객체를 `when` 절에서 사용할 때 모든 케이스를 다루지 않으면 경고가 발생한다 (experimental)

아직까지는 experimental.

`enum` 에는 이미 적용되어 있음.

### `suspend` 함수를 부모 타입으로 가질 수 있다 (experimental)

```kolint
class MyClass: suspend () -> Unit {
  override suspend fun invoke() { TODO() }
}
```

함수 객체가 `suspend () -> Unit` 타입을 상속한다


### 재귀적인 generic type에 대한 처리 향상

https://kotlinlang.org/docs/whatsnew1530.html#improvements-to-type-inference-for-recursive-generic-types

언젠가 쓸 일이 있겠지

### nullability 어노테이션의 경고 수준을 정할 수 있다

무시할건지, warn으로 경고로 처리할건지, strict로 에러로 처리할건지

https://kotlinlang.org/docs/whatsnew1530.html#improved-nullability-annotation-support-configuration


### 정규표현식과 매치되는 문자열의 index 위치를 검사하는 메서드 추가

https://kotlinlang.org/docs/whatsnew1530.html#splitting-regex-to-a-sequence

- `Regex.matchAt(input: CharSequence, index: Int): MatchResult?`
- `Regex.matchesAt(input: CharSequence, index: Int): Boolean`

`input`에서 `index`위치에 정규표현식을 만족하는 문자열이 있는지.


### `Regex.splitToSequence()` 추가 (`split()`의 lazy 버전)

`List`가 아니라 `Sequence`를 리턴한다.



## [What's new in Kotlin 1.5.20](https://kotlinlang.org/docs/whatsnew1520.html)

### JSpecify nullness 어노테이션 지원

https://kotlinlang.org/docs/whatsnew1520.html#support-for-jspecify-nullness-annotations

자바 코드에 JSpecify 써보면 괜찮겠다. 패키지나 클래스에 `@NullMarked` 어노테이션 붙이면 `@Nullable` 어노테이션이 붙어있지 않은 매개변수와 리턴타입은 not null이라고 표현할 수 있음. https://jspecify.dev/docs/user-guide, https://github.com/jspecify/jspecify/blob/eff8f186a7036d5f18108d27e09011a4f1198f05/src/main/java/org/jspecify/annotations/NullMarked.java#L115


## [What's new in Kotlin 1.5.0](https://kotlinlang.org/docs/whatsnew15.html)

### `@JvmRecord`

`data class`에 `@JvmRecord` 어노테이션을 붙이면 자바에서 record 클래스처럼 사용할 수 있음.

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

아래처럼 `@Id`를 `Long`타입에 놓고 property에서 value class를 리턴하도록 하면 위 목적을 달성할 수 있음

```kotlin
@MappedSuperclass  
abstract class BaseEntity<T>(  
    @field:Transient  
    protected var idConstructor: (id: Long) -> T,  
) {  
  
    @Id  
    @GeneratedValue(strategy = GenerationType.IDENTITY)  
    @Column(name = "id")  
    val _id: Long = 0L  
    val id: T  
        get() = idConstructor(_id)
    
    /**  
     * 자식 클래스에서 postLoad에서 idConstructor를 넣어줘야 id property를 조회할 때 에러가 발생하지 않는다.  
     * 예)  
     *   override fun postLoad() {
     *     this.idConstructor = ::ArticleId
     *   }
     **/
     @PostLoad  
     protected abstract fun postLoad()  
}
```


### SAM(Single Abstract Method) adapters via invokedynamic

https://kotlinlang.org/docs/whatsnew15.html#sam-adapters-via-invokedynamic

SAM 인터페이스를 구현하는 객체에 대해서 컴파일 할 때 wrapper 클래스를 생성하지 않고 `invokedynamic` jvm instruction을 사용한다.

kotlin lambda에 대해서도 `invokedynamic`을 사용할 수 있긴 하지만 아직 experimental.

### 자바의 nullability 어노테이션에 대한 처리 향상

https://kotlinlang.org/docs/whatsnew15.html#improvements-to-handling-nullability-annotations

코틀린에서 자바로 작성된 클래스를 사용할 때 `@Nullable`등 Java 코드에 붙어있는 nullability 관련 어노테이션을 의미있는 정보로 처리해준다.

지원하는 nullability annotations: https://kotlinlang.org/docs/java-interop.html#nullability-annotations


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