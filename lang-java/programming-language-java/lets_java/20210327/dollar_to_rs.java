import java.util.*;
public class dollar_to_rs
{
public static void main(String[] args)
{
Scanner s = new Scanner(System.in);

System.out.println("Enter amount in dollar");
float d = s.nextFloat();

double r = d * 65;
System.out.println("Amount in dollar = "+d +" & " +"Amount in Ruppes = "+r);
}
}
