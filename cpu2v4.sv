//Brennan Golab
// cpu2v4.sv

module cpu2v4
#( Wwid=6, aW=6  )
(
  output logic [aW-1:0]     memAddr,
  input  logic [Wwid-1:0]  readData,
  output logic [Wwid-1:0] writeData,
  output logic              writeEn,
  output logic                ohalt,
  output logic              oretire,
  input  logic 		        clk,
  input  logic 		        rst
);

  //
  // Include the signal declaration file (sig_declare.inc) here
  // Be sure to LOOK at that file, it is important!
  // if you do not have a signal declare file, then execute the perl script
  // mkurom.  (i.e. ./mkurom)   This perl script will create sig_declare,
  // id.sv, and ustore.sv as specified by your microcode file.
  //
  `include "sig_declare.inc";


  //
  // declare buses for your MAR, PC, IR, Z, and other data path stuff
  //
        logic [Wwid-1:0] MAR, PC, IR, DBus, Z, aluout, selectedRegister;
   

  // declare your UIP, and other sequencing engine stuff
        logic [ua-1:0] UIP;
        logic [ua-1:0] ID;


 // halt and retire are outputs from this module, BUT, they
 // are specified from the microcode.  Take care of that here.
 //

   assign ohalt     = halt;
   assign oretire   = retire;
   assign writeEn = writeEN;
   
   logic [1:0] 	       regSel;
   assign regSel = IR[1:0];
   
   

// 
//  microstore and your instruction decoder
// 

ID__  #(ua)   my_id     ( .IR (IR  ),    .Uip( ID  ) );
US__          my_ustore ( .Uip( UIP   ), .sig( sig   ) );
   
  
   
//
// Sequencing engine hardware:
//
// invoke your micro instruction pointer register (UIP) here
// its width is ua bits
// Then add the rest of the microcode sequencing engine 
//
//
 
  logic [ua] 	       next;

   dff #(ua) mipreg(.d(next), .clk(clk), .rst(rst), .en(1'b1), .q(UIP));
   
   always_comb begin
      case(1'b1)
	gofetch : next = '0;
	id2uip : next = ID;
	default: next = UIP + 1'b1;
      endcase
   end


//
// Data Path hardware:
   //dff - d, clk, rst, en, q
   logic [5:0] DR0, DR1, DR2, DR3;
   
   dff #(6) Reg0Dff(.d(DBus), .clk(clk), .rst(rst), .en(regSel == 2'd0 && regEn), .q(DR0));
   dff #(6) Reg1Dff(.d(DBus), .clk(clk), .rst(rst), .en(regSel == 2'd1 && regEn), .q(DR1));
   dff #(6) Reg2Dff(.d(DBus), .clk(clk), .rst(rst), .en(regSel == 2'd2 && regEn), .q(DR2));
   dff #(6) Reg3Dff(.d(DBus), .clk(clk), .rst(rst), .en(regSel == 2'd3 && regEn), .q(DR3));

   always_comb begin
      unique case(1'b1)
	((IR[1:0] == 2'd0) && !readingReg) : selectedRegister = DR0;
	((IR[1:0] == 2'd1) && !readingReg) : selectedRegister = DR1;
	((IR[1:0] == 2'd2) && !readingReg) : selectedRegister = DR2;
	((IR[1:0] == 2'd3) && !readingReg) : selectedRegister = DR3;
	((IR[3:2] == 2'd0) && readingReg) : selectedRegister = DR0;
	((IR[3:2] == 2'd1) && readingReg) : selectedRegister = DR1;
	((IR[3:2] == 2'd2) && readingReg) : selectedRegister = DR2;
	((IR[3:2] == 2'd3) && readingReg) : selectedRegister = DR3;
	default : selectedRegister = DR0;
      endcase // unique case (regSel)
   end

   assign writeData = selectedRegister;
   
   
   dff #(6) PCdff(.d(DBus), .clk(clk), .rst(rst), .en(PCen), .q(PC));
   dff #(6) IRdff(.d(DBus), .clk(clk), .rst(rst), .en(IRen), .q(IR));
   dff #(6)  Zdff(.d(aluout), .clk(clk), .rst(rst), .en(Zen), .q(Z));

      
   dff #(6) MARdff(.d(DBus), .clk(clk), .rst(rst), .en(MARen), .q(MAR));

   //BPR implementation
   logic [5:0] BPR;
   dff #(6) BPRdff(.d(DBus), .clk(clk), .rst(rst), .en(BPRen), .q(BPR));

   //PG implementation
   logic       PG;
   dff #(1) PGdff(.d(IR[0]), .clk(clk), .rst(rst), .en(PGen), .q(PG));
   logic [5:0] PTE;
   dff #(6) PTEdff(.d(DBus), .clk(clk), .rst(rst), .en(PTEen), .q(PTE));
   
   always_comb begin
      unique case({PG, readingPTE}) //Paging on, and readPTE
	2'b00 : memAddr = {2'd0, MAR}; 
	2'b01 : memAddr = {BPR, MAR[5:4]};
	2'b10 : memAddr = {PTE[5:2], MAR[3:0]};
	2'b11 : memAddr = {BPR, MAR[5:4]};
	default : memAddr = {2'd0, MAR};
      endcase // unique case (PGen)
   end
   
   
   //Selection MUX
   always_comb begin
      unique case (1'b1)
	BSelZ : DBus = Z;
	BSelPC : DBus = PC;
	BSelMem : DBus = readData;
	BSelReg : DBus = selectedRegister;
	default : DBus = PC;
      endcase
   end
   

// invoke your MAR, PC, IR and the rest of the data path 
// There should be a bunch of registers.  There should be a MUX
// that drives the bus.  You should connect up to the signals in
// the port list that go to memory
 


// ALU
always_comb begin
  unique case (1'b1)
    aluinc:  aluout = DBus + 1'b1;
    add : aluout = DBus + Z;
    default: aluout = DBus;
  endcase
end // always_comb



endmodule

