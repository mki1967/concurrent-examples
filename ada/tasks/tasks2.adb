with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

     procedure Tasks2 is

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

       Task1: SimpleTask_Type(1);
       Task2: SimpleTask_Type(2);

     begin
        null;
     end Tasks2;

