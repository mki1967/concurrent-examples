with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

     procedure Tasks is

       task SimpleTask1;
       task body SimpleTask1 is
       G : Generator;
       begin
         Reset(G); -- Start the generator in a unique state in each run
         loop
           delay 0.1+Duration(3.0*Random(G));
           Put_Line ("Task 1");
         end loop;
       end SimpleTask1;

       task SimpleTask2;
       task body SimpleTask2 is
       G : Generator;
       begin
         Reset(G); -- Start the generator in a unique state in each run
         loop
           delay 0.1+Duration(3.0*Random(G));
           Put_Line ("Task 2");
         end loop;
       end SimpleTask2;

     begin
        null;
     end Tasks;

