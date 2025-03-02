with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Random_Seeds; use Random_Seeds;
with Ada.Real_Time; use Ada.Real_Time;

procedure  Travelers is


-- Travelers moving on the board

  Nr_Of_Travelers : constant Integer :=20;	

  Min_Steps : constant Integer := 10 ;
  Max_Steps : constant Integer := 100 ;

-- 2D Board with torus topology

  Board_Width  : constant Integer := 20;
  Board_Height : constant Integer := 20;

-- Timing

  Start_Time : Time := Clock;  -- global startnig time

-- Random seeds for the tasks' random number generators
 
  Seeds : Seed_Array_Type(1..Nr_Of_Travelers) := Make_Seeds(Nr_Of_Travelers);

-- Types, procedures and functions

  -- Postitions on the board
  type Position_Type is record	
    X: Integer range 0 .. Board_Width - 1; 
    Y: Integer range 0 .. Board_Height - 1; 
  end record;	   

  -- elementary steps
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

  -- traces of travelers
  type Trace_Type is record 	      
    Time_Stamp:  Duration;	      
    Id : Integer;
    Position: Position_Type;      
    Symbol: Character;	      
  end record;	      

  type Trace_Array_type is  array(0 .. Max_Steps) of Trace_Type;

  type Traces_Sequence_Type is record
    Last: Integer := -1;
    Trace_Array: Trace_Array_type ;
  end record; 


  -- travelers
  type Traveler_Type is record
    Id: Integer;
    Symbol: Character;
    Position: Position_Type;    
  end record;


  task type Traveler_Task_Type is	
    entry Init(Id: Integer; Seed: Integer; Symbol: Character);
    entry Start;
  end Traveler_Task_Type;	

  task body Traveler_Task_Type is
    G : Generator;
    Traveler : Traveler_Type;
    Time_Stamp : Duration;
    Nr_of_Steps: Integer;
    Traces: Traces_Sequence_Type; 

    procedure Store_Trace is
    begin  
      Traces.Last := Traces.Last + 1;
      Traces.Trace_Array( Traces.Last ) := ( 
          Time_Stamp => Time_Stamp,
          Id => Traveler.Id,
          Position => Traveler.Position,
          Symbol => Traveler.Symbol
        );
    end Store_Trace;

  begin
    accept Init(Id: Integer; Seed: Integer; Symbol: Character) do
      Reset(G, Seed); 
      Traveler.Id := Id;
      Traveler.Symbol := Symbol;
      -- Random initial position:
      Traveler.Position := (
          X => Integer( Float(Board_Width) * Random(G) ),
          Y => Integer( Float(Board_Height) * Random(G) )          
        );
      Store_Trace; -- store starting position
      -- Number of steps to be made by the traveler  
      Nr_of_Steps := Min_Steps + Integer( Float(Max_Steps - Min_Steps) * Random(G));
      -- Time_Stamp of initialization
      Time_Stamp := To_Duration ( Clock - Start_Time ); -- reads global clock
    end Init;
    
    -- wait for initialisations of the remaining tasks:
    accept Start do
      null;
    end Start;

    for Step in 1 .. Nr_of_Steps loop
      delay 0.05+Duration(0.05 * Random(G)); 
      -- do action ...
      Time_Stamp := To_Duration ( Clock - Start_Time ); -- reads global clock
      Put_Line (
                Duration'Image( Time_Stamp ) &" "&
                Integer'Image(Traveler.Id) &" "&
                Character'Image(Traveler.Symbol) &" "&
                Integer'Image(Step) );
    end loop;
  end Traveler_Task_Type;


  Test_A, Test_B : Traveler_Task_Type; -- for tests


begin
  -- Put_Line( "Duration'Small =" & Duration'Image(Duration'Small) );

  Test_A.Init( 0, Seeds(1), 'A' ); -- test
  Test_B.Init( 0, Seeds(2), 'B' ); -- test

  Test_A.Start; -- test
  Test_B.Start; -- test

  null;
end Travelers;

