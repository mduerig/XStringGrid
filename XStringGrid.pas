{
  ------------------------------------------------------------------------------
    Filename: XStringGrid.pas
    Version:  v1.2
    Authors:  Michael Dürig (md)
    Purpose:  XStringgrid is an extended version of the stringgrid which offers
              a lot more flexibility. It's possible to apply different colours
              and fonts to each column and it's header and align the content
              of the cells. In addition it offers different inplace editors
              which can be assigned to columns to edit their cells. So far
              there are edit, combo, maskedit and spincontrol inplace editors
              implemented.
    Remark:   There's a bug in Borland's TStringGrid with at least some
              versions of Delphi 2. When moving columns only the cells of
              the fixed rows get moved, the other cells stay at their places.
              When using TXStringGrid it seems like only the layout of the
              cells without the content gets moved.
              This bug is fixed in Delphi 3.
  ------------------------------------------------------------------------------
    (C) 1998  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / www.eye.ch/~mduerig
  ------------------------------------------------------------------------------
    History:  11.03.97md  v1.0 Release v1.0
              14.09.97md  v1.1 Bugs fixed
              29.11.97md  v1.1 TEditCelleditor text selected on entry now
              05.12.97md  v1.1 Fixed Cant focus invisible control bug
              12.12.97md  v1.2 Provides goAlwaysShowEditor now
              07.04.98md  v1.2 Correted problem with goTabs
  ------------------------------------------------------------------------------
}

unit XStringGrid;

interface

uses Grids, Classes, Graphics, Controls, Windows, StdCtrls, SysUtils, Messages, Mask,
  ComCtrls;

type
  ECellEditorError = class(Exception);

  TXStringColumns = class;
  TXStringGrid = class;
  TXStringColumnItem = class;

  TAllowEndEditEvent = procedure(Sender: TObject; var Key: Word; Shift: TShiftState; var EndEdit: boolean) of object;

  TCellEditor = class(TComponent)     // Base class for all cell editors
  private
    FDefaultText: string;
    FGrid: TXStringGrid;
    FReferences: integer;
    FAllowEndEditEvent: TAllowEndEditEvent;
    function GetGrid: TXStringgrid;
  protected
    procedure Attatch(AGrid: TXStringGrid); virtual;
    procedure Detach; virtual;
    procedure StartEdit; virtual; abstract;
    procedure EndEdit; virtual; abstract;
    property DefaultText: String read FDefaultText write FDefaultText;
  public
    destructor destroy; override;
    procedure Draw(Rect: TRect); virtual; abstract;
    procedure Clear; virtual; abstract;
    property Grid: TXStringgrid read GetGrid;
    property References: integer read FReferences;
  published
    property AllowEndEditEvent: TAllowEndEditEvent read FAllowEndEditEvent write FAllowEndEditEvent;  
  end;

  TWinControlInterface = class(TWinControl)
  public
    property Caption;           // This class gains access to otherwise
    property Color;             // protected members by a forced typecast.
    property Ctl3D;             // This allows a kind of a friend relationship.
    property DragCursor;
    property DragMode;
    property Font;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Text;
  end;

  TMetaCellEditor = class(TCellEditor)  // Base class for meta components
  private
    FEditor: TWinControl;
  protected
    procedure Attatch(AGrid: TXStringGrid); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function InitEditor(AOwner: TComponent): TWinControl; virtual;
    function GetEditor: TWinControlInterface; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw(Rect: TRect); override;
    procedure Clear; override;
    property Editor: TWinControlInterface read GetEditor;
  end;

  TEditInplace = class(TCustomEdit)
  private
    FCellEditor: TCellEditor;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor);
  end;

  TEditCellEditor = class(TMetaCellEditor)
  protected
    procedure StartEdit; override;
    procedure EndEdit; override;
    function InitEditor(AOwner: TComponent): TWinControl; override;
  public
    procedure Draw(Rect: TRect); override;
  published
    property DefaultText;
  end;

  TComboInplace = class(TCustomComboBox)
  private
    FCellEditor: TCellEditor;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor);
  end;

  TComboCellEditor = class(TMetaCellEditor)
  private
    FStyle: TComboBoxStyle;
  protected
    procedure StartEdit; override;
    procedure EndEdit; override;
    function InitEditor(AOwner: TComponent): TWinControl; override;
    function GetItems: TStrings;
    function GetStyle: TComboBoxStyle; virtual;
    procedure SetStyle(Value: TComboBoxStyle); virtual;
  public
    property Items: TStrings read GetItems;
  published
    property DefaultText;
    property Style: TComboBoxStyle read GetStyle write SetStyle default csDropDown;
  end;

  TMaskEditInplace = class(TCustomMaskEdit)
  private
    FCellEditor: TCellEditor;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor);
  end;

  TMaskEditCellEditor = class(TMetaCellEditor)
  private
    FEditMask: String;
    function GetEditMask: String;
    procedure SetEditMask(Value: String);
  protected
    procedure StartEdit; override;
    procedure EndEdit; override;
    function InitEditor(AOwner: TComponent): TWinControl; override;
  public
    procedure Draw(Rect: TRect); override;
  published
    property DefaultText;
    property EditMask: String read GetEditMask write SetEditMask;
  end;

  TUpDownInplace = class(TCustomEdit)
  private
    FCellEditor: TCellEditor;
    FUpDown: TUpDown;
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor);
    destructor Destroy; override;
    property UpDown: TUpDown read FUpDown;
  end;

  TUpDownCellEditor = class(TMetaCellEditor)
  protected
    procedure Attatch(AGrid: TXStringGrid); override;
    procedure StartEdit; override;
    procedure EndEdit; override;
    function InitEditor(AOwner: TComponent): TWinControl; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure Draw(Rect: TRect); override;
    procedure Clear; override;
  published
    property DefaultText;
  end;

  TXStringColumnItem = class(TCollectionItem)
  private
    FHeaderColor: TColor;
    FHeaderFont: TFont;
    FColor: TColor;
    FFont: TFont;
    FAlignment: TAlignment;
    FEditor: TCellEditor;
    procedure SetHeaderColor(Value: TColor);
    procedure SetHeaderFont(Value: TFont);
    procedure SetCaption(Value: String);
    function GetCaption: String;
    procedure SetColor(Value: TColor);
    procedure SetWidth(Value: integer);
    function GetWidth: integer;
    procedure SetFont(Value: TFont);
    procedure SetAlignment(Value: TAlignment);
    procedure SetEditor(Value: TCellEditor);
    function GetGrid: TXStringGrid;
  public
    constructor Create(XStringColumns: TCollection); override;
    destructor Destroy; override;
    procedure ShowEditor(ARow: integer); virtual;
    property Grid: TXStringGrid read GetGrid;
  published
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor default clBtnFace;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property Caption: String read GetCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clWindow;
    property Width: integer read GetWidth write SetWidth default 64;
    property Font: TFont read FFont write SetFont;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Editor: TCellEditor read FEditor write SetEditor;
  end;

  TXStringColumns = class(TCollection)
  private
    FOwner: TXStringgrid;
    function GetItem(Index: Integer): TXStringColumnItem;
    procedure SetItem(Index: Integer; Value: TXStringColumnItem);
  public
    constructor Create(AOwner: TXStringGrid);
    destructor Destroy; override;
    property Items[Index: Integer]: TXStringColumnItem read GetItem write SetItem; default;
    property Owner: TXStringgrid read FOwner;
  end;

  TDrawEditorEvent = procedure (Sender: TObject; ACol, ARow: Longint; Editor: TCellEditor) of object;

  TXStringGrid = class(TStringgrid)
  private
    FCellEditor: TCellEditor;
    FColumns: TXStringColumns;
    FOnDrawEditor: TDrawEditorEvent;
    procedure SetColumns(Value: TXStringColumns);
  protected
    procedure SizeChanged(OldColCount, OldRowCount: Longint); override;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    function CanEditShow: Boolean; override;
    procedure DrawEditor(ACol, ARow: integer); virtual;
    procedure TopLeftChanged; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CellEditor: TCellEditor read FCellEditor;
  published
    property Columns: TXStringColumns read FColumns write SetColumns;
    property OnDrawEditor: TDrawEditorEvent read FOnDrawEditor write FOnDrawEditor;
  end;

implementation

uses Forms;

const
  StrCellEditorError: string = 'Cell Editor not of type TCellEditor';
  StrCellEditorAssigned: string = '%s is allready assigned to %s';

////////////////////////////////////////////////////////////////////////////////
// private TXStringColumnItem
//

procedure TXStringColumnItem.SetHeaderColor(Value: TColor);
begin
  FHeaderColor := Value;
  Grid.InvalidateCol(Index);
end;

procedure TXStringColumnItem.SetHeaderFont(Value: TFont);
begin
  FHeaderFont.assign(Value);
  Grid.InvalidateCol(Index);
end;

procedure TXStringColumnItem.SetCaption(Value: String);
begin
  Grid.Cells[Index, 0] := Value;
end;

function TXStringColumnItem.GetCaption: String;
begin
  result := Grid.Cells[Index, 0];
end;

procedure TXStringColumnItem.SetColor(Value: TColor);
begin
  FColor := Value;
  Grid.InvalidateCol(Index);
end;

procedure TXStringColumnItem.SetWidth(Value: integer);
begin
  Grid.ColWidths[Index] := Value;
end;

function TXStringColumnItem.GetWidth: integer;
begin
  result := Grid.ColWidths[Index];
end;

procedure TXStringColumnItem.SetFont(Value: TFont);
begin
  FFont.assign(Value);
  Grid.InvalidateCol(Index);
end;

procedure TXStringColumnItem.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    Grid.InvalidateCol(Index);
  end;
end;

procedure TXStringColumnItem.SetEditor(Value: TCellEditor);
begin
  if FEditor = Value then
    exit;

  if Value <> nil then
    Value.Attatch(Grid);
  if FEditor <> nil then
    FEditor.Detach;

  FEditor := Value
end;

function TXStringColumnItem.GetGrid: TXStringGrid;
begin
  result := TXStringColumns(Collection).Owner;
end;

////////////////////////////////////////////////////////////////////////////////
// public TXStringColumnItem
//

constructor TXStringColumnItem.Create(XStringColumns: TCollection);
begin
  inherited Create(XStringColumns);
  FHeaderColor := Grid.FixedColor;
  FHeaderFont := TFont.Create;
  FHeaderFont.assign(Grid.Font);
  FColor := Grid.Color;
  FFont := TFont.Create;
  FFont.assign(Grid.Font);
  FAlignment := taLeftJustify;
  FEditor := nil;
end;

destructor TXStringColumnItem.Destroy;
begin
  Editor := nil;
  FFont.free;
  FHeaderFont.free;
  inherited Destroy;
end;

procedure TXStringColumnItem.ShowEditor(ARow: integer);
var
  Rect: TRect;

  procedure AdjustRect;
  begin
    with Grid do begin
      Rect.TopLeft := Grid.ScreenToClient(ClientToScreen(Rect.TopLeft));
      Rect.BottomRight := Grid.ScreenToClient(ClientToScreen(Rect.BottomRight));
    end;
  end;

begin
  with Grid do begin
    if FEditor <> nil then begin
      Rect := CellRect(Index, ARow);
      AdjustRect;
      if not IsRectEmpty(Rect) then
        FEditor.Draw(Rect);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TXStringColumns private
//

function TXStringColumns.GetItem(Index: Integer): TXStringColumnItem;
begin
  result := TXStringColumnItem(inherited GetItem(Index));
end;

procedure TXStringColumns.SetItem(Index: Integer; Value: TXStringColumnItem);
begin
  inherited SetItem(Index, Value);
end;

////////////////////////////////////////////////////////////////////////////////
// TXStringColumns public
//

constructor TXStringColumns.Create(AOwner: TXStringgrid);
begin
  FOwner := AOwner;
  inherited Create(TXStringColumnItem);
end;

destructor TXStringColumns.Destroy;
begin
  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// TXStringgrid private
//

procedure TXStringgrid.SetColumns(Value: TXStringColumns);
begin
  FColumns.assign(Value);
end;

////////////////////////////////////////////////////////////////////////////////
// TXStringgrid protected
//

procedure TXStringgrid.SizeChanged(OldColCount, OldRowCount: Longint);
var
  c: integer;
begin
  if OldColCount < ColCount then
    for c := OldColCount to ColCount - 1 do
      FColumns.Add
  else
    for c := OldColCount - 1 downto ColCount do
      FColumns[c].Free;

  inherited SizeChanged(OldColCount, OldRowCount);
end;

procedure TXStringgrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
  Columns[FromIndex].Index := ToIndex;
  inherited ColumnMoved(FromIndex, ToIndex);
end;

procedure TXStringgrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);

  procedure DrawCellText(Alignment: TAlignment);
  var
    s: string;
    l: integer;
  begin
    case Alignment of
      taRightJustify:  begin
                         windows.SetTextAlign(Canvas.Handle, TA_RIGHT);
                         l := ARect.Right - 2;
                       end;
      taCenter:        begin
                         windows.SetTextAlign(Canvas.Handle, TA_CENTER);
                         l := ARect.Left + abs(ARect.Right - ARect.Left) div 2 + 2;
                       end;
      else             begin
                         windows.SetTextAlign(Canvas.Handle, TA_LEFT);
                         l := ARect.Left + 2;
                       end;
    end;

    s := Cells[ACol, ARow];
    ExtTextOut(Canvas.Handle, l, ARect.Top, ETO_CLIPPED or ETO_OPAQUE, @ARect, PChar(S), Length(S), nil);
  end;

var
  Column: TXStringColumnItem;
begin
  if DefaultDrawing then begin
    Column := Columns[ACol];
    if ARow < FixedRows then begin
      Canvas.Brush.Color := Column.FHeaderColor;
      Canvas.Font := Column.FHeaderFont;
    end
    else if ACol >= FixedCols then begin
      Canvas.Brush.Color := Column.FColor;
      Canvas.Font := Column.FFont;
    end;
    if (gdSelected in AState) then begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText;
    end;
    DefaultDrawing := false;
    DrawCellText(Column.Alignment);
    inherited DrawCell(ACol, ARow, ARect, AState);
    DefaultDrawing := true;
  end
  else
    inherited DrawCell(ACol, ARow, ARect, AState);
end;

function TXStringgrid.CanEditShow: Boolean;
begin
  if inherited CanEditShow and Focused then
    if FColumns[Col].Editor <> nil then begin
      FCellEditor := FColumns[Col].Editor;
      FCellEditor.StartEdit;
      DrawEditor(Col, Row);
    end;
  result := false;                                    
end;

procedure TXStringgrid.DrawEditor(ACol, ARow: integer);
begin
  if FColumns[ACol].Editor = nil then
    exit;

 if assigned(FOnDrawEditor) then
   OnDrawEditor(self, ACol, ARow, FColumns[ACol].Editor)
  else
    FColumns[ACol].ShowEditor(ARow);
end;

procedure TXStringGrid.TopLeftChanged;
begin
  inherited TopLeftChanged;
  if FCellEditor <> nil then
    DrawEditor(Col, Row);
end;

procedure TXStringGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  c, r: LongInt;
begin
  MouseToCell(X, Y, c, r);
  if (goAlwaysShowEditor in Options) and (c >= FixedCols) and (r >= FixedRows) then begin
    if FCellEditor <> nil then
      FCellEditor.Clear;
    row := r;
    col := c;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

////////////////////////////////////////////////////////////////////////////////
// TXStringgrid public
//

constructor TXStringgrid.Create(AOwner: TComponent);
var
  c: integer;
begin
  inherited Create(AOwner);
  FColumns := TXStringColumns.Create(self);
  for c := 0 to ColCount - 1 do
    FColumns.Add;
end;

destructor TXStringgrid.Destroy;
begin
  FColumns.free;
  FColumns := nil;
  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// TCellEditor
//

destructor TCellEditor.destroy;
var
  c: integer;
begin
  if Grid <> nil then
    with Grid do
      if Columns <> nil then
        for c := 0 to Columns.count - 1 do
          if Columns[c].Editor = self then         // Remove references to this instance
            Columns[c].Editor := nil;

  inherited destroy;
end;

function TCellEditor.GetGrid: TXStringgrid;
begin
  result := FGrid;
end;

procedure TCellEditor.Attatch(AGrid: TXStringGrid);
begin
  if AGrid = FGrid then begin
    Inc(FReferences);
    exit;
  end;

  if FGrid <> nil then
    raise ECellEditorError.Create(Format(StrCellEditorAssigned, [Name, FGrid.Name]));

  FGrid := AGrid;
  Inc(FReferences);
end;

procedure TCellEditor.Detach;
begin
  Dec(FReferences);
  if FReferences = 0 then
    FGrid := nil;
end;

////////////////////////////////////////////////////////////////////////////////
// TMetaCellEditor public
//

constructor TMetaCellEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if csDesigning in ComponentState then
    FEditor := nil
  else begin
    try
      FEditor := InitEditor(AOwner);
      if FEditor = nil then
        raise ECellEditorError.Create(StrCellEditorError);

      FEditor.FreeNotification(self);  // Notify me if FEditor gets freed by someone
      (AOwner as TWinControl).InsertControl(FEditor);
    except
      raise ECellEditorError.Create(StrCellEditorError);
    end;
  end;
end;

destructor TMetaCellEditor.Destroy;
begin
  FEditor.free;            // FEdit propably set to nil by notification
  inherited Destroy;       // method. So FEdit has been freed allready
end;

procedure TMetaCellEditor.Draw(Rect: TRect);
begin
  if FEditor = nil then
    exit;

  with FEditor do begin
    left := Rect.left;
    top := Rect.top;
    width := Rect.right - Rect.left;
    height := Rect.bottom - Rect.top;
    visible := true;
    SetFocus;
  end;
end;

procedure TMetaCellEditor.Clear;
begin
  FEditor.visible := false;
  Grid.FCellEditor := nil;         // Private fields in same unit are friends,
end;                               // so I can accss this here

////////////////////////////////////////////////////////////////////////////////
// TMetaCellEditor protected
//

procedure TMetaCellEditor.Attatch(AGrid: TXStringGrid);
begin
  inherited Attatch(AGrid);
  if not (csDesigning in ComponentState) then
    windows.SetParent(FEditor.Handle, Grid.Handle);
end;

procedure TMetaCellEditor.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation <> opRemove) or (FEditor = nil) then
    exit;

  if FEditor.ClassName = AComponent.ClassName then
    FEditor := nil;
end;

function TMetaCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := nil;
end;

function TMetaCellEditor.GetEditor: TWinControlInterface;
begin
  result := TWinControlInterface(FEditor);
end;

////////////////////////////////////////////////////////////////////////////////
// TEditInplace private
//

procedure TEditInplace.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TEditInplace.KeyDown(var Key: Word; Shift: TShiftState);
var
  AllowEndEdit: boolean;
begin
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := true;
      VK_DOWN:   AllowEndEdit := true;
      VK_LEFT:   AllowEndEdit := (SelLength = 0) and (SelStart = 0);
      VK_RIGHT:  AllowEndEdit := (SelLength = 0) and (SelStart >= length(Text));
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.FGrid.Options
    end;

    if assigned(FCellEditor.FAllowEndEditEvent) then
      FCellEditor.FAllowEndEditEvent(self, Key, Shift, AllowEndEdit);
    if AllowEndEdit then begin
      DoExit;
      FCellEditor.Grid.KeyDown(Key, Shift);
      FCellEditor.Grid.SetFocus;
      Key := 0;
    end;
  end;
  if Key <> 0 then
    inherited KeyDown(Key, Shift);
end;

procedure TEditInplace.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in FCellEditor.FGrid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TEditInplace.KeyPress(var Key: Char);
begin
  if Key = #13 then begin
    FCellEditor.Grid.SetFocus;
    Key := #0;
  end;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TEditInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

////////////////////////////////////////////////////////////////////////////////
// TEditInplace public
//

constructor TEditInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FCellEditor := CellEditor;
  visible := false;
  Ctl3d := false;
  BorderStyle := bsNone;
  ParentCtl3D := False;
  TabStop := False;
end;

////////////////////////////////////////////////////////////////////////////////
// TEditCellEditor public
//

procedure TEditCellEditor.Draw(Rect: TRect);
var
  R: TRect;
begin
  if FEditor = nil then
    exit;

  inherited Draw(Rect);
  with FEditor do begin
    R := Classes.Rect(2, 2, Width - 2, Height);
    SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TEditCellEditor protected
//

function TEditCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := TEditInplace.Create(AOwner, self);
end;

procedure TEditCellEditor.StartEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with FEditor as TEditInplace do begin
    Text := Grid.GetEditText(Grid.Col, Grid.Row);
    if Text = '' then
      Text := FDefaultText;
    SelStart := 0;
    SelLength := -1;
  end;
end;

procedure TEditCellEditor.EndEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with Grid do
    SetEditText(Col, Row, (FEditor as TEditInplace).Text);
end;

////////////////////////////////////////////////////////////////////////////////
// TComboInplace protected
//

procedure TComboInplace.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TComboInplace.KeyDown(var Key: Word; Shift: TShiftState);
var
  AllowEndEdit: boolean;
begin
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := false;
      VK_DOWN:   AllowEndEdit := false;
      VK_LEFT:   AllowEndEdit := ((SelLength = 0) and (SelStart = 0)) or (Style <> csDropDown);
      VK_RIGHT:  AllowEndEdit := ((SelLength = 0) and (SelStart >= length(Text))) or (Style <> csDropDown);
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.FGrid.Options
    end;

    if assigned(FCellEditor.FAllowEndEditEvent) then
      FCellEditor.FAllowEndEditEvent(self, Key, Shift, AllowEndEdit);
    if AllowEndEdit then begin
      DoExit;
      FCellEditor.Grid.KeyDown(Key, Shift);
      FCellEditor.Grid.SetFocus;
      Key := 0;
    end;
  end;
  if Key <> 0 then
    inherited KeyDown(Key, Shift);
end;

procedure TComboInplace.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in FCellEditor.FGrid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TComboInplace.KeyPress(var Key: Char);
begin
  if Key = #13 then begin
    FCellEditor.Grid.SetFocus;
    Key := #0;
  end;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TComboInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

////////////////////////////////////////////////////////////////////////////////
// TComboInplace public
//

constructor TComboInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FCellEditor := CellEditor;
  visible := false;
  Ctl3d := false;
  ParentCtl3D := False;
  TabStop := False;
end;

////////////////////////////////////////////////////////////////////////////////
// TComboCellEditor protected
//

procedure TComboCellEditor.StartEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with FEditor as TComboInplace do begin
    case Style of
      csDropDown:
        text := Grid.GetEditText(Grid.Col, Grid.Row);
      csDropDownList:
        itemindex := Items.IndexOf(Grid.GetEditText(Grid.Col, Grid.Row));
    end;
    if Text = '' then
      Text := FDefaultText;
  end;
end;

procedure TComboCellEditor.EndEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with Grid do
    SetEditText(Col, Row, (FEditor as TComboInplace).Text);
end;

function TComboCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := TComboInplace.Create(AOwner, self);
end;

function TComboCellEditor.GetItems: TStrings;
begin
  result :=  (FEditor as TComboInplace).Items;
end;

function TComboCellEditor.GetStyle: TComboBoxStyle;
begin
  if FEditor = nil then
    result := FStyle
  else
    result := TComboInplace(FEditor).Style;
end;

procedure TComboCellEditor.SetStyle(Value: TComboBoxStyle);
begin
  if FEditor = nil then
    FStyle := Value
  else
    TComboInplace(FEditor).Style := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// TMaskEditInplace private
//

procedure TMaskEditInplace.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TMaskEditInplace.KeyDown(var Key: Word; Shift: TShiftState);
var
  AllowEndEdit: boolean;
begin
  if Key in [VK_TAB, VK_UP, VK_DOWN] then begin                         // I cannot handle other keys here
    case Key of                                                         // Since the validation mechanism
      VK_UP,                                                            // of TMaskEdit seems to send Keystrokes
      VK_DOWN:   AllowEndEdit := true;                                  // to the control which would interfere here.
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.FGrid.Options;
    end;
    if assigned(FCellEditor.FAllowEndEditEvent) then
      FCellEditor.FAllowEndEditEvent(self, Key, Shift, AllowEndEdit);
    if AllowEndEdit then begin
      DoExit;
      FCellEditor.Grid.KeyDown(Key, Shift);
      FCellEditor.Grid.SetFocus;
      Key := 0;
    end;
  end;
  if Key <> 0 then
    inherited KeyDown(Key, Shift);
end;

procedure TMaskEditInplace.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in FCellEditor.FGrid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TMaskEditInplace.KeyPress(var Key: Char);
begin
  if Key = #13 then begin
    FCellEditor.Grid.SetFocus;
    Key := #0;
  end;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TMaskEditInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

////////////////////////////////////////////////////////////////////////////////
// TMaskEditInplace public
//

constructor TMaskEditInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FCellEditor := CellEditor;
  visible := false;
  BorderStyle := bsNone;
  Ctl3d := false;
  ParentCtl3D := False;
  TabStop := False;
end;

////////////////////////////////////////////////////////////////////////////////
// TMaskEditCellEditor private
//

function TMaskEditCellEditor.GetEditMask: String;
begin
  if FEditor = nil then
    result := FEditMask
  else
    result := TMaskEditInplace(FEditor).EditMask;
end;

procedure TMaskEditCellEditor.SetEditMask(Value: String);
begin
  if FEditor = nil then
    FEditMask := Value
  else
    TMaskEditInplace(FEditor).EditMask := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// TMaskEditCellEditor public
//

procedure TMaskEditCellEditor.Draw(Rect: TRect);
begin
  if FEditor = nil then
    exit;

  Inc(Rect.Left);
  Dec(Rect.Right);
  Inc(Rect.Top);
  Dec(Rect.Bottom);
  inherited Draw(Rect);
end;

////////////////////////////////////////////////////////////////////////////////
// TMaskEditCellEditor protected
//

function TMaskEditCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := TMaskEditInplace.Create(AOwner, self);
end;

procedure TMaskEditCellEditor.StartEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with FEditor as TMaskEditInplace do begin
    Text := Grid.GetEditText(Grid.Col, Grid.Row);
    if Text = '' then
      Text := FDefaultText;
  end;
end;

procedure TMaskEditCellEditor.EndEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with Grid do
    SetEditText(Col, Row, (FEditor as TMaskEditInplace).Text);
end;

////////////////////////////////////////////////////////////////////////////////
// TUpDownInplace private
//

procedure TUpDownInplace.UpDownClick(Sender: TObject; Button: TUDBtnType);
var
  c: integer;
begin
  c := StrToIntDef(Text, 0);
  case Button of
    btNext:  inc(c);
    btPrev:  dec(c);
  end;
  FUpDown.Position := c;
  Text := IntToStr(c);
end;

procedure TUpDownInplace.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TUpDownInplace.KeyDown(var Key: Word; Shift: TShiftState);
var
  AllowEndEdit: boolean;
begin
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := false;
      VK_DOWN:   AllowEndEdit := false;
      VK_LEFT:   AllowEndEdit := (SelLength = 0) and (SelStart = 0);
      VK_RIGHT:  AllowEndEdit := (SelLength = 0) and (SelStart >= length(Text));
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.FGrid.Options;
    end;

    if assigned(FCellEditor.FAllowEndEditEvent) then
      FCellEditor.FAllowEndEditEvent(self, Key, Shift, AllowEndEdit);
    if AllowEndEdit then begin
      DoExit;
      FCellEditor.Grid.KeyDown(Key, Shift);
      FCellEditor.Grid.SetFocus;
      Key := 0;
    end;
  end;
  if Key = VK_DOWN then begin
    FUpDown.OnClick(self, btPrev);
    Key := 0;
  end;
  if Key = VK_UP then begin
    FUpDown.OnClick(self, btNext);
    Key := 0;
  end;
  if Key <> 0 then
    inherited KeyDown(Key, Shift);
end;

procedure TUpDownInplace.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in FCellEditor.FGrid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TUpDownInplace.KeyPress(var Key: Char);
begin
  if Key = #13 then begin
    FCellEditor.Grid.SetFocus;
    Key := #0;
  end;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TUpDownInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

////////////////////////////////////////////////////////////////////////////////
// TUpDownInplace public
//

constructor TUpDownInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FUpDown := TUpDown.Create(AOwner);
  with FUpDown do begin
    visible := false;
    TabStop := false;
    Max := 32767;
    Min := -32768;
    OnClick := UpDownClick;
  end;
  FCellEditor := CellEditor;       
  visible := false;
  Ctl3d := false;
  BorderStyle := bsNone;
  ParentCtl3D := False;
  TabStop := False;
end;

destructor TUpDownInplace.Destroy;
begin
  FUpDown.free;
  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// TUpDownCellEditor public
//

procedure TUpDownCellEditor.Draw(Rect: TRect);
begin
  if FEditor = nil then
    exit;

  Inc(Rect.Left);
  Dec(Rect.Right);
  Inc(Rect.Top);
  Dec(Rect.Bottom);
  inherited Draw(Rect);

  with TUpDownInplace(FEditor) do begin
    UpDown.left := Rect.right - UpDown.width;
    UpDown.top := Rect.top;
    UpDown.height := Rect.bottom - Rect.top;
    UpDown.visible := true;
  end;
end;

procedure TUpDownCellEditor.Clear;
begin
  inherited Clear;
  TUpDownInplace(FEditor).UpDown.visible := false;
end;

////////////////////////////////////////////////////////////////////////////////
// TUpDownCellEditor protected
//

procedure TUpDownCellEditor.Attatch(AGrid: TXStringGrid);
begin
  inherited Attatch(AGrid);
  if not (csDesigning in ComponentState) then
    windows.SetParent((FEditor as TUpDownInplace).UpDown.Handle, Grid.Handle);
end;

function TUpDownCellEditor.InitEditor(AOwner: TComponent): TWinControl;
var
  Inplace: TUpDownInplace;
begin
  Inplace := TUpDownInplace.Create(AOwner, self);
  result := Inplace;

  try
    if Inplace = nil then
      raise ECellEditorError.Create(StrCellEditorError);
     Inplace.FreeNotification(self);  // Notify me if FUpDown gets freed by someone
    (AOwner as TWinControl).InsertControl(Inplace.UpDown);
  except
    raise ECellEditorError.Create(StrCellEditorError);
  end;

end;

procedure TUpDownCellEditor.StartEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with FEditor as TUpDownInplace do begin
    Text := Grid.GetEditText(Grid.Col, Grid.Row);
    if Text = '' then
      Text := FDefaultText;
    try
      TUpDownInplace(FEditor).UpDown.Position := StrToInt(Text);
    except
      TUpDownInplace(FEditor).UpDown.Position := 0;
    end;
  end;
end;

procedure TUpDownCellEditor.EndEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with Grid do
    SetEditText(Col, Row, (FEditor as TUpDownInplace).Text);
end;

procedure TUpDownCellEditor.Notification(AComponent: TComponent; Operation: TOperation); 
begin
  inherited Notification(AComponent, Operation);

  if (Operation <> opRemove) or (FEditor = nil) then
    exit;
    
  if AComponent = TUpDownInplace(FEditor).UpDown then
    TUpDownInplace(FEditor).FUpDown := nil;
end;

end.
