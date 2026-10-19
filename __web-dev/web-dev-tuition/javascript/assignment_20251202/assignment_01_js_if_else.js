// if(expression){
if(1==1){
    // content to be evaluated
    console.log("output")
}

console.log("=".repeat(100))
// ====================================================================================================

var a = 20;
if(a > 10){
    console.log("Value of a is greater than 10");
}

console.log("=".repeat(100))
// ====================================================================================================

/*
// syntax
if(expression){
    //content to be evaluated if condition is true
}
else{
    //content to be evaluated if condition is false
}
*/

// ====================================================================================================

var a = 20;
if(a%2==0){
    console.log("a is even number");
}
else{
    console.log("a is odd number");
}

console.log("=".repeat(100))

// ====================================================================================================

var a = 20, b = 2, c = 8;
// var a = 20, b = 20, c = 20;

if(a > b && a > c){
    console.log("a is greater");
}
else if(b > a && b > c){
    console.log("b is greater");
}
else if(c > a && c > b){
    console.log("c is greater");
}
else{
    console.log("all are equal");
}

// ====================================================================================================