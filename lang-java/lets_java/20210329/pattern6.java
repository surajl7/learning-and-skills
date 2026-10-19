import java.util.*;
public class pattern6
{
public static void main(String[] args)
{
int rows,i,j;
Scanner s = new Scanner(System.in);
System.out.println("Enter no. rows");

rows = s.nextInt();

for(i=rows;i>=1;i--)
{
for(j=1;j<=i;j++)
{
System.out.print(i +" ");
}
System.out.println();
}
}
}