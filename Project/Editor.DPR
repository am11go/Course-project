program Editor;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  About in 'About.pas' {AboutForm},
  uCloseTabSheet in 'uCloseTabSheet.pas',
  Loading in 'Loading.pas' {LoadingForm};

{$R *.RES}

begin
  Application.Title := '����������� ��������';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TLoadingForm, LoadingForm);
  Application.Run;
end.

