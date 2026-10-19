import java.util.*;
public class addofnos
{
public static void main(String[] args)
{
int i,sum=0,n;

System.out.print("Enter Number= ");
Scanner s = new Scanner(System.in);
n = s.nextInt();

for(i=1;i<=n;i++)
{
sum += i;
}
System.out.println("Addition = "+sum);
}
}