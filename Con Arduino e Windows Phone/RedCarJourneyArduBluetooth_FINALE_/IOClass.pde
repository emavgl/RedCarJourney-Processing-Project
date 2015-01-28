public class IOClass
{
   private BufferedReader reader;
   private PrintWriter output;
   
   public IOClass(String path)
   {
       reader = createReader("ms.ema");
   }
      
   public String ReadLine()
   {
     String line;
      try {
          line = reader.readLine();
        } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      
    return line;
   }
   
   public void WriteLine(String inputLine)
   {
     if (output == null)
     {
       output = createWriter("ms.ema");
     }
     output.println(inputLine);
     output.flush();
   }
   
   private void SaveFile()
   {
     output.flush(); // Writes the remaining data to the file
     output.close(); // Finishes the file
   }
}
