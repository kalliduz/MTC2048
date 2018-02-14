unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,DataTypes,BoardControls,Display, StdCtrls,MonteCarlo,MonteCarloThinker,
  ComCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Timer2: TTimer;
    Image2: TImage;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    procedure permanentAnalysis;
    procedure drawCurrentMoveEstimation(ABestNow:Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  gBoard:TBoard;
  gMove:Integer;
  gThinkers:array[0..3] of TMonteCarloThinker;
implementation

{$R *.dfm}
procedure TForm1.permanentAnalysis;
var
  i:Integer;
  LSimBoard:PBoard;
  lx,ly:SmallInt;
  NewPoint:TPOint;
begin
  LSimBoard:= new(PBoard);
  for i := 0 to 3 do
  begin
    if Assigned(gThinkers[i]) then
    begin
      gThinkers[i].Killed:=True;
      gThinkers[i].WaitFor;
      gThinkers[i].Free;
      gThinkers[i]:=nil;
    end;
    CopyMemory(LSimboard,@GBoard,sizeof(TBoard));
    case i of
    0:begin lx:=-1;ly:=0; end;
    1:begin lx:=1; ly:=0; end;
    2:begin lx:=0; ly:=-1; end;
    3:begin lx:=0; ly:=1; end;
    end;
    if DoMove(LSimBoard,lx,ly,newPoint) then
      gThinkers[i]:=TMonteCarloThinker.Create(LSimBoard);
  end;
end;
procedure TForm1.FormCreate(Sender: TObject);

begin
 randomize;
  gMove:=0;
  Image2.Canvas.Pen.Color:=clMoneyGreen;
  Image2.Canvas.Brush.Color:=clMoneyGreen;
  Image2.Canvas.Rectangle(0,0,Image2.Width,Image2.Height);
  ResetBoard(@gBoard);
  gThinkers[0]:=nil;
  gThinkers[1]:=nil;
  gThinkers[2]:=nil;
  gThinkers[3]:=nil;
  InitialMove(@gBoard);
  DisplayBoard(@gBoard,Image1,point(0,0));
  Timer2.Enabled:=False;
  permanentAnalysis;

  Timer2.Enabled:=True;

end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  best:double;
  cur:double;
  bestIndex:Integer;
  lx,ly:Smallint;
  i:Integer;
  LStr:String;
  LSimBoard:PBoard;
  newSpawn:TPOint;
begin
  Timer2.Enabled:=False;
  bestIndex:=-1;
  best:=0;
  for i := 0 to 3 do
  begin
    if Assigned(gThinkers[i]) then
    begin
      while gThinkers[i].Games = 0 do
      begin
        sleep(50);
      end;
      cur:=gThinkers[i].Moves/gThinkers[i].Games;
      if cur>best then
      begin
        best:=cur;
        bestIndex:=i;
      end;

    end;
  end;
  case bestIndex of
    0:begin lx:=-1;ly:=0; end;
    1:begin lx:=1; ly:=0; end;
    2:begin lx:=0; ly:=-1; end;
    3:begin lx:=0; ly:=1; end;
  end;
  DoMove(@gBoard,lx,ly,newSpawn);
  DisplayBoard(@gboard,Image1,newSpawn);
  inc(gMove);

  Memo1.Lines.BeginUpdate;
  Memo1.Lines.Clear;
  for i := 0 to 3 do
  begin
    if Assigned(gThinkers[i]) then
    begin
      case i of
      0: LStr:= 'Links: ';
      1: LStr:= 'Rechts:';
      2: LStr:= 'Oben:  ';
      3: LStr:= 'Unten: ';
      end;
      if gThinkers[i].Games>0 then
      begin
        Memo1.Lines.Add(LStr);
        Memo1.Lines.Add('Avg.: ' +inttostr(trunc(((((gThinkers[i].Moves/gThinkers[i].Games)))))));
        Memo1.Lines.Add('Games:'+inttostr(gThinkers[i].Games));
        Memo1.Lines.Add(' ');
      end;
    end;
  end;
  Memo1.Lines.EndUpdate;

  DrawCurrentMoveEstimation(trunc(best));
  StatusBar1.SimpleText:='Estimated moves reached: '+inttostr(trunc((((best))))+gMove)+' Move: '+inttostr(gMove);
  //this move finished, start next one
  permanentAnalysis;
  Timer2.Enabled:=true;
  timer2.interval:=1*sqr(GetPotenceCount(@gBoard));
end;

procedure TForm1.drawCurrentMoveEstimation(ABestNow:Integer);
var
  LX:Integer;
  LY:Integer;
begin
  LX:=gMove mod Image2.Width;
  LY:=trunc((((ABestNow))));
  Image2.Canvas.Pen.Color:=clMoneyGreen;
  Image2.Canvas.MoveTo(LX,0);
  Image2.Canvas.LineTo(Lx,Image2.Height);
  image2.canvas.Pixels[lx,image2.Height-ly]:=clblack;
  image2.canvas.Pixels[lx,image2.Height-(RatePosition(@gBoard) div 40)]:=clred;

end;

end.
