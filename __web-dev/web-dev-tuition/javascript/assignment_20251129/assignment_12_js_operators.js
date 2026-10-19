// Addition
var sum=10+20;
console.log("Sum of numbers 10 and 20: " + sum);

console.log("=".repeat("100"))

// Subtraction
var sub=20-10;
console.log("Subtraction of numbers 20 and 10: " + sub);

console.log("=".repeat("100"))

// Multiplication
var multi=10*20;
console.log("Multiplication of numbers 10 and 20: " + multi);

console.log("=".repeat("100"))

// Division
var div=20/10;
console.log("Division of numbers 20 and 10: " + div);

console.log("=".repeat("100"))

// Modulus (Remainder)
var mod = 20%10;
console.log("Modulus of 20 and 10: " + mod);

console.log("=".repeat("100"))

// Increment
var a = 10;
console.log("Value of var: " + a)
console.log("Post increment of 10: " + a++);
console.log("Value of var: " + a)
console.log("Pre increment of 10: " + ++a);

console.log("=".repeat("100"))

// Decrement
var b = 10;
console.log("Value of var: " + b)
console.log("Post decrement of 10: " + b--);
console.log("Value of var: " + b)
console.log("Pre decrement of 10: " + --b);

console.log("=".repeat("100"))

// Is equal to
console.log("10==10: " + (10==10))
console.log(`10=="10": ` + (10=="10"))
console.log("10==20: " + (10==20))

console.log("=".repeat("100"))

// Identical (equal and of same type)
console.log("10===10: " + (10===10))
console.log(`10==="10": ` + (10==="10"))
console.log("10===20: " + (10===20))

console.log("=".repeat("100"))

// Not equal to
console.log("10!=10: " + (10!=10))
console.log(`10!="10": ` + (10!="10"))
console.log("10!=20: " + (10!=20))

console.log("=".repeat("100"))

// Not identical
console.log("10!==10: " + (10!==10))
console.log(`10!=="10": ` + (10!=="10"))
console.log("10!==20: " + (10!==20))

console.log("=".repeat("100"))

// Greater than
console.log("10>10: " + (10>10))
console.log(`10>"10": ` + (10>"10"))
console.log("20>10: " + (20>10))

console.log("=".repeat("100"))

// Greater than or equal to
console.log("10>=10: " + (10>=10))
console.log(`10>="10": ` + (10>="10"))
console.log("10>=20: " + (10>=20))

console.log("=".repeat("100"))

// less than
console.log("10<10: " + (10<10))
console.log(`10<"10": ` + (10<"10"))
console.log("10<20: " + (10<20))

console.log("=".repeat("100"))

// less than equal to
console.log("10<=10: " + (10<=10))
console.log(`10<="10": ` + (10<="10"))
console.log("10<=20: " + (10<=20))

console.log("=".repeat("100"))

// Bitwise AND Operators
console.log("AND Operator: " + (10==20 & 20==30));       // AND Operator
console.log("AND Operator: " + (10==10 & 20==20));       // AND Operator
console.log("OR Operator: " + (10==20 | 20==30));        // OR Operator
console.log("OR Operator: " + (10==10 | 20==30));        // OR Operator
console.log("XOR Operator: " + (10==20 ^ 20==30));       // XOR Operator
console.log("XOR Operator: " + (20==20 ^ 20==30));       // XOR Operator
console.log("NOT Operator: " + ((~10)));                 // NOT Operator
console.log("NOT Operator: " + ((~10) == -11));          // NOT Operator
console.log("Left Shift: " + ((10<<2)));                 // Left Shift
console.log("Right Shift: " + ((100>>2)));               // Right Shift
console.log("Right Shift with Zero: " + ((10>>>2)));     // Right Shift with zero

console.log("=".repeat("100"));

// Logical Operators
console.log("Logical AND: " + (10==20 && 20==30));       // Logical AND
console.log("Logical OR: " + (10==20 || 20==30));        // Logical OR
console.log("Logical NOT: " + (!(10==20)));              // Logical NOT

console.log("=".repeat("100"));

// JavaScript Assignment Operators
console.log("Assignment operator: " + (var1=10));
console.log("Value of var1: " + var1);

console.log("=".repeat("100"));

var var2=10;
var2+=20;
console.log("Value of var2 after additon and assign: " + var2);

console.log("=".repeat("100"));

var var3=20;
var3-=10;
console.log("Value of var3 after subtract and assign: " + var3);

console.log("=".repeat("100"));

var var4=10;
var4 *= 20;
console.log("Value of var4 after multiply and assign: " + var4);

console.log("=".repeat("100"));

var var5=10;
var5 /= 2;
console.log("Value of var5 after divide and assign: " + var5);

console.log("=".repeat("100"));

var var6 = 10;
var6 %= 2;
console.log("Value of var6 after modulus and assign: " + var6); // Remainder after division

console.log("=".repeat("100"));

// Conditional (Ternary) Operator (?:)
// Conditional Operator returns value based on the condition. It is like if-else.
var age = 20;
var message = age >= 18 ? "Adult" : "Minor";
console.log("Ternary Operator: " + message); // "Adult"

console.log("=".repeat("100"));

// Comma Operator
var result1, result2 = (1 + 2, 5 + 5);
console.log("Comma Operator: " + result1, result2); // 10

console.log("=".repeat("100"));

console.log("Comma operator in Loop syntax: ")
for (let i = 0, j = 10; i < j; i++, j--) {
  console.log(i, j);
}

console.log("=".repeat("100"));

// delete Operator
var person = {name: "Alice", age: 25}
delete person.age;

console.log(person);    // {name: "Alice"}
console.log("age" in person); //false

console.log("=".repeat("100"));

// in Operator
var car = { make: "Toyota", model: "Camry"};
console.log("make" in car); // true
console.log("year" in car); // false

console.log("=".repeat("100"));

// instanceof Operator
class Animal {}
var dog = new Animal();

console.log(dog instanceof Animal); // true
console.log(dog instanceof Object); // true

console.log("=".repeat("100"));

// new Operator
function Person(name){
    this.name = name;
}

let p = new Person("John");
console.log(p.name); // "John"

console.log("=".repeat("100"));

// typeof Operator
console.log(typeof 123);        // "number"
console.log(typeof "Hello");    // "string"
console.log(typeof true);       // "boolean"
console.log(typeof {});         // "object"
console.log(typeof undefined);  // "undefined"
console.log(typeof null);       // "object" (quirk!)

console.log("=".repeat("100"));

// void Operator
console.log(void 0);       // undefined
console.log(void (5 + 5)); // undefined

console.log("=".repeat("100"));

// yield Operator (inside generator functions)
// checks what is returned in a generator by the generator's iterator.
function* generator() {
  yield 1;
  yield 2;
  return 3;
}

let g = generator();

console.log(g.next()); // { value: 1, done: false }
console.log(g.next()); // { value: 2, done: false }
console.log(g.next()); // { value: 3, done: true }
