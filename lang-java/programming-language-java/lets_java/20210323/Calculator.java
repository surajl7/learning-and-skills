class Calculator
{
public static void main(String[]args)
{
int no1=15, no2=5, ans;

ans=no1 + no2;
System.out.println("Addition= "+ans);

ans=no1 - no2;
System.out.println("Substration= "+ans);

ans=no1 * no2;
System.out.println("Multiplication= "+ans);

ans=no1 / no2;
System.out.println("Division= "+ans);

ans=no1 % no2;
System.out.println("modulation= "+ans);

ans=no1++;
System.out.println("Incremented Value= "+no1);

ans=no1--;
System.out.println("Decremented Value= "+no1);
}
}