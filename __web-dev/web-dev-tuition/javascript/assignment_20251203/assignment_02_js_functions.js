function msg(){
    // alert("Hello! This is a message");
    console.log("Hello! This is a message");
}

msg();

console.log("=".repeat(100))
// =====================================================================================================

// JavaScript Function Arguments

console.log("Get cube of a given number: ")
function getcube(number){
    console.log(number*number*number);
}

getcube(4);

console.log("=".repeat(100))
// =====================================================================================================

// Function with return value
console.log("Function with return value Example: ")

function getInfo(){
    return "Hello! How are you!";
}

console.log(getInfo())