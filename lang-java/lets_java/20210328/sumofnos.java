import java.util.*;
public class sumofnos
{
public static void main(String[] args)
{
int n,sum=0,rem;
Scanner s = new Scanner(System.in);

System.out.print("Enter any Number= ");
n = s.nextInt();

while(n>0)
{
rem = n%10;
sum += rem;
n /= 10;
}

System.out.print("Sum= "+sum);
}
}
