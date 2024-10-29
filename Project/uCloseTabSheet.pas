unit uCloseTabSheet;

interface

uses
  ComCtrls, Windows, Types, Forms, iexBitmaps, Classes, Controls, SysUtils, hyiedefs, hyieutils;

type
  TCloseTabSheet = class(TTabSheet)
  private
  protected
    fCloseButtonRect: TRect;
    fOnCloseQuery: TCloseQueryEvent;
    fOnClose: TNotifyEvent;
    procedure DoClose(); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnCloseQuery: TCloseQueryEvent read fOnCloseQuery write fOnCloseQuery;
    property OnClose: TNotifyEvent read fOnClose write fOnClose;
    function Close(): Boolean;
  end;

  TClosePageControlHandler = class
  private
    fMouseDownTab: TCloseTabSheet;
    fCloseButtonPushed: Boolean;
    fCloseBmp: TIEBitmap;

    procedure DoDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoMouseLeave(Sender: TObject);
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  end;

implementation


constructor TClosePageControlHandler.Create(AOwner: TComponent);
var
  pgc: TPageControl;
begin
  inherited Create;

  pgc := TPageControl(AOwner);
  pgc.TabWidth := 150;
  pgc.OwnerDraw := True;
  fMouseDownTab := nil;
  fCloseBmp     := nil;

  pgc.OnDrawTab    := DoDrawTab;
  pgc.OnMouseDown  := DoMouseDown;
  pgc.OnMouseLeave := DoMouseLeave;
  pgc.OnMouseMove  := DoMouseMove;
  pgc.OnMouseUp    := DoMouseUp;
end;

destructor TClosePageControlHandler.Destroy;
begin
  FreeAndNil( fCloseBmp );

  inherited Destroy;
end;

procedure TClosePageControlHandler.DoDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
const
  DEMORES_PNG_CLOSE_BUTTON = 3004;
  Close_Button_Size = 14;
  Horz_Margin = 6;
var
  pgc: TPageControl;
  tab: TCloseTabSheet;
  rectH, textW, textV: Integer;
  txtSize: TSize;
  cap: string;
  btnRect: TRect;
begin
  pgc := Control as TPageControl;

  textV := 0;
  rectH := Rect.Bottom - Rect.Top;

  btnRect.Left  := Rect.Right - Horz_Margin - Close_Button_Size;
  btnRect.Top := ( rectH - Close_Button_Size ) div 2;

  if not Active then
  begin
    btnRect.Left := btnRect.Left + 2;
    btnRect.Top  := btnRect.Top  + 4;
    textV        := textV + 1;
  end;

  btnRect.Right  := btnRect.Left + Close_Button_Size;
  btnRect.Bottom := btnRect.Top + Close_Button_Size;

  textW := btnRect.Left - Rect.Left - 2 * Horz_Margin;

  cap := pgc.Pages[TabIndex].Caption;
  cap := IETruncateStr( cap, iemtsLeft, pgc.Canvas, textW );

  txtSize := pgc.Canvas.TextExtent( cap );
  pgc.Canvas.FillRect( Rect );
  pgc.Canvas.TextOut( Rect.Left + Horz_Margin + ( textW - txtSize.cx ) div 2, Rect.Top + textV + ( rectH - txtSize.cy ) div 2, cap );

  if pgc.Pages[TabIndex] is TCloseTabSheet then
  begin
    tab := pgc.Pages[TabIndex] as TCloseTabSheet;
    tab.fCloseButtonRect := btnRect;

    if not assigned( fCloseBmp ) then
    begin
      fCloseBmp := TIEBitmap.Create;
      fCloseBmp.LoadFromResource( HInstance, DEMORES_PNG_CLOSE_BUTTON, RT_RCDATA, ioPNG );
    end;

    fCloseBmp.DrawToCanvasWithAlpha( pgc.Canvas, btnRect.Left, btnRect.Top );
  end;
end;

procedure TClosePageControlHandler.DoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  pgc: TPageControl;
  tab: TCloseTabSheet;
begin
  pgc := Sender as TPageControl;

  if Button = mbLeft then
    for I := 0 to pgc.PageCount - 1 do
      if pgc.Pages[i] is TCloseTabSheet then
      begin
        tab := pgc.Pages[i] as TCloseTabSheet;
        if PtInRect(tab.fCloseButtonRect, Point(X, Y)) then
        begin
          fMouseDownTab := tab;
          fCloseButtonPushed := True;
          pgc.Repaint;
        end;
      end;
end;

procedure TClosePageControlHandler.DoMouseLeave(Sender: TObject);
begin
  fCloseButtonPushed := False;
  TPageControl(Sender).Repaint;
end;

procedure TClosePageControlHandler.DoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  overBtn: Boolean;
begin
  if (ssLeft in Shift) and Assigned(fMouseDownTab) then
  begin
    overBtn := PtInRect( fMouseDownTab.fCloseButtonRect, Point(X, Y) );

    if fCloseButtonPushed <> overBtn then
    begin
      fCloseButtonPushed := overBtn;
      TPageControl(Sender).Repaint;
    end;
  end;
end;

procedure TClosePageControlHandler.DoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Assigned(fMouseDownTab) and
     PtInRect(fMouseDownTab.fCloseButtonRect, Point(X, Y)) then
  begin
    fMouseDownTab.DoClose;
    fMouseDownTab := nil;
    TPageControl(Sender).Repaint;
  end;
end;

constructor TCloseTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCloseButtonRect := Rect(0, 0, 0, 0);
end;

destructor TCloseTabSheet.Destroy;
begin
  inherited Destroy;
end;

procedure TCloseTabSheet.DoClose();
begin
  Close();
end;

function TCloseTabSheet.Close(): Boolean;
begin
  Result := True;
  if Assigned( fOnCloseQuery ) then
    fOnCloseQuery( Self, Result );
  if Result then
    Free;
  if Assigned( fOnClose ) then
    fOnClose( nil );
end;

end.
