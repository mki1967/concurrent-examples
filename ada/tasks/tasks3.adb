with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

procedure Tasks3 is

   task type SimpleTask_Type(Id: Integer :=0 );
   task body SimpleTask_Type is
      G : Generator;
   begin
      Reset(G); -- Start the generator in a unique state in each run
      loop
	 delay 0.1+Duration(3.0*Random(G));
	 Put_Line ("Task " & Integer'Image(Id));
      end loop;
   end SimpleTask_Type;

   type TasksArray_Type is array ( Positive range <>) of access SimpleTask_Type;
   type TA_Access_Type is access TasksArray_Type;

   function Init_TasksArray( Size: integer :=4) return TA_Access_Type is
      TA_Ptr: TA_Access_Type ;
   begin
      TA_Ptr := new TasksArray_Type( 1 .. Size);
      for I in TA_Ptr.all'Range loop
	 TA_Ptr.all(I) := new SimpleTask_Type(I);
      end loop;
      return TA_Ptr;
   end;

   TasksArray: TasksArray_Type := Init_TasksArray(5).all ;

begin
   null;
end Tasks3;

