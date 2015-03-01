with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

package body Random_Seeds is
   function Make_Seeds(Size : Positive) return Seed_Array_Type is
      GG : Generator ; -- global random generator
      Array_Access : access  Seed_Array_Type;
   begin
      Reset(GG); -- Start the generator in a unique state in each run
      Array_Access := new Seed_Array_Type(1 .. Size);
      for I in Array_Access.all'Range loop
	 Array_Access.all(I) := Integer( 1.0E6 * Random(GG)) ;
      end loop;
      return Array_Access.all;
   end;
end Random_Seeds;

