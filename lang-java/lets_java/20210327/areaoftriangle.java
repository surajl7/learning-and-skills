import java.util.*;
public class areaoftriangle
{
public static void main(String[] args)
{

Scanner s = new Scanner (System.in);

System.out.println("Enter base of triangle");
float b = s.nextFloat();

System.out.println("Enter hight of triangle");
float h = s.nextFloat();

double area = 0.5f*b*h;
System.out.println("Area of triangle = "+area);

}
}