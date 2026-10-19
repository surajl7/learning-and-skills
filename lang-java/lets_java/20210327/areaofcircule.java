import java.util.*;
public class areaofcircule
{
public static void main(String[] args)
{

Scanner s = new Scanner (System.in);
System.out.println("Enter the radius of Circule");
float r = s.nextFloat();

double area = 3.14*r*r;
System.out.println("Area of circule = "+area);
}
}