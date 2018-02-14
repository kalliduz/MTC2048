unit BoardControls;


interface
uses
  DataTypes,Windows,graphics;
  procedure ResetBoard(ABoard:PBoard);
  procedure InitialMove(ABoard:PBoard);
  function DirectedMove(ABoard:PBoard;AXVector,AYVector:SmallInt):Boolean;
  function IsLost(ABoard:PBoard):Boolean;
  function Spawn(ABoard:PBoard;out New:TPoint):Boolean;
  function DoMove(ABoard:PBoard;AXVector,AYVector:SmallInt;out New:Tpoint):Boolean;
  function Bubble(AX,AY,AXVector,AYVector:SmallInt;ABoard:PBoard):Boolean;
  function GetFreeFields(ABoard:PBoard):Integer;
  function GetPotenceCount(ABoard:PBoard):Integer;
  function RatePosition(ABoard:PBoard):Integer;
  function getHighestPotence(ABoard:PBoard):Integer;
  function IsHighestPotenceInCorner(ABoard:PBoard):Boolean;
  function IsHighestPotencySingle(ABoard:PBoard):Boolean;

implementation
function IsHighestPotencySingle(ABoard:PBoard):Boolean;
var
  LHi:Integer;
  LCount:Integer;
  i,j:Integer;
begin
  LCount:=0;
  LHi:=getHighestPotence(ABoard);
  for i := 1 to 4 do
  begin
    for j := 1 to 4 do
    begin
      if ABoard[i,j]= LHi then inc(LCount);
    end;
  end;
  Result:= (LCOunt = 1);

end;
  function IsHighestPotenceInCorner(ABoard:PBoard):Boolean;
  var
    LHi:Integer;
  begin
    Result:=False;
    LHi:=GetHighestPotence(ABoard);
    if ABoard[1,1] = LHi then
      Exit(True);
    if ABoard[1,4] = LHi then
      Exit(True);
    if AbOard[4,1] = LHi then
      Exit(True);
    if ABoard[4,4] = LHi then
      Exit(True);
  end;

  function getHighestPotence(ABoard:PBoard):Integer;
  var
    i,j:Integer;
  begin
    Result:=0;
    for i := 1 to 4 do
    begin
      for j := 1 to 4 do
      begin
        if ABoard[i,j]>Result then
          Result:=ABoard[i,j];
      end;
    end;

  end;
  function GetPotenceCount(ABoard:PBoard):Integer;

  var
    i,j:Integer;
    LExisting:array of Integer;
  function IsExisting(APotence:Integer):Boolean;
  var
    k:Integer;
  begin
    Result:=False;
    for k := 0 to length(LExisting)-1 do
    begin
      if APotence = LExisting[k] then
      begin
        Result:=True;
        Exit;
      end;
    end;

  end;
  begin
    Result:=0;
    setlength(LExisting,0);
    for i := 1 to 4 do
    begin
      for j := 1 to 4 do
      begin
        if not IsExisting(ABoard[i,j]) then
        begin
          inc(Result);
          setlength(Lexisting,length(LExisting)+1);
          LExisting[length(LExisting)-1]:=ABoard[i,j];
        end;
      end;
    end;
  end;
  function RatePosition(ABoard:PBoard):Integer;
  var
    i,j:Integer;
    max:Integer;
    cur:Integer;
    LIsCorner:Boolean;
  begin

    Result:=0;
    for i := 1 to 4 do
    begin
      for j := 1 to 4 do
      begin
        if ABoard[i,j]<>0 then
        begin
          Result:=Result+ABoard[i,j];
          max:=0;
//          if ((i=1) and (j=1))OR
//             ((i=1) and (j=4))OR
//             ((i=4) and (j=1))OR
//             ((i=4) and (j=4)) then
//          LIsCorner:=True;
//          if LIsCorner then Result:=Result+(ABoard[i,j]);
          if ABoard[i,j-1]>-1 then if ABoard[i,j-1]<ABoard[i,j] then
          cur:=ABoard[i,j-1];
          if cur>max then max:=cur;

          if ABoard[i,j+1]>-1 then if ABoard[i,j+1]<ABoard[i,j] then
          cur:=ABoard[i,j+1];
          if cur>max then max:=cur;

          if ABoard[i-1,j]>-1 then if ABoard[i-1,j]<ABoard[i,j] then
          cur:=ABoard[i-1,j];
          if cur>max then max:=cur;

          if ABoard[i+1,j]>-1 then if ABoard[i+1,j]<ABoard[i,j] then
          cur:=ABoard[i+1,j];
          if cur>max then max:=cur;
          if (max div 2) < ABoard[i,j] then
            Result:=Result- (ABoard[i,j] div 2);

          Result:=Result+max;//add highest neighbour with lower potence then self
        end;                    //ideal = 2^(n-1)
      end;
    end;


  //Result:=ABoard[1,1]+ABoard[2,1] div 2+1;
  end;

  function GetFreeFields(ABoard:PBoard):Integer;
  var
    i,j:Integer;
  begin
    Result:=0;
    for i := 1 to 4 do
    begin
      for j := 1 to 4 do
      begin
        if ABoard[i,j] = 0 then
          inc(Result);
      end;
    end;
  end;
  function Bubble(AX,AY,AXVector,AYVector:SmallInt;ABoard:PBoard):Boolean;
  begin
   if (ABoard[AX+AXVector,AY+AYVector] = 0) and
   (ABoard[AX,AY] <> 0) then
   begin
    ABoard[AX+AXVector,AY+AYVector]:= ABoard[AX,AY];
    ABoard[AX,AY]:=0;
    Result:=True;
    Bubble(AX+AXVector,AY+AYVector,AXVector,AYVector,ABoard);
   end else
    Result:=False;

  end;
function DoMove(ABoard:PBoard;AXVector,AYVector:SmallInt;out new:TPoint):Boolean;

begin
  Result:= DirectedMove(ABoard,AXVector,AYVector);
  if Result then
    Spawn(ABoard,New);
end;

function IsLost(ABoard:PBoard):Boolean;
var
  LB:PBoard;
begin
  LB:= new(PBoard);
  CopyMemory(LB,ABoard,sizeof(TBoard));
  Result:=  DirectedMove(LB,0,1) or DirectedMove(LB,0,-1) or
            DirectedMove(LB,1,0) or DirectedMove(LB,-1,0);
  dispose(lb);

end;

function Spawn(ABoard:PBoard;out New:TPoint):Boolean;
var
  i,j,k:Integer;
  x,y:Byte;
  val:Byte;

begin
  Result:=False;
  for i := 1 to 4 do
  begin
    If Result then Break;
    for j := 1 to 4 do
    begin
      if ABoard[i,j] = 0 then
      begin
        Result:=True;
        Break;
      end;
    end;
  end;
  if not Result then exit;
  while true do
  begin
   x := random(4)+1;
   y := random(4)+1;
   if ABoard[x,y] = 0 then
   begin
    if Random(4) = 0 then
      val:=4 else
      val:=2;
    ABoard[x,y]:=val;
    New.X:=x;
    New.Y:=y;
    Exit;
   end;
  end;

end;


function DirectedMove(ABoard:PBoard;AXVector,AYVector:SmallInt):Boolean;

var
  i,j,k:Integer;
  LVec:SmallInt;

begin
  //First we need to determine the direction of the outer loop:
  Result:=False;
///------------------------------------------
  if AYVector = -1 then
  begin
    for i := 1 to 4 do //outer loop
    begin
      for j := 1 to 4 do //now fill up spaces by bubbling in anti move direction
      begin
       if Bubble(i,j,AXVector,AYVector,ABoard) then
        Result:=True;
      end;

      for j := 1 to 4 do //test collisions
      begin
        if (ABoard[i+AXVector,j+AYVector] = ABoard[i,j])and (ABoard[i,j]<>0) then
        // collision happened, reset source to 0
        // and destination to x*2
        begin
          Result:=True;
          ABoard[i+AXVector,j+AYVector]:= ABoard[i+AXVector,j+AYVector] shl 1;
          ABoard[i,j]:=0;
        end;
      end;
      for j := 1 to 4 do //now fill up spaces by bubbling in anti move direction
      begin
       if Bubble(i,j,AXVector,AYVector,ABoard) then
        Result:=True;
      end;
    end;
  end;
//--------------------------------------------------------
  if AYVector = 1 then
  begin
    for i := 1 to 4 do //outer loop
    begin
      for j := 4 downto 1 do //now fill up spaces by bubbling in anti move direction
      begin
      if Bubble(i,j,AXVector,AYVector,ABoard) then
        Result:=True;
      end;
      for j := 4 downto 1 do //test collisions
      begin

        if (ABoard[i+AXVector,j+AYVector] = ABoard[i,j])and (ABoard[i,j]<>0)  then
        // collision happened, reset source to 0
        // and destination to x*2
        begin
        Result:=True;
          ABoard[i+AXVector,j+AYVector]:= ABoard[i+AXVector,j+AYVector] shl 1;
          ABoard[i,j]:=0;
        end;
      end;
      for j := 4 downto 1 do //now fill up spaces by bubbling in anti move direction
      begin
      if Bubble(i,j,AXVector,AYVector,ABoard) then
        Result:=True;
      end;
    end;
  end;
  //
  if AXVector = -1 then
  begin
    for i := 1 to 4 do //outer loop
    begin
      for j := 1 to 4 do //now fill up spaces by bubbling in anti move direction
      begin
      if  Bubble(j,i,AXVector,AYVector,ABoard) then
        Result:=true;
      end;
      for j := 1 to 4 do //test collisions
      begin
        if (ABoard[j+AXVector,i+AYVector] = ABoard[j,i])and (ABoard[j,i]<>0)  then
        // collision happened, reset source to 0
        // and destination to x*2
        begin
        Result:=True;
          ABoard[j+AXVector,i+AYVector]:= ABoard[j+AXVector,i+AYVector] shl 1;
          ABoard[j,i]:=0;
        end;
      end;
      for j := 1 to 4 do //now fill up spaces by bubbling in anti move direction
      begin
      if  Bubble(j,i,AXVector,AYVector,ABoard) then
        Result:=true;
      end;
    end;
  end;

  if AXVector = 1 then
  begin
    for i := 1 to 4 do //outer loop
    begin
      for j := 4 downto 1 do //now fill up spaces by bubbling in anti move direction
      begin
        if  Bubble(j,i,AXVector,AYVector,ABoard) then
          Result:=True;
      end;
      for j := 4 downto 1 do //test collisions
      begin
        if (ABoard[j+AXVector,i+AYVector] = ABoard[j,i])and (ABoard[j,i]<>0)  then
        // collision happened, reset source to 0
        // and destination to x*2
        begin
         Result:=True;
          ABoard[j+AXVector,i+AYVector]:= ABoard[j+AXVector,i+AYVector] shl 1;
          ABoard[j,i]:=0;
        end;
      end;
      for j := 4 downto 1 do //now fill up spaces by bubbling in anti move direction
      begin
        if  Bubble(j,i,AXVector,AYVector,ABoard) then
          Result:=True;
      end;
    end;
  end;



end;

 procedure InitialMove(ABoard:PBoard);
 var
  x,y:Byte;
 begin
  x:=random(4)+1;
  y:=random(4)+1;
  ABoard[x,y]:=2;

  x:=random(4)+1;
  y:=random(4)+1;
  ABoard[x,y]:=2;
 end;

 procedure ResetBoard(ABoard:PBoard);
 begin
  FillChar(ABoard[0,0],sizeof(TBoard),#0);


  ABoard[0,0]:=-1;
  ABoard[0,1]:=-1;
  ABoard[0,2]:=-1;
  ABoard[0,3]:=-1;
  ABoard[0,4]:=-1;
  ABoard[0,5]:=-1;


  ABoard[0,0]:=-1;
  ABoard[1,0]:=-1;
  ABoard[2,0]:=-1;
  ABoard[3,0]:=-1;
  ABoard[4,0]:=-1;
  ABoard[5,0]:=-1;


  ABoard[5,0]:=-1;
  ABoard[5,1]:=-1;
  ABoard[5,2]:=-1;
  ABoard[5,3]:=-1;
  ABoard[5,4]:=-1;
  ABoard[5,5]:=-1;

  ABoard[0,5]:=-1;
  ABoard[1,5]:=-1;
  ABoard[2,5]:=-1;
  ABoard[3,5]:=-1;
  ABoard[4,5]:=-1;
  ABoard[5,5]:=-1;

 end;
end.
