import java.util.*;
public class pattern1
{
public static void main(String [] args)
{
int rows,i,j;
Scanner s = new Scanner(System.in);
System.out.println("Enter no. of rows = ");
rows = s.nextInt();

for(i=0;i<rows;i++)
{
for(j=0;j<=i;j++)
{
System.out.print("* ");
}
System.out.println(" ");
}
}
}