import java.util.*;
public class simple_interest
{
public static void main(String[] args)
{
Scanner s = new Scanner(System.in);

/*formula for Simple Interest is
Simple Interest = P * R * T / 100
Where,
P = Principal Amount
R = Rate of intrest
T = Time period of the Loan/Deposite in years.
*/

System.out.println("Enter Principal Amount");
float p = s.nextFloat();

System.out.println("Enter Rate of Intrest");
float r = s.nextFloat();

System.out.println("Enter Time period");
float t = s.nextFloat();

double si = p * r * t / 100;
System.out.println("Simple Interest = "+si);
}
}