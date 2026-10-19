//package Calculator_Interface;

//Java AWT Canvas Example
import java.awt.*;
public class CanvasExample 
{
	public CanvasExample()
	{
		Frame f = new Frame("Canvas Example");
		f.add(new MyCanvas());
		f.setLayout(null);
		f.setSize(400,400);
		f.setVisible(true);
	}
	
	public static void main (String args[])
	{
		new CanvasExample();
	}
	public void adjustmentValueChanged(AdjustmentEvent e)
	{
		label.setText("Vertical Scrollbar value is: "+s.getValue());
	}
	public static void main (String args[])
	{
		new ScrollbarExample();
	}

}
