public class sorting_array
{
public static void main(String[] args)
{
int i,j,temp;
int a[]={10,20,70,40,50};

System.out.println();
System.out.println("Before Sorting");
for(i=0;i<a.length;i++)
{
System.out.println("a[" +i +"]= " +a[i]);
}
System.out.println();

System.out.println("After Sorting");
for(i=0;i<a.length;i++)
{
for(j=i+1;j<a.length;j++)
{
if(a[i] > a[j])
{
temp = a[i];
a[i] = a[j];
a[j] = temp;
}
}
System.out.println("a[" +i +"]= " +a[i]);
}
}
}
