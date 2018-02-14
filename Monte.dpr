program Monte;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  DataTypes in 'DataTypes.pas',
  BoardControls in 'BoardControls.pas',
  Display in 'Display.pas',
  MonteCarlo in 'MonteCarlo.pas',
  MonteCarloThread in 'MonteCarloThread.pas',
  MonteCarloThinker in 'MonteCarloThinker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
