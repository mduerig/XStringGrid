{
  ------------------------------------------------------------------------------
    Filename: CECheckList.pas
    Version:  v1.0
    Authors:  Michael Dürig (md)
    Purpose:  Implements a checklist cell editor for TXStringGrid.
    Remark:   Needs TXStringGrid v1.2
  ------------------------------------------------------------------------------
    (C) 1999  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / http://www.eye.ch/~mduerig
  ------------------------------------------------------------------------------
    History:  23.06.99md  v1.0  Creation
              05.07.99md  v1.0a Included suggestions of Jacob Pedersen
              03.08.99md  v1.2 Fixed RecreateWnd bug. (q)
              12.08.99md  v2.0 Release v2.0
              26.11.2k md v2.1 Included new features from Marcus Wirth
              10.08.01md  v2.5 ImmediateEditMode added. Thanx to Ahmet Semiz
              16.08.01md  v2.5 Release 2.5
              11.10.03md  v2.7 Fixed bug causing index out of bound exception
                               when accessing the Checked property of a
                               dynamically added item. Thanks to Marcus Lipke
  ------------------------------------------------------------------------------
}

{$I VERSIONS.INC}
unit CECheckList;

interface
uses
  windows, messages, classes, Controls, checklst, XStringGrid;

type
  TCheckListCellEditor = class;

  TSetTextEvent = procedure(Sender: TCheckListCellEditor; var Value: string) of object;
  TSetChecksEvent = procedure(Sender: TCheckListCellEditor) of object;

  TDropDownStyle = (dsFixed, dsAuto);

  TCheckListInplace = class(TCheckListBox)
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
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); {$IFDEF HAS_REINTRODUCE} reintroduce; {$ENDIF}
  end;

  TCheckListCellEditor = class(TMetaCellEditor)
  private
    FHeight: integer;
    FWidth: integer;
    FColumns: integer;
    FDropDownStyle: TDropDownStyle;
    FItems: TStrings;
    FOnSetChecks: TSetChecksEvent;
    FOnSetText: TSetTextEvent;
    function getColumns: integer;
    procedure setColumns(Value: integer);
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
    procedure SetItems(Value: TStrings);
    function GetItems: TStrings;
    function getChecked(Index: integer): boolean;
    procedure setChecked(Index: integer; Value: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartEdit; override;
    procedure EndEdit; override;
    procedure Draw(Rect: TRect); override;
    property Checked[Index: integer]: boolean read getChecked write setChecked;
  published
    property DropdownHeight: integer read FHeight write FHeight;
    property DropDownStyle: TDropDownStyle read FDropDownStyle write FDropDownStyle;
    property DropdownWidth: integer read FWidth write FWidth;
    property OnSetChecks: TSetChecksEvent read FOnSetChecks write FOnSetChecks;
    property OnSetText: TSetTextEvent read FOnSetText write FOnSetText;
    property Columns: integer read getColumns write setColumns;
    property Items: TStrings read GetItems write SetItems;
  end;

procedure Register;

implementation
uses
  grids;

procedure Register;
begin
  RegisterComponents('XStringGrid', [TCheckListCellEditor]);
end;

// -- TCheckListCellEditor ----------------------------------------------------

constructor TCheckListCellEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHeight := 50;
  FItems := TStringList.Create;
end;

destructor TCheckListCellEditor.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TCheckListCellEditor.getColumns: integer;
begin
  if FEditor <> nil then
    result := (FEditor as TCheckListInplace).Columns
  else
    result := FColumns;
end;

procedure TCheckListCellEditor.setColumns(Value: integer);
begin
  if FEditor <> nil then
    (FEditor as TCheckListInplace).Columns := Value
  else
    FColumns := Value;
end;

procedure TCheckListCellEditor.StartEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    init;

  with FEditor as TCheckListInplace do begin
    if Grid.LastChar <> 0 then
      PostMessage(Handle, WM_KEYDOWN, integer(upcase(char(Grid.LastChar))), 0);

    if Assigned(FOnSetChecks) then
      FOnSetChecks(self);
  end;
end;

procedure TCheckListCellEditor.EndEdit;
var
  s: string;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with FEditor as TCheckListInplace do
    if Assigned(FOnSetText) then begin
      FOnSetText(self, s);
      SetCellText(s);
    end;
end;

function TCheckListCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := TCheckListInplace.Create(AOwner, self);
end;

function TCheckListCellEditor.getChecked(Index: integer): boolean;
begin
  result := (FEditor as TCheckListInplace).checked[Index];
end;

procedure TCheckListCellEditor.setChecked(Index: integer; Value: boolean);
begin
  (FEditor as TCheckListInplace).checked[Index] := Value;
end;

function TCheckListCellEditor.GetItems: TStrings;
begin
  if (FEditor <> nil) and FEditor.HandleAllocated then
    result := (FEditor as TCheckListInplace).Items
  else
    result := FItems;
end;

procedure TCheckListCellEditor.SetItems(Value: TStrings);
begin
  if (FEditor <> nil) and FEditor.HandleAllocated then
    (FEditor as TCheckListInplace).Items.Assign(Value)
  else
    FItems.Assign(Value);
end;

procedure TCheckListCellEditor.Draw(Rect: TRect);
var
  h: integer;
begin
  if FEditor = nil then
    exit;

  // Set the checklist's position and extension
  with FEditor as TCheckListInplace do begin
    left := Rect.left;
    top := Rect.Bottom;

    // Use the cells width if DropDownWidth = 0
    if FWidth = 0 then
      width := Rect.right - Rect.left
    else
      Width := FWidth;

    // Determine the dropdown height.
    if FDropDownStyle = dsFixed then
      // Fixed height here
      height := FHeight
    else begin
      // And variable height here clipped at the maximum specified
      h := ItemHeight * Items.count + ItemHeight div 4;
      if h > FHeight then
        height := FHeight
      else
        height := h;
    end;

    // Check if the dropdown exceeds the bottom of the grid and
    if Top + Height > Grid.ClientHeight - 5 then
      // if the editing occures in the under half of the grid
      if Top - Rect.Bottom + Rect.Top > Grid.ClientHeight div 2 then begin
        // draw the dropdown upwards.
        Top := Rect.Top - Height;
        // If it exceeds the uper half now, clip it.
        if Top < 0 then begin
          Height := Height + Top - 5;
          Top := 5;
        end
      end
      else begin
        // else draw it downwards and clip it.
        Height := Height - Top - Height + Grid.ClientHeight - 5;
      end;

    visible := true;
    SetFocus;
    BringToFront;
  end;
end;

// -- TCheckListInplace -------------------------------------------------------

{$IFDEF REQUESTALIGN_FIXED}
procedure TCheckListInplace.RequestAlign;
begin
// Empty. Don't call inherited this disallows alignment
end;
{$ENDIF}

procedure TCheckListInplace.KeyDown(var Key: Word; Shift: TShiftState);
var
  AllowEndEdit: boolean;
begin
  AllowEndEdit := false;
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := false;
      VK_DOWN:   AllowEndEdit := false;
      VK_LEFT:   AllowEndEdit := true;
      VK_RIGHT:  AllowEndEdit := true;
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.Grid.Options
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

procedure TCheckListInplace.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in FCellEditor.Grid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TCheckListInplace.KeyPress(var Key: Char);
begin
  if Key = #13 then begin
    FCellEditor.Grid.SetFocus;
    Key := #0;
  end
  else if Key = #9 then
    Key := #0;

  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TCheckListInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

procedure TCheckListInplace.CreateWnd;
begin
  inherited CreateWnd;
  Items.Assign(TCheckListCellEditor(FCellEditor).FItems);
  if FCellEditor.grid <> nil then
    windows.SetParent(Handle, FCellEditor.grid.Handle);
end;

constructor TCheckListInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FCellEditor := CellEditor;
  visible := false;
  Ctl3d := false;
  ParentCtl3D := False;
  TabStop := false;
  Columns := (CellEditor as TCheckListCellEditor).Columns;
end;

end.

