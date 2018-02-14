unit MonteCarlo;

interface
uses
  BoardControls,DataTypes,Windows;

function MonteOnetime(ABoard:PBoard;out WasMoved:Integer):Boolean;
function MonteWholeGame(ABoard:PBoard):Integer;

implementation
function MonteWholeGame(ABoard:PBoard):Integer;
var
  finished:Boolean;
  LMoved:Integer;
begin
  finished:=False;
  Result:=0;
  while not finished do
  begin
   finished:= not MonteOneTime(ABoard,Lmoved);
   inc(Result,Lmoved);
  end;
end;
function MonteOnetime(ABoard:PBoard;out WasMoved:Integer):Boolean;
var
  lx,ly:smallint;
  newVal:TPOint;
  SimBoard:PBoard;
  i:Integer;
  LChance:array[0..3]of Integer;
  LMoved:Boolean;
  LPropRange:array[0..3] of Integer;
  LMoveVal:Integer;
begin
SimBoard:=new(PBoard);
for i := 0 to 3 do
begin
  CopyMemory(SimBoard,ABoard,sizeof(TBoard));
  case i of
   0: begin lx:=1;ly:=0; end;
   1: begin lx:=-1;ly:=0; end;
   2: begin lx:=0;ly:=1; end;
   3: begin lx:=0;ly:=-1; end;
  end;
  LMoved:= DoMove(SimBoard,lx,ly,newVal);
  if LMoved then
    LChance[i]:=(RatePosition(SimBoard))
  else
    LChance[i]:=0;
  LProprange[i]:=LChance[i];
  if i>0 then LPropRange[i]:=LChance[i]+LPropRange[i-1];
end;
Dispose(SimBoard);

LMoveVal:=random(LPropRange[3]); //random in full space
if LMoveVal<LPropRange[0] then
begin
  lx:=1;ly:=0;
end else
begin
  if LMoveVal<LPropRange[1] then
  begin
    lx:=-1;ly:=0;
  end else
  begin
    if LMoveVal<LPropRange[2] then
    begin
      lx:=0;ly:=1;
    end else
    begin
      lx:=0;ly:=-1;
    end;
  end;
end;
if DoMove(ABoard,lx,ly,newVal) then
begin
  WasMoved:=1;
//  if IsHighestPotenceInCorner(ABoard) and IsHighestPotencySingle(ABOard) then
//    inc(WasMoved,getHighestPotence(ABoard));
end else
  WasMoved:=0;

  Result:=IsLost(ABoard);

end;
end.
