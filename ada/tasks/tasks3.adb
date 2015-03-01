with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Random_Seeds; use Random_Seeds;

procedure Tasks3 is
   Nr_Of_Tasks : constant Integer :=5; -- liczba tasków do uruchomienia
   Seeds : Seed_Array_Type(1..Nr_Of_Tasks) := Make_Seeds(Nr_Of_Tasks);
   
   
   task type SimpleTask_Type(Id: Integer; Seed: Integer );
   task body SimpleTask_Type is
      G : Generator;
   begin
      Reset(G, Seed); 
      loop
	 delay 0.1+Duration(3.0*Random(G));
	 Put_Line ("Task " & Integer'Image(Id));
      end loop;
   end SimpleTask_Type;

   type TasksArray_Type is array ( Positive range <>) of access SimpleTask_Type;
   type TA_Access_Type is access TasksArray_Type;

   function Init_TasksArray( Size: integer ) return TA_Access_Type is
      TA_Ptr: TA_Access_Type ;
   begin
      TA_Ptr := new TasksArray_Type( 1 .. Size);
      for I in TA_Ptr.all'Range loop
	 TA_Ptr.all(I) := new SimpleTask_Type(I, Seeds(I));
      end loop;
      return TA_Ptr;
   end;

   TasksArray: TasksArray_Type := Init_TasksArray(Nr_Of_Tasks).all ;

begin
   null;
end Tasks3;

