{
  ------------------------------------------------------------------------------
    Filename: CECheckbox
    Version:  v1.0
    Authors:  Michael Dürig (md)
    Purpose:  A CheckBox cell editor for the XStringGrid
    Remark:   Needs TXStringGrid v2.0
  ------------------------------------------------------------------------------
    (c) 2002  M. Dürig
              CH-3000 Bern
              mduerig@eye.ch / http://www.eye.ch/~mduerig
  ------------------------------------------------------------------------------
    History:  09.04.02md  v1.0 Creation
  ------------------------------------------------------------------------------
}

{$I VERSIONS.INC}
unit CECheckbox;
{todo -ctest : Test this compo with other compilers (D6, BCB6 ok)}

interface
uses
  windows, graphics, messages, classes, Controls, StdCtrls, XStringGrid;

type
  TCheckBoxCellEditor = class;

  TSetTextEvent = procedure(Sender: TCheckBoxCellEditor; var Value: string) of object;
  TSetStateEvent = procedure(Sender: TCheckBoxCellEditor) of object;

  TCheckBoxInplace = class(TCheckBox)
  private
    FCellEditor: TCellEditor;
  protected
{$IFDEF REQUESTALIGN_FIXED}
    procedure RequestAlign; override;
{$ENDIF}
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); {$IFDEF HAS_REINTRODUCE} reintroduce; {$ENDIF} virtual;
  end;

  TVAlign = (vaTop, vaCenter, vaBottom);

  TCheckBoxCellEditor = class(TMetaCellEditor)
  private
    FOnClick: TNotifyEvent;
    FOnSetState: TSetStateEvent;
    FOnSetText: TSetTextEvent;
    FCaption: string;
    FCheckBoxState: TCheckBoxState;
    FSpacing: integer;
    FAlignment: TLeftRight;
    function getCaption: string;
    procedure setCaption(Value: string);
    function getOnClick: TNotifyEvent;
    procedure setOnClick(Value: TNotifyEvent);
    function getCheckBoxState: TCheckBoxState;
    procedure setCheckBoxState(const Value: TCheckBoxState);
    procedure setAlignment(const Value: TLeftRight);
    function getAlignment: TLeftRight;
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
  public
    procedure StartEdit; override;
    procedure EndEdit; override;
    procedure Draw(Rect: TRect); override;
  published
    property OnClick: TNotifyEvent read getOnClick write setOnClick;
    property OnSetText: TSetTextEvent read FOnSetText write FOnSetText;
    property OnSetState: TSetStateEvent read FOnSetState write FOnSetState;
    property Caption: string read getCaption write setCaption;
    property State: TCheckBoxState read getCheckBoxState write setCheckBoxState;
    property Spacing: integer read FSpacing write FSpacing default 0;
    property Alignment: TLeftRight read getAlignment write setAlignment;
  end;

procedure Register;

implementation
uses
  grids;

procedure Register;
begin
  RegisterComponents('XStringGrid', [TCheckBoxCellEditor]);
end;

// -- TCheckBoxCellEditor ----------------------------------------------------

procedure TCheckBoxCellEditor.setOnClick(Value: TNotifyEvent);
begin
  if FEditor = nil then
    FOnClick := Value
  else
    TCheckBoxInplace(FEditor).OnClick := Value;
end;

function TCheckBoxCellEditor.getOnClick: TNotifyEvent;
begin
  if FEditor = nil then
    result := FOnClick
  else
    result := TCheckBoxInplace(FEditor).OnClick;
end;

function TCheckBoxCellEditor.getCaption: string;
begin
  if FEditor = nil then
    result := FCaption
  else
    result := TCheckBoxInplace(FEditor).Caption;
end;

procedure TCheckBoxCellEditor.setCaption(Value: string);
begin
  if FEditor = nil then
    FCaption := Value
  else
    TCheckBoxInplace(FEditor).Caption := Value;
end;

function TCheckBoxCellEditor.getCheckBoxState: TCheckBoxState;
begin
  if FEditor = nil then
    result := FCheckBoxState
  else
    result := TCheckBoxInplace(FEditor).State;
end;

procedure TCheckBoxCellEditor.setCheckBoxState(const Value: TCheckBoxState);
begin
  if FEditor = nil then
    FCheckBoxState := Value
  else
    TCheckBoxInplace(FEditor).State := Value;
end;

function TCheckBoxCellEditor.getAlignment: TLeftRight;
begin
  if FEditor = nil then
    result := FAlignment
  else
    result := TCheckBoxInplace(FEditor).Alignment;
end;

procedure TCheckBoxCellEditor.SetAlignment(const Value: TLeftRight);
begin
  if FEditor = nil then
    FAlignment := Value
  else
    TCheckBoxInplace(FEditor).Alignment := Value;
end;

procedure TCheckBoxCellEditor.StartEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    init;

  with FEditor as TCheckBoxInplace do
    if Assigned(FOnSetState) then
      FOnSetState(self);
end;

procedure TCheckBoxCellEditor.EndEdit;
var
  s: string;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with FEditor as TCheckBoxInplace do
    if Assigned(FOnSetText) then begin
      FOnSetText(self, s);
      SetCellText(s);
    end;
end;

function TCheckBoxCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := TCheckBoxInplace.Create(AOwner, self);
  with TCheckBoxInplace(result) do begin
    TabStop := false;
    Caption := FCaption;
    State := FCheckBoxState;
    Alignment := FAlignment;
    OnClick := FOnClick;
  end;
end;

procedure TCheckBoxCellEditor.Draw(Rect: TRect);
begin
  if FEditor = nil then
    init;

  FEditor.Width := Rect.Right - Rect.left;
  FEditor.height := Rect.Bottom - Rect.Top;
  FEditor.left := Rect.left;
  FEditor.top := Rect.top;
  FEditor.visible := true;
  FEditor.SetFocus;
  FEditor.BringToFront;
end;

// -- TCheckBoxInplace -------------------------------------------------------

{$IFDEF REQUESTALIGN_FIXED}
procedure TCheckBoxInplace.RequestAlign;
begin
// Empty. Don't call inherited this disallows alignment
end;
{$ENDIF}

procedure TCheckBoxInplace.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TCheckBoxInplace.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in FCellEditor.Grid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;

  Message.Result := Message.Result or DLGC_WANTARROWS;
end;

procedure TCheckBoxInplace.KeyPress(var Key: Char);
begin
  if Assigned(OnClick) then
    OnClick(self);
end;

procedure TCheckBoxInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

procedure TCheckBoxInplace.CreateWnd;
begin
  inherited CreateWnd;
  Parent := FCellEditor.Grid;
end;

constructor TCheckBoxInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FCellEditor := CellEditor;
  visible := false;
  TabStop := false;
end;

end.
