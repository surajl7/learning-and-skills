import java.util.*;
public class areaofrectangle
{
public static void main(String[] args)
{
Scanner s = new Scanner(System.in);

System.out.println("Enter Length of Rectangle");
float l = s.nextFloat();

System.out.println("Enter breadth of Rectangle");
float b = s.nextFloat();

double area = l * b;
System.out.println("Area of Rectangle = "+area);
}
}