
console.log("\nExample for Dictionary:\n")

const car = {
    make: "Toyota",
    model: "Corolla",
    year: 2020
};

for(let key in car){
    console.log(`${key}: ${car[key]}`);
}

console.log("\n" + "=".repeat(100) + "\n");
// ====================================================================================================

console.log("Example for in Arrays:\n");

const a = [1,2,3,4,5];

for (const i in a){
    console.log(a[i]);
}

console.log("\n" + "=".repeat(100) + "\n");
// ====================================================================================================

console.log("Example for associative array:\n");

let arr = {
    name: "Geek",
    age: 10,
    city: "Noida"
};

// Accessing values using keys
console.log(arr.name);
console.log(arr.age);
console.log(arr.city);

console.log("\n" + "=".repeat(100) + "\n");
// ====================================================================================================

console.log("Example for associative array length calculation:\n");

let arr1 = {"apple": 10, "grapes": 20};

arr1["guava"] = 30;
arr1["banana"] = 40;

// Printing the array
// Returned by keys() method
console.log(Object.keys(arr1));

// Printing the size
console.log("Size = " + Object.keys(arr1).length)

console.log("\n" + "=".repeat(100) + "\n");
// ====================================================================================================

console.log("Example for associative array sorting by its values:\n");

let a1 = []; // Array

// Add elements to it
a1.push({name: 'a', class: 1});
a1.push({name: 'b', class: 9});
a1.push({name: 'c', class: 2});
a1.push({name: 'd', class: 6});

// Custom sorting function
let sortedList = a1.sort(function(a,b){
    return a.class - b.class;
});

console.log(sortedList);

console.log("\n" + "=".repeat(100) + "\n");
// ====================================================================================================

console.log("Example for associative array Key list:\n");

// Input Associative Array
let scilist = {
    Newton: "Gravity",
    Albert: "Energy",
    Edison: "Bulb",
    Telsa: "AC",
};

// Getting keys using getOwnPropertyNames
const keys = Object.getOwnPropertyNames(scilist);
const values = Object.values(scilist);

console.log(scilist);

// Display output
console.log("Keys are listed below:");
console.log(keys);

console.log("Values are listed below:");
console.log(values);
