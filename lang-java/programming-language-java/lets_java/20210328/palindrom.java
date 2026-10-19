import java.util.*;
public class palindrom
{
public static void main(String[] args)
{
int n,rev=0,rem, temp;
Scanner s = new Scanner(System.in);
System.out.print("Enter any Number= ");
n = s.nextInt();
temp = n;

while(n>0)
{
rem = n%10;
rev = rev*10+rem;
n /= 10;
}

if (temp == rev)
{
System.out.println("Number is Palindrom");
}
else
{
System.out.println("Number is not Palindrom");
}
}
}