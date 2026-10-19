import java.util.*;
public class Searching_in_array
{
public static int search (int arr[], int x)
{

int n = arr.length;

for(int i=0; i<n;i++)
{
if(arr[i]==x)
return i;
}
return -1;
}

public static void main(String[] args)
{
int arr[] ={2,3,4,10,40};
System.out.println("Enter no. to be Search in array");
Scanner s = new Scanner(System.in);
int x = s.nextInt();


int result = search(arr, x);
if(result == -1)
System.out.print("Element is not present in array");
else
System.out.print("Element is present" +" at index " +result);
}
}

















/*{
public static void main(String[] args)
{
int i,n;
int a[] = {10,20,70,40,50};

System.out.println("Enter no. to be Search in array");
Scanner s = new Scanner(System.in);
n = s.nextInt();

for(i=0;i<a.length-1;i++)
{
if(a[i] == n)
{
System.out.println(n +" is Found in index " +i);
}
else
{
System.out.println(n +" is not Found");
}
}
}
}*/

