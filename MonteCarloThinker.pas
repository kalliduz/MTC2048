unit MonteCarloThinker;

interface

uses
  Classes,BoardControls,MonteCarlo,DataTypes,Windows;

type
  TMonteCarloThinker = class(TThread)
  private
    { Private declarations }
    FBoard:PBoard;
    FMoves:Int64;
    FGames:Int64;
    FKilled:Boolean;
    function GetMoves:Int64;
  protected
    procedure Execute; override;
  public
    Constructor Create(ABoard:PBoard);
    property Moves:Int64 read GetMoves;
    property Games:Int64 read FGames;
    property Killed:Boolean read FKilled write FKilled;
  end;

implementation

uses Math;
function TMonteCarloThinker.GetMoves:Int64;
begin
  Result:= trunc(sqrt(FMoves)*sqrt(FGames));
end;
Constructor TMonteCarloThinker.Create(ABoard:PBoard);
begin
  inherited Create(False); //immediately start the thread, no need to wait for data
  FBoard:=new(PBoard);
  CopyMemory(FBoard,ABoard,sizeof(TBoard));
end;

procedure TMonteCarloThinker.Execute;
var
  LSimBoard:PBoard;
begin
  LSimBoard:=new(PBoard);
  while true do
  begin
    CopyMemory(LSimBoard,FBoard,sizeof(TBoard));
    FMoves:=FMoves +sqr(MonteWholeGame(LSimBoard));
    inc(FGames);
    If FKilled then Break;
  end;
  Dispose(LSimBoard);

end;

end.
