import java.util.*;
public class fibonacci_series
{
public static void main(String[] args)
{
int n1=0,n2=1, n3, n, i;
Scanner s = new Scanner(System.in);
System.out.print("Enter any Number= ");
n = s.nextInt();

System.out.print(n1 +" " +n2);

for(i=3;i<=n;i++)
{
n3=n1+n2;
System.out.print(" " +n3);
n1=n2;
n2=n3;
}
}
}