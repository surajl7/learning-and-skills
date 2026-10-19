// JavaScript Function Object Examples

console.log("JavaScript Function object examples: ")
console.log("=".repeat(100))
// =====================================================================================================

// Example 1:

var add = new Function("num1","num2","return num1+num2");
console.log("Addition of 2 and 5: " + add(2,5));

console.log("=".repeat(100))
// =====================================================================================================

// Example 2:

var pow = new Function("num1", "num2", "return Math.pow(num1, num2)");
console.log("3 to the Power of 2: " + pow(2,3));