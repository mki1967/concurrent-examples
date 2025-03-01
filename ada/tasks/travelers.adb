with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Random_Seeds; use Random_Seeds;

procedure  Travelers is

-- 2D Board with torus topology

  Board_Width  : constant Integer := 20;
  Board_Height : constant Integer := 20;

  type Position_Type is record	
    X: Integer range 0 .. Board_Width - 1; 
    Y: Integer range 0 .. Board_Height - 1; 
  end record;	   

  procedure MoveDown( Position: in out Position_Type ) is
  begin
    Position.Y := ( Position.Y + 1 ) mod Board_Height;
  end MoveDown;

  procedure MoveUp( Position: in out Position_Type ) is
  begin
    Position.Y := ( Position.Y + Board_Height - 1 ) mod Board_Height;
  end MoveUp;

  procedure MoveRight( Position: in out Position_Type ) is
  begin
    Position.X := ( Position.X + 1 ) mod Board_Width;
  end MoveRight;

  procedure MoveLeft( Position: in out Position_Type ) is
  begin
    Position.X := ( Position.X + Board_Width - 1 ) mod Board_Width;
  end MoveLeft;

-- Travelers moving on the board

  Nr_Of_Travelers : constant Integer :=20;	

  Seeds : Seed_Array_Type(1..Nr_Of_Travelers) := Make_Seeds(Nr_Of_Travelers);

  type Traveler_Type is record
    Id: Integer;
    Symbol: Character;
    Position: Position_Type;    
  end record;


  task type Traveler_Task_Type is	
    entry Init(Id: Integer; Seed: Integer; Symbol: Character);
  end Traveler_Task_Type;	

  task body Traveler_Task_Type is
      G : Generator;
      Traveler: Traveler_Type;
  begin
    accept Init(Id: Integer; Seed: Integer; Symbol: Character) do
      Reset(G, Seed); 
      Traveler.Id := Id;
      Traveler.Symbol := Symbol;
    end Init;

    loop
      delay 0.1+Duration(3.0*Random(G));
      Put_Line ("Task " & 
                Integer'Image(Traveler.Id) &
                Character'Image(Traveler.Symbol) );
    end loop;
  end Traveler_Task_Type;

  Test : Traveler_Task_Type; -- test
begin
  Test.Init( 0, Seeds(1), 'T' ); -- test
  null;
end Travelers;

