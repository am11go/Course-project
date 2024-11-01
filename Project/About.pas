unit About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    Author: TLabel;
    GGPK: TLabel;
    GGPKLink: TLabel;
    Logo: TImage;
    LogoText: TImage;
    procedure GGPKLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses
  ShellAPI;

{$R *.dfm}

procedure TAboutForm.GGPKLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://ggpk.by/'), nil, nil, SW_MAXIMIZE);
end;


end.
