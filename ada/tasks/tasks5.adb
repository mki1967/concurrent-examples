with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

procedure Tasks5 is
   Seed1: Integer;
   Seed2: Integer;   
   GG : Generator ; -- global random generator
   function Init_Seeds  return Integer is
   begin
      Reset(GG);
      Seed1 := Integer( 1.0E6 * Random(GG)) ;
      Seed2 := Integer( 1.0E6 * Random(GG)) ;
      Put_Line("Seed1 = " & Integer'Image(Seed1) & ", Seed2 = " & Integer'Image(Seed2) );
      return Seed1+Seed2;
   end Init_Seeds;
   
   Tmp: Integer := Init_Seeds ; -- unused variable 
   
   task SimpleTask1 is 
      entry Exchange_Values( V_In: in Float; V_Out: out Float ) ;
   end  SimpleTask1;
   
   task body SimpleTask1 is
      G : Generator;
      V : Float;
   begin
      Reset(G, Seed1);
      loop
	 delay 0.1+Duration(3.0*Random(G));
	 V := Random(G);
	 Put_Line ( "Task 1: sending " & Float'Image( V ) );
	 accept Exchange_Values( V_In: in Float; V_Out: out Float ) do
	    V_Out := V;
	    V := V_In;
	 end Exchange_Values;
	 Put_Line ( "Task 1: received " & Float'Image( V ) );	 
      end loop;
   end SimpleTask1;

   task SimpleTask2;
   task body SimpleTask2 is
      G : Generator;
      V2 : Float;
   begin
      Reset(G, Seed2); 
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

