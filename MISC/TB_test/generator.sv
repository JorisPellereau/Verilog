/*
 *
 * Generator.sv
 * 
 * 
 */
 
 
 class generator;

    // Declaring transaction class
    rand transaction trans;

    // Declaring Mailbox
    mailbox gen2driv;

    //event, indicate the end of transaction generation
    event   ended;

    

    //constructor
    function new(mailbox gen2driv);
      //getting the mailbox handle from env
      this.gen2driv = gen2driv;
    endfunction

    // Main Task
    task main();
       trans = new();
       if(!trans.randomize() ) $fatal("Gen:: trans randomization failed");
       gen2driv.put(trans);
       -> ended;
       
    endtask // main
    
    
 endclass // generator

 
