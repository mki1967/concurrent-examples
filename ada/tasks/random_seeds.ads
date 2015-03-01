with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

package Random_Seeds is
   type Seed_Array_Type is array (Positive range <>) of Integer;
   function Make_Seeds(Size : Positive) return Seed_Array_Type;
end Random_Seeds;

