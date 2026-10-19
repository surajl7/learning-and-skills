import readline from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';

const rl = readline.createInterface({ input, output });

console.log("\nWelcome to JavaScript Bank ATM!!!");
console.log("=".repeat(100) + "\n");

const secretPin = await rl.question('Enter your pin: ');

const options = [
"  1. Balance Enquiry",
"  2. Deposit Amount",
"  3. Withdraw Amount",
"  4. Exit"
];

let balance = 0;

if (Number(secretPin) === 1234) {
    console.log('PIN accepted.');
    
    let userChoice = "";

    while (userChoice !== "4") {
        console.log("-".repeat(100))
        console.log("\nSelect from below options:");
        console.log(options.join("\n"));
        console.log("~".repeat(100));

        userChoice = await rl.question('Enter your choice: ');
        console.log("");

        switch (userChoice) {
            case "1":
                console.log(`==> Your Balance is: ${balance}`);
                break;

            case "2":
                const depAmt = Number(await rl.question("Enter the amount to deposit: "));
                if (!isNaN(depAmt) && depAmt > 0) {
                    balance += depAmt;
                    console.log(`==> Deposited: ${depAmt}. New Balance: ${balance}`);
                } else {
                    console.log("==> Invalid deposit amount.");
                }
                break;

            case "3":
                const wdAmt = Number(await rl.question("Enter the amount to withdraw: "));
                if (!isNaN(wdAmt) && wdAmt > 0 && wdAmt <= balance) {
                    balance -= wdAmt;
                    console.log(`==> Withdrawn: ${wdAmt}. New Balance: ${balance}`);
                } else {
                    console.log("==> Invalid or insufficient funds.");
                }
                break;

            case "4":
                console.log("Thank you for chooing JSBank! Exiting...");
                break;

            default:
                console.log("Invalid selection. Please choose from the menu.");
        }
    }

} else {
    console.log('Invalid PIN.');
}

rl.close();
