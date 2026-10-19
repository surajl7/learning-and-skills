import java.util.*;
public class areaofsquare
{
public static void main(String[] args)
{

Scanner s = new Scanner(System.in);

System.out.println("Enter the side of square");
float side = s.nextFloat();

double area = side * side;
System.out.println("Area of Square = "+area);
}
}