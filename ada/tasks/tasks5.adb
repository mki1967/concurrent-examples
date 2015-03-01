with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Random_Seeds; use Random_Seeds;

procedure Tasks5 is
   Seeds : Seed_Array_Type(1..2) := Make_Seeds(2);
   
   task SimpleTask1 is -- server
      entry Exchange_Values( V_In: in Float; V_Out: out Float ) ;
   end  SimpleTask1;
   
   task body SimpleTask1 is
      G : Generator;
      V : Float;
   begin
      Reset(G, Seeds(1) );
      loop
	 delay 0.1+Duration(3.0*Random(G));
	 V := Random(G);
	 Put_Line ( "Task 1: sending " & Float'Image( V ) );
	 accept Exchange_Values( V_In: in Float; V_Out: out Float ) do
	    V_Out := V;
	    V := V_In;
	    Put_Line("Exchanging: " &  
		       Float'Image( V_In ) &
		       Float'Image( V_Out ) );

	 end Exchange_Values;
	 Put_Line ( "Task 1: received " & Float'Image( V ) );	 
      end loop;
   end SimpleTask1;

   task SimpleTask2; 
   task body SimpleTask2 is -- client
      G : Generator;
      V2 : Float;
   begin
      Reset(G, Seeds(2) ); 
      loop
	 delay 0.1+Duration(3.0*Random(G));
	 V2 := Random(G) ;
	 Put_Line ("Task 2: sending " & Float'Image( V2 ));
	 SimpleTask1.Exchange_Values(V2, V2);
	 Put_Line ("Task 2: received " & Float'Image( V2 ));	 
      end loop;
   end SimpleTask2;

begin
   null;
end Tasks5;

