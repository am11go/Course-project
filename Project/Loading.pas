unit Loading;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage;

type
  TLoadingForm = class(TForm)
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Logo: TImage;
    LogoText: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoadingForm: TLoadingForm;

implementation

{$R *.dfm}


procedure TLoadingForm.FormCreate(Sender: TObject);
begin
  ProgressBar1.Position := 0;
  Timer1.Interval := 20;
  Timer1.Enabled := True;
end;

procedure TLoadingForm.Timer1Timer(Sender: TObject);
begin
  if ProgressBar1.Position < ProgressBar1.Max then
    ProgressBar1.Position := ProgressBar1.Position + 1
  else
  begin
    Timer1.Enabled := False;
    Close;
  end;
end;

end.

