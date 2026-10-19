class swapnumbers
{
public static void main(String[] args)
{
int no1=10,no2=30,temp;

System.out.println("  ");

System.out.println("--Before Swap--");
System.out.println("First Number= "+no1);
System.out.println("Second Number= "+no2);

temp=no1;
no1=no2;
no2=temp;

System.out.println("  ");

System.out.println("--After Swap--");
System.out.println("First Number= "+no1);
System.out.println("Second Number= "+no2);
}
}