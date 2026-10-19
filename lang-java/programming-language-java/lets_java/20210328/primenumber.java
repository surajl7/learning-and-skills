import java.util.*;
public class primenumber
{
public static void main(String[] args)
{
int i,n,count=0;
System.out.print("Enter any Number= ");
Scanner s = new Scanner(System.in);
n = s.nextInt();

for(i=1;i<=n;i++)
{
if(n%i==0)
{
count++;
}
}
if(count == 2)
{
System.out.print(n+" is a prime number");
}
else
{
System.out.print(n+" is not a prime number");
}
}
}