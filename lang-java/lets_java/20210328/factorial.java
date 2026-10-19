import java.util.*;
public class factorial
{
public static void main(String[] args)
{
int n,i,fact=1;
Scanner s = new Scanner(System.in);

System.out.print("Enter any Number= ");

n = s.nextInt();

for(i=1;i<=n;i++)
{
fact*=i;
}
System.out.println(n +"!" +" = " +fact);
}
}