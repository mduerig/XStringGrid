{
  ------------------------------------------------------------------------------
    Filename: CEButton.pas
    Version:  v1.0
    Authors:  Michael Dürig (md)
    Purpose:
    Remark:   Needs TXStringGrid v1.2
  ------------------------------------------------------------------------------
    (C) 1999  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / www.eye.ch/~mduerig
  ------------------------------------------------------------------------------
    History:  05.07.99md  v1.0  Creation
              12.07.99md  v1.0  Change to BitBtn
              03.08.99md  v1.2  Fixed RecreateWnd bug. (q)
              12.08.99md  v2.0  Release v2.0
              17.10.99md  v2.0  Fixed problem with Glyph property
              17.10.99md  v2.0  Fixed problem OnClick event
  ------------------------------------------------------------------------------
}
unit CEButton;

interface
uses windows, graphics, messages, classes, Controls, buttons, XStringGrid;

type
  TButtonInplace = class(TBitBtn)
  private
    FCellEditor: TCellEditor;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); virtual;
  end;

  TAlignMode = (amAbsolute, amRelative);
  THAlign = (haLeft, haCenter, haRight);
  TVAlign = (vaTop, vaCenter, vaBottom);

  TButtonCellEditor = class(TMetaCellEditor)
  private
    FOnClick: TNotifyEvent;
    FAlignMode: TAlignMode;
    FHAlign: THAlign;
    FVAlign: TVAlign;
    FHeight: integer;
    FWidth: integer;
    FCaption: string;
    FGlyph: TBitmap;
    FLayout: TButtonLayout;
    FMargin: integer;
    FSpacing: integer;
    FNumGlyphs: TNumGlyphs;
    function getCaption: string;
    procedure setCaption(Value: string);
    function getGlyph: TBitMap;
    procedure setGlyph(Value: TBitMap);
    function getLayout: TButtonLayout;
    procedure setLayout(Value: TButtonLayout);
    function getMargin: integer;
    procedure setMargin(Value: integer);
    procedure setHeight(Value: integer);
    procedure setWidth(Value: integer);
    procedure setAlignMode(Value: TAlignMode);
    function getSpacing: integer;
    procedure setSpacing(Value: integer);
    function getOnClick: TNotifyEvent;
    procedure setOnClick(Value: TNotifyEvent);
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure StartEdit; override;
    procedure EndEdit; override;
    destructor destroy; override;
    procedure Draw(Rect: TRect); override;
  published
    property OnClick: TNotifyEvent read getOnClick write setOnClick;
    property AlignMode: TAlignMode read FAlignMode write setAlignMode default amRelative;
    property HAlign: THAlign read FHAlign write FHAlign default haRight;
    property VAlign: TVAlign read FVAlign write FVAlign default vaCenter;
    property Height: integer read FHeight write setHeight;
    property Width: integer read FWidth write setWidth;
    property Caption: string read getCaption write setCaption;
    property Glyph: TBitmap read getGlyph write setGlyph;
    property Layout: TButtonLayout read getLayout write setLayout;
    property Margin: integer read getMargin write setMargin;
    property NumGlyphs: TNumGlyphs read FNumGlyphs write FNumGlyphs;
    property Spacing: integer read getSpacing write setSpacing;
  end;

procedure Register;

implementation
uses grids;

procedure Register;
begin
  RegisterComponents('XStringGrid', [TButtonCellEditor]);
end;

// -- TButtonCellEditor ----------------------------------------------------

constructor TButtonCellEditor.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FAlignMode := amRelative;
  FHAlign := haRight;
  FVAlign := vaCenter;
  FHeight := 0;
  FWidth := 0;
  FGlyph := TBitmap.create;
  FLayout := blGlyphLeft;
  FMargin := -1;
  FNumGlyphs := 1;
end;

destructor TButtonCellEditor.destroy;
begin
  FGlyph.free;
  inherited destroy;
end;

function TButtonCellEditor.getGlyph: TBitMap;
begin
  if FEditor = nil then
    result := FGlyph
  else
    result := TButtonInplace(FEditor).Glyph;
end;

procedure TButtonCellEditor.setGlyph(Value: TBitMap);
begin
  if FEditor = nil then
    FGlyph.Assign(Value)
  else
    TButtonInplace(FEditor).Glyph := Value;
end;

function TButtonCellEditor.getLayout: TButtonLayout;
begin
  if FEditor = nil then
    result := FLayout
  else
    result := TButtonInplace(FEditor).Layout
end;

procedure TButtonCellEditor.setLayout(Value: TButtonLayout);
begin
  if FEditor = nil then
    FLayout := Value
  else
    TButtonInplace(FEditor).Layout := Value;
end;

function TButtonCellEditor.getSpacing: integer;
begin
  if FEditor = nil then
    result := FSpacing
  else
    result := TButtonInplace(FEditor).Spacing
end;

procedure TButtonCellEditor.setSpacing(Value: integer);
begin
  if FEditor = nil then
    FSpacing := Value
  else
    TButtonInplace(FEditor).Spacing := Value;
end;

procedure TButtonCellEditor.setOnClick(Value: TNotifyEvent);
begin
  if FEditor = nil then
    FOnClick := Value
  else
    TButtonInplace(FEditor).OnClick := Value;
end;

function TButtonCellEditor.getOnClick: TNotifyEvent;
begin
  if FEditor = nil then
    result := FOnClick
  else
    result := TButtonInplace(FEditor).OnClick;
end;

function TButtonCellEditor.getMargin: integer;
begin
  if FEditor = nil then
    result := FMargin
  else
    result := TButtonInplace(FEditor).Margin;
end;

procedure TButtonCellEditor.setMargin(Value: integer);
begin
  if FEditor = nil then
    FMargin := Value
  else
    TButtonInplace(FEditor).Margin := Value;
end;

function TButtonCellEditor.getCaption: string;
begin
  if FEditor = nil then
    result := FCaption
  else
    result := TButtonInplace(FEditor).Caption;
end;

procedure TButtonCellEditor.setCaption(Value: string);
begin
  if FEditor = nil then
    FCaption := Value
  else
    TButtonInplace(FEditor).Caption := Value;
end;

procedure TButtonCellEditor.setHeight(Value: integer);
begin
  if FAlignMode = amAbsolute then
    FHeight := Value
  else
    if Value <= 100 then
      FHeight := Value
    else
      FHeight := 100;
end;

procedure TButtonCellEditor.setWidth(Value: integer);
begin
  if FAlignMode = amAbsolute then
    FWidth := Value
  else
    if Value <= 100 then
      FWidth := Value
    else
      FWidth := 100;
end;

procedure TButtonCellEditor.setAlignMode(Value: TAlignMode);
begin
  FAlignMode := Value;
  if FAlignMode = amRelative then begin
    if FWidth > 100 then
      FWidth := 100;
    if FHeight > 100 then
      FHeight := 100;
  end;
end;

procedure TButtonCellEditor.StartEdit;
begin
  // empty
end;

procedure TButtonCellEditor.EndEdit;
begin
  // empty
end;

function TButtonCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := TButtonInplace.Create(AOwner, self);
  with TButtonInplace(result) do begin
    Glyph := FGlyph;
    OnClick := FOnClick;
    HAlign := FHAlign;
    VAlign := VAlign;
    Height := FHeight;
    Width := FWidth;
    Caption := FCaption;
    Glyph := FGlyph;
    Layout := FLayout;
    Margin := FMargin;
    NumGlyphs := FNumGlyphs;
    Spacing := FSpacing;
  end;

end;

procedure TButtonCellEditor.Draw(Rect: TRect);
begin
  if FEditor = nil then
    exit;

  TButtonInplace(FEditor).NumGlyphs := FNumGlyphs;

  if FAlignMode = amAbsolute then begin
    FEditor.width := FWidth;
    FEditor.height := FHeight;
  end
  else begin
    FEditor.width := FWidth * (Rect.right - Rect.left) div 100;
    FEditor.height := FHeight * (Rect.Bottom - Rect.Top) div 100;
  end;

  if FEditor.Width = 0 then
    FEditor.Width := Rect.Right - Rect.left;
  if FEditor.Height = 0 then
    FEditor.height := Rect.Bottom - Rect.Top;

  case FHAlign of
    haLeft:    FEditor.left := Rect.left;
    haCenter:  FEditor.left := (Rect.left + Rect.Right - FEditor.Width) div 2;
    haRight:   FEditor.left := Rect.Right - FEditor.Width;
  end;

  case FVAlign of
    vaTop:     FEditor.top := Rect.top;
    vaCenter:  FEditor.top := (Rect.top + Rect.bottom - FEditor.Height) div 2;
    vaBottom:  FEditor.top := Rect.bottom - FEditor.Height;
  end;

  FEditor.visible := true;
  FEditor.SetFocus;
  FEditor.BringToFront;
end;

// -- TButtonInplace -------------------------------------------------------

procedure TButtonInplace.KeyDown(var Key: Word; Shift: TShiftState);
var
  AllowEndEdit: boolean;
begin
  AllowEndEdit := false;
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := true;
      VK_DOWN:   AllowEndEdit := true;
      VK_LEFT:   AllowEndEdit := true;
      VK_RIGHT:  AllowEndEdit := true;
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.Grid.Options;
    end;
  end;

  if assigned(FCellEditor.AllowEndEditEvent) then
    FCellEditor.AllowEndEditEvent(self, Key, Shift, AllowEndEdit);
  if AllowEndEdit then begin
    DoExit;
    FCellEditor.Grid.HandleKey(Key, Shift);
    FCellEditor.Grid.SetFocus;
    Key := 0;
  end;
  if Key <> 0 then
    inherited KeyDown(Key, Shift);
end;

procedure TButtonInplace.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in FCellEditor.Grid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;

  Message.Result := Message.Result or DLGC_WANTARROWS;
end;

procedure TButtonInplace.KeyPress(var Key: Char);
begin
  if (Key = ' ') and Assigned(OnClick) then
    OnClick(self);
end;

procedure TButtonInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

procedure TButtonInplace.CreateWnd;
begin
  inherited CreateWnd;
  windows.SetParent(Handle, FCellEditor.grid.Handle);
end;

constructor TButtonInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csClickEvents];
  FCellEditor := CellEditor;
  visible := false;
  TabStop := false;
end;

end.
