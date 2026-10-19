import java.util.*;
public class pattern7
{
public static void main(String[] args)
{
int rows,i,j,n=1;
Scanner s = new Scanner(System.in);
System.out.println("Enter no. rows");

rows = s.nextInt();

for(i=1;i<=rows;i++)
{
for(j=1;j<=i;j++)
{
System.out.print(n +" ");
n++;
}
System.out.println();
}
}
}