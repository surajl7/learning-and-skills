import java.util.*;
public class pattern2
{
public static void main(String [] args)
{
int rows,i,j;
System.out.println("Enter no. of rows");
Scanner s = new Scanner(System.in);
rows = s.nextInt();

for(i=rows;i>=1;i--)
{
for(j=1;j<=i;j++)
{
System.out.print("* ");
}
System.out.println( );
}
}
}