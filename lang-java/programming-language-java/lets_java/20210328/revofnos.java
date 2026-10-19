import java.util.*;
public class revofnos
{
public static void main(String[] args)
{
int n,rev=0,rem;
Scanner s = new Scanner(System.in);

System.out.print("Enter any Number= ");
n = s.nextInt();

while(n>0)
{
rem = n%10;
rev = rev*10+rem;
n /= 10;
}

System.out.print("Reverse of Number = "+rev);
}
}