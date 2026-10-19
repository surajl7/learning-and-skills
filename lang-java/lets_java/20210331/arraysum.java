public class arraysum
{
public static void main(String[] args)
{
int i, sum=0;
int a[]={10,20,70,40,50};

for (i=0; i<a.length; i++)
{
System.out.println("a[" +i +"] = " +a[i]);
sum = sum+a[i];
}
System.out.println("Addition= "+sum);
}
}