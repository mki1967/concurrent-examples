-- select demo
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Random_Seeds; use Random_Seeds;

procedure Tasks7 is
   
   Seeds : Seed_Array_Type(1..3) := Make_Seeds(3);
   
   task SimpleTask1 is 
      entry Increase;
      entry Decrease;
   end  SimpleTask1;
   
   task body SimpleTask1 is -- server
      G : Generator;
      V : Integer; -- to be increased or decreased
      Min : constant Integer := 0; -- lower bound
      Max : constant Integer := 3; -- upper bound
      
   begin
      V := Min;
      Reset(G, Seeds(1) );
      loop
	 delay 0.1+Duration(3.0*Random(G));
	 select
	    when V < Max =>
	       accept Increase do
		  V := V+1;
		  Put_Line( "Increased V to " & Integer'Image(V) );
	       end Increase;
	 or
	    when V > Min =>
	       accept Decrease do
		  V := V-1;
		  Put_Line( "Decreased V to " & Integer'Image(V) );
	       end Decrease;
	 end select;
      end loop;
   end SimpleTask1;

   task SimpleTask2;
   task body SimpleTask2 is -- client
      G : Generator;
   begin
      Reset(G, Seeds(2) ); 
      loop
	 delay 0.1+Duration(4.0*Random(G));
	 Put_Line ("Task 2: want to increase ");
	 SimpleTask1.Increase;
	 Put_Line ("Task 2: increased ");	 
      end loop;
   end SimpleTask2;
   
   task SimpleTask3;
   task body SimpleTask3 is -- client
      G : Generator;
   begin
      Reset(G, Seeds(3) ); 
      loop
	 delay 0.1+Duration(4.0*Random(G));
	 Put_Line ("Task 3: want to decrease " );
	 SimpleTask1.Decrease;
	 Put_Line ("Task 3: decreased ");	 
      end loop;
   end SimpleTask3;

begin
   null;
end Tasks7;

