/* 
 * Transaction for SV TB
 * 
 */

class transaction;

   // Declaration of the transactions items
   bit i_en_cnt;

   function void display(string name);
      $display("// ====");      
      $display("- %s", name);
      $display("// ====");           
   endfunction //
   
endclass // transaction
