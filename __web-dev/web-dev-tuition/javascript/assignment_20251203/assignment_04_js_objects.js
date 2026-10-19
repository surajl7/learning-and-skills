// JavaScript Objects

/*
// Syntax:
object = {
    property1:value1,
    property2:value2,
    property3:value3,
    .
    .
    .
    propertyN:valueN
}
*/

// JavaScript Object by object literal

emp = {
    id:102,
    name:"Shyam Kumar",
    salary:40000
}
console.log(emp.id + " " + emp.name + " " + emp.salary);

console.log("=".repeat(100));
// ====================================================================================================

// JavaScript Creating instance of object

// Syntax:
// var objectname = new Object();

var emp = new Object();
emp.id = 101;
emp.name = "Ravi Malik";
emp.salary = 500000;

console.log(emp.id + " " + emp.name + " " + emp.salary);

console.log("=".repeat(100));
// ====================================================================================================

// Object creation By using Object constructor

function emp1(id, name, salary){
    this.id = id;
    this.name = name;
    this.salary = salary;
}

e = new emp1(103, "Vimal Jaiswal", 30000);

console.log(e.id + " " + e.name + " " + e.salary);