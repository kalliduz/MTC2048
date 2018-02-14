unit Display;

interface
uses
ExtCtrls,DataTypes,Graphics,SysUtils,math,Windows;

procedure DisplayBoard(ABoard:PBoard;ADisplay:TImage;LastSpawn:TPoint);

implementation
 procedure DisplayBoard(ABoard:PBoard;ADisplay:TImage;LastSpawn:TPoint);
 var
  i,j:Integer;
  mulx,muly:Double;
  LClr:TColor;
  LStrChars:Integer;
 begin
  mulx:=ADisplay.Width / 4;
  muly:= ADisplay.Height/4;
  ADisplay.Canvas.Font.Name:='Arial';
  ADisplay.Canvas.Pen.Color:=clBlack;
  ADisplay.Canvas.Pen.Width:=1;
  ADisplay.Canvas.Brush.Color:=clwhite;
  ADisplay.Canvas.Rectangle(0,0,ADisplay.Width,ADisplay.Height);
  for i := 0 to 3 do
  begin
    for j := 0 to 3 do
    begin
      if ABoard[i+1,j+1]>0
      then
        LClr:=rgb(round(Log2(ABoard[i+1,j+1])*15+20),0,0)
      else
        LClr:=rgb(128,128,128);
      if ABoard[i+1,j+1]>0 then
        LStrChars:=trunc(Log10(ABoard[i+1,j+1])+1)
      else
        LStrChars:=1;

      ADisplay.Canvas.Brush.Color:=LClr;
      ADisplay.Canvas.Rectangle(round(i*mulx),round(j*muly),round((i+1)*mulx),round((j+1)*muly));
      ADisplay.Canvas.Font.Size:=20;

      if ABoard[i+1,j+1]>0 then
        ADisplay.Canvas.TextOut(round(i*mulx+(mulx/(2+LStrChars))),round(j*muly+(muly/(2+LStrChars))),inttostr(ABoard[i+1,j+1]));
      if i+1 = LastSpawn.X then if
         j+1 = LastSpawn.Y then
      begin
        ADisplay.Canvas.Brush.Color:=clBlue;
        ADisplay.Canvas.Ellipse(round(i*mulx)+9,round(j*muly)+9,round(i*mulx)+19,round(j*muly)+19);
      end;
    end;
  end;


 end;
end.
