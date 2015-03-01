with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Random_Seeds; use Random_Seeds;

procedure Tasks4 is
   
   Seeds : Seed_Array_Type(1..2) := Make_Seeds(2);
   
   Shared_Variable: Float := 0.0 ; 
   
   task SimpleTask1;
   task body SimpleTask1 is
      G : Generator;
      V : Float;
   begin
      Reset(G, Seeds(1) ); 
      loop
	 delay 0.1+Duration(3.0*Random(G));
	 V := Random(G);
	 Shared_Variable := V;
	 Put_Line ( "Task 1 : stored " & Float'Image( V ) );
      end loop;
   end SimpleTask1;

   task SimpleTask2;
   task body SimpleTask2 is
      G : Generator;
      V2 : Float;
   begin
      Reset(G, Seeds(2) );
      loop
	 delay 0.1+Duration(3.0*Random(G));
	 V2 := Shared_Variable;
	 Put_Line ("Task 2: read " & Float'Image( V2 ));
      end loop;
   end SimpleTask2;

begin
   null;
end Tasks4;

