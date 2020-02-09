/*
 * driver.sv
 * 
 */

class driver;

   // Virtual interface handle
   virtual intf vif;

   mailbox gen2driv;

   // Constructor
   function new(virtual intf vif, mailbox gen2driv);
      this.vif = vif;
      this.gen2driv = gen2driv;
      
   endfunction // new


   //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vif.rst_n);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.i_en_cnt <= 0;


    wait(!vif.rst_n);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask
  
endclass // driver
