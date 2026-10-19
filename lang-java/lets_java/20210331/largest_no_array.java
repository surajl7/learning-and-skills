public class largest_no_array
{
public static void main(String[] args)
{
int i,max;
int a[]={10,20,70,40,50};
max=a[0];

for (i=0; i < a.length; i++)
{
System.out.print("a[" +i +"]=" +a[i] + " ");
}

for(i=1; i < a.length; i++)
{
if (a[i]>max)
{
max=a[i];
}
}
System.out.println();
System.out.println("Maximum value = " +max);
}
}