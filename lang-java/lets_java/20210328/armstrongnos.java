import java.util.*;
public class armstrongnos
{
public static void main(String[] args)
{
int n,sum=0,rem, temp;
Scanner s = new Scanner(System.in);

System.out.print("Enter any Number= ");
n = s.nextInt();
temp = n;

while(n>0)
{
rem = n%10;
sum = sum +(rem*rem*rem);
n /= 10;
}

if (temp == sum)
{
System.out.println("Number is Armstrong");
}
else
{
System.out.println("Number is not Armstrong");
}
}
}