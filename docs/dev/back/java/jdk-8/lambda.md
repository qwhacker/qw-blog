## Lambda表达式

为什么使用Lambda表达式

Lambda是一个匿名函数，我们可以把Lambda表达式理解为是一段可以传递的代码（将代码像数据一样进行传递）。可以写出更简洁、更灵活的代码。作为一种更紧凑的代码风格，使Java的语言表达能力得到提升。

1.Lambda表达式的基础语法：java8中引入了一个新的操作符“->”该操作符称为箭头操作符或Lambda操作符，

箭头操作符将Lambda表达式拆分成两部分：

左侧：Lambda表达式的参数列表

右侧：Lambda表达式中所需执行的功能，即Lambda体

语法格式一：无参数，无返回值
`() -> System.out.println("Hello Lambda!");`
语法格式二：有一个参数，无返回值
`(x) -> System.out.println(x)`
语法格式三：若只有一个参数，小括号可以省略不写
`x -> System.out.println(x)`
语法格式四：有两个参数以上，有返回值，并且Lambda体中有多条语句
```java
Comparator<Integer> com = (x, y) -> {
    System.out.println("多行语句");
    return Integer.compare(x, y);
};
```
语法格式五：若Lambda体中有一条语句，return和大括号都可以省略不写
`Comparator<Integer> com = (x, y) ->  Integer.compare(x, y);`
语法格式六：Lambda表达式的参数列表的数据类型可以省略不写，因为JVM编译器通过上下文推断出，数据类型，即“类型推断”
`Comparator<Integer> com = (Integer x, Integer y) ->  Integer.compare(x, y);`

上联：左右遇一括号省

下联：左侧推断类型省

横批：能省则省

2.Lambda表达式需要“函数式接口”的支持

函数式接口：接口中只有一个抽象方法的接口，称为函数式接口

可以使用注解@FunctionalInterface修饰，可以检查是否是函数式接口

例子：
```java
List<Employee> emps = Arrays.asList(
        new Employee(101, "zhangsan", 30, 9999.99),
        new Employee(102, "lisi", 25, 8888.88),
        new Employee(103, "wangwu", 18, 3333.33),
        new Employee(104, "zhaoliu", 22, 7777.77),
        new Employee(105, "tianqi", 44, 5555.55)
);

@Test
public void test0001() {
    Collections.sort(emps, (e1, e2) -> {
        if (e1.getAge() == e2.getAge()) {
            return e1.getName().compareTo(e2.getName());
        } else {
            return -Integer.compare(e1.getAge(), e2.getAge());
        }
    });
    emps.forEach(System.out::println);
}

@Test
public void test0002() {
    String trimStr = handlerString("\t\t\tLambda Expression", (str) -> str.trim());
    System.out.println(trimStr);
    String upper = handlerString("abcdef", (str) -> str.toUpperCase());
    System.out.println(upper);
    String subStr = handlerString("Lambda Expression", (str) -> str.substring(7, 17));
    System.out.println(subStr);
}

//需求：用于处理字符串
public String handlerString(String str, IFunction ifun) {
    return ifun.getValue(str);
}

@FunctionalInterface
public interface IFunction {
    public String getValue(String str);
}

@Test
public void test0003() {
    calc(100L, 200L, (x, y) -> x + y);
    calc(100L, 200L, (x, y) -> x - y);
    calc(100L, 200L, (x, y) -> x * y);
    calc(100L, 200L, (x, y) -> x / y);
    calc(100L, 200L, (x, y) -> x % y);
}

//需求：用于计算两个long型数字的值
public void calc(Long l1, Long l2, IFunction2<Long,Long> ifun) {
    System.out.println(ifun.getValue(l1, l2));
}

@FunctionalInterface
public interface IFunction2<T, R> {
    public R getValue(T t1, T t2);
}
```

Java8内置的四大核心函数式接口
Consumer<T>：消费型接口
    void accept(T t);
Supplier<T>：供给型接口
    T get();
Function<T,R>：函数型接口
    R apply(T t);
Predicate<T>：断言型接口
    boolean test(T t);
```java
//Consumer<T> 消费型接口
@Test
public void test0004() {
    happy(10000, (money) -> System.out.println("出去游玩，一共花费了" + money + "元"));
}

public void happy(double money, Consumer<Double> con) {
    con.accept(money);
}

//Supplier<T> 供给型接口
@Test
public void test0005() {
    List<Integer> numList = getNumList(10, () -> (int) (Math.random() * 100));
    numList.forEach(System.out::println);
}

//需求：产生指定个数的整数，并放入集合中
public List<Integer> getNumList(int num, Supplier<Integer> sup) {
    List<Integer> list = new ArrayList<>();
    for (int i = 0; i < num; i++) {
        list.add(sup.get());
    }
    return list;
}

//Function<T,R> 函数型接口
@Test
public void test0006() {
    String strHandler = strHandler("Lambda Expression", (str) -> str.toUpperCase());
    System.out.println(strHandler);
}

//需求：用于处理字符串
public String strHandler(String str, Function<String, String> ifun) {
    return ifun.apply(str);
}

//Predicate<T> 断言型接口
@Test
public void test0007() {
    List<String> list = Arrays.asList("Hello", "Lambda", "Function");
    List<String> strings = filterStr(list, (s) -> s.length() > 5);
    strings.forEach(System.out::println);
}

//需求：将满足条件的字符串，放入集合中
public List<String> filterStr(List<String> list, Predicate<String> pre) {
    List<String> strList = new ArrayList<>();
    for (String s : list) {
        if (pre.test(s)) {
            strList.add(s);
        }
    }
    return strList;
}
```

方法引用
若Lambda体中的内容有方法已经实现了，我们可以使用“方法引用”（可以理解为方法引用是Lambda表达式的另外一种表现形式），
使用操作符“：：”将方法名和对象或类的名字分隔开来
主要有三种语法格式：
对象：：实例方法名
类：：静态方法名
类：：实例方法名

注意：
1.Lambda体中调用方法的参数列表与返回值类型，要与函数式接口中抽象方法的参数列表和返回值类型保持一致
2.若Lambda参数列表中的第一个参数是实例方法的调用者，而第二个参数是实例方法的参数时，可以使用ClassName::method
```java
//方法引用
@Test
public void test0008() {
    //对象::实例方法名
    Consumer<String> con = (x) -> System.out.println(x);
    Consumer<String> con1 = System.out::println;

    Employee emp = new Employee();
    Supplier<String> sup = () -> emp.getName();
    Supplier<Integer> sup1 = emp::getAge;

    //类::静态方法名
    Comparator<Integer> com = (x, y) -> Integer.compare(x, y);
    Comparator<Integer> com1 = Integer::compare;

    //类::实例方法名
    BiPredicate<String, String> bp = (x, y) -> x.equals(y);
    BiPredicate<String, String> bp1 = String::equals;
}
```

构造器引用
格式：
ClassName::new
注意：需要调用的构造器的参数列表要与函数式接口中抽象方法的参数列表保持一致

数组引用
格式：
Type::new;
```java
@Test
public void test0009() {
    //构造器引用
    Supplier<Employee> sup = () -> new Employee();
    Supplier<Employee> sup1 = Employee::new;

    //数组引用
    Function<Integer, String[]> fun = (x) -> new String[x];
    Function<Integer, String[]> fun1 = String[]::new;
}
```


