{
  ------------------------------------------------------------------------------
    Filename: XStringGrid.pas
    Version:  v2.0
    Authors:  Michael D�rig (md)
    Purpose:  XStringgrid is an extended version of the stringgrid which offers
              a lot more flexibility. It's possible to apply different colours
              and fonts to each column and it's header and align the content
              of the cells. In addition it offers different inplace editors
              which can be assigned to columns to edit their cells. So far
              there are edit, combo, maskedit and spincontrol inplace editors
              implemented.
  ------------------------------------------------------------------------------
    (C) 1999  M. D�rig
              CH-4056 Basel
              mduerig@eye.ch / www.eye.ch/~mduerig
  ------------------------------------------------------------------------------
    History:  11.03.97md  v1.0 Release v1.0
              14.09.97md  v1.1 Bugs fixed
              29.11.97md  v1.1 TEditCelleditor text selected on entry now
              05.12.97md  v1.1 Fixed Cant focus invisible control bug
              12.12.97md  v1.2 Provides goAlwaysShowEditor now
              07.04.98md  v1.2 Corrected problem with goTabs
              22.06.99md  v1.2 Made FEditor of TMetaCellEditor protected
              22.06.99md  v1.2 Made StartEdit, EndEdit of TCellEditor public
              22.06.99md  v1.2 Added TXStringGrid.HandleKey
              10.07.99md  v1.2 Fixed AllowEndedit initialisation probl.
              22.07.99md  v1.2 Fixed TXStringGrid.MouseDown bug. Thanx to Jacob!
              03.08.99md  v1.2 Fixed RecreateWnd bug.
              12.08.99md  v2.0 Release v2.0
              03.10.99md  v2.0 TCellEditor.init for dynamic CellEditor creation
              17.10.99md  v2.0 Fixed problem with TUpDownCellEditor properties
              17.10.99md  v2.0 Fixed DefaultText bug in TMaskEditCellEditor
              22.10.99md  v2.0 Fixed cell clearing problem with goTabs
              22.10.99md  v2.0 OnSelectCell triggers now when clicking a cell
              23.12.99md  v2.0 Fixed ugly bug in CompareProc and SwapProc
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
    procedure GridWndDestroying; virtual;
    property DefaultText: String read FDefaultText write FDefaultText;
  public
    destructor destroy; override;
    procedure init; virtual;
    procedure StartEdit; virtual; abstract;
    procedure EndEdit; virtual; abstract;
    procedure SetCellText(Value: string); virtual;
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
  protected
    FEditor: TWinControl;
    procedure Attatch(AGrid: TXStringGrid); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function InitEditor(AOwner: TComponent): TWinControl; virtual;
    function GetEditor: TWinControlInterface; virtual;
    procedure GridWndDestroying; override;
    procedure loaded; override;
  public
    destructor Destroy; override;
    procedure init; override;
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
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); virtual;
  end;

  TEditCellEditor = class(TMetaCellEditor)
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
  public
    procedure StartEdit; override;
    procedure EndEdit; override;
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
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); virtual;
  end;

  TComboCellEditor = class(TMetaCellEditor)
  private
    FStyle: TComboBoxStyle;
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
    function GetItems: TStrings;
    function GetStyle: TComboBoxStyle; virtual;
    procedure SetStyle(Value: TComboBoxStyle); virtual;
  public
    procedure StartEdit; override;
    procedure EndEdit; override;
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
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); virtual;
  end;

  TMaskEditCellEditor = class(TMetaCellEditor)
  private
    FEditMask: String;
    function GetEditMask: String;
    procedure SetEditMask(Value: String);
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
  public
    procedure StartEdit; override;
    procedure EndEdit; override;
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
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); virtual;
    destructor Destroy; override;
    property UpDown: TUpDown read FUpDown;
  end;

  TUpDownCellEditor = class(TMetaCellEditor)
  private
    FMin: Smallint;
    FMax: Smallint;
    FIncrement: integer;
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function getMin: Smallint;
    procedure setMin(Value: Smallint);
    function getMax: Smallint;
    procedure setMax(Value: Smallint);
    procedure setIncrement(Value: integer);
    function getIncrement: integer;
  public
    constructor create(AOwner: TComponent); override;
    procedure StartEdit; override;
    procedure EndEdit; override;
    procedure Draw(Rect: TRect); override;
    procedure Clear; override;
  published
    property DefaultText;
    property Min: Smallint read getMin write setMin;
    property Max: Smallint read getMax write setMax;
    property Increment: integer read getIncrement write setIncrement default 1;
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
  TCompareProc = function(Sender: TXStringGrid; SortCol, row1, row2: integer): Integer;
  TSwapProc = procedure(Sender: TXStringGrid; SortCol, row1, row2: integer);

  TXStringGrid = class(TStringgrid)
  private
    FEditCol: integer;
    FEditRow: integer;
    FMultiLine: boolean;
    FCellEditor: TCellEditor;
    FColumns: TXStringColumns;
    FOnDrawEditor: TDrawEditorEvent;
    procedure SetColumns(Value: TXStringColumns);
    procedure quickSort(col, bottom, top: integer; compare: TCompareProc; swap: TSwapProc);
  protected
    procedure SizeChanged(OldColCount, OldRowCount: Longint); override;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    function CanEditShow: Boolean; override;
    procedure DrawEditor(ACol, ARow: integer); virtual;
    procedure TopLeftChanged; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DestroyWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure HandleKey(var Key: Word; Shift: TShiftState);
    procedure sort(col: integer; compare: TCompareProc; swap: TSwapProc);
    property CellEditor: TCellEditor read FCellEditor;
  published
    property Columns: TXStringColumns read FColumns write SetColumns;
    property OnDrawEditor: TDrawEditorEvent read FOnDrawEditor write FOnDrawEditor;
    property MultiLine: boolean read FMultiLine write FMultiLine;
  end;

  function CompareProc(Sender: TXStringGrid; SortCol, row1, row2: integer): Integer;
  procedure SwapProc(Sender: TXStringGrid; SortCol, row1, row2: integer);

implementation
uses Forms;

type
  TWinControlCracker = class(TWinControl);

const
  StrCellEditorError: string = 'Cell Editor not of type TCellEditor';
  StrCellEditorAssigned: string = '%s is allready assigned to %s';

function CompareProc(Sender: TXStringGrid; SortCol, row1, row2: integer): Integer;
begin
  with Sender do begin
    result := AnsiCompareStr(Cells[SortCol, row1], Cells[SortCol, row2]);
    if result <> 0 then begin
     // Put empty cells to the back
     if (Cells[SortCol, row1] = '') then
        result := 1
      else if (Cells[SortCol, row2] = '') then
        result := -1
    end
    else
      // Force a decision -> stability!
      result := row1 - row2;
  end;
end;

procedure SwapProc(Sender: TXStringGrid; SortCol, row1, row2: integer);
var
  s: string;
  o: TObject;
begin
  with Sender do begin
    s := Cells[SortCol, row1];
    o := Objects[SortCol, row1];
    Cells[SortCol, row1] := Cells[SortCol, row2];
    Objects[SortCol, row1] := Objects[SortCol, row2];
    Cells[SortCol, row2] := s;
    Objects[SortCol, row2] := o;
  end;
end;

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

procedure TXStringgrid.quickSort(col, bottom, top: integer; compare: TCompareProc; swap: TSwapProc);
var
  up, down, pivot: integer;
begin
  down := top;
  up := bottom;
  pivot := (top + bottom) div 2;

  repeat
    while compare(self, col, up, pivot) < 0 do
      inc(up);

    while compare(self, col, down, pivot) > 0 do
      dec(down);

    if up <= down then begin
      swap(self, col, up, down);
      if pivot = up then
        pivot := down
      else if pivot = down then
        pivot := up;
      inc(up);
      dec(down);
    end;
  until up > down;

  if bottom < down then
    quickSort(col, bottom, down, compare, swap);

  if up < top then
    quickSort(col, up, top, compare, swap);
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
    r: TRect;
    a: integer;
  begin
    r := ARect;
    r.Top := r.Top + 2;
    r.Bottom := r.Bottom - 2;
    r.left := r.left + 2;
    r.Right := r.Right - 2;

    case Alignment of
      taRightJustify:  a := DT_RIGHT;
      taCenter:        a := DT_CENTER;
      else             a := DT_LEFT;
    end;

    if FMultiLine then
      a := a or DT_WORDBREAK
    else
      a := a or DT_SINGLELINE;

    a := a or DT_NOPREFIX;
    s := Cells[ACol, ARow];
    FillRect(Canvas.Handle, ARect, Canvas.Brush.Handle);
    DrawText(Canvas.Handle, PChar(s), -1, r, a);
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
      FEditCol := Col;
      FEditRow := Row;
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
  s: TGridRect;
begin
  MouseToCell(X, Y, c, r);
  if (goAlwaysShowEditor in Options) and (c >= FixedCols) and
     (r >= FixedRows) and SelectCell(c, r)
  then begin
    if FCellEditor <> nil then
      FCellEditor.Clear;

    s.left := c;
    s.Right := c;
    s.Top := r;
    s.Bottom := r;
    Selection := s;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TXStringgrid.DestroyWnd;
var
  c: integer;
begin
  for c := 0 to FColumns.count - 1 do
    if FColumns[c].FEditor <> nil then
      FColumns[c].FEditor.GridWndDestroying;

  inherited DestroyWnd;
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

procedure TXStringgrid.HandleKey(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
end;

procedure TXStringGrid.sort(col: integer; compare: TCompareProc; swap: TSwapProc);
begin
  if not assigned(compare) then
    compare := CompareProc;

  if not assigned(swap) then
    swap := SwapProc;

  quickSort(col, FixedRows, RowCount - 1, compare, swap);
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

procedure TCellEditor.init;
begin
  // empty
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

procedure TCellEditor.GridWndDestroying;
begin
end;

procedure TCellEditor.SetCellText(Value: string);
begin
  with Grid do
    SetEditText(FEditCol, FEditRow, Value);
end;

////////////////////////////////////////////////////////////////////////////////
// TMetaCellEditor public
//

procedure TMetaCellEditor.loaded;
begin
  inherited loaded;
  Init;
end;

destructor TMetaCellEditor.Destroy;
begin
  FEditor.free;            // FEdit propably set to nil by notification
  inherited Destroy;       // method. So FEdit has been freed allready
end;

procedure TMetaCellEditor.init;
begin
  if csDesigning in ComponentState then
    FEditor := nil
  else begin
    try
      FEditor := InitEditor(Owner);
      if FEditor = nil then
        raise ECellEditorError.Create(StrCellEditorError);

      FEditor.FreeNotification(self);  // Notify me if FEditor gets freed by someone
      (Owner as TWinControl).InsertControl(FEditor);
    except
      raise ECellEditorError.Create(StrCellEditorError);
    end;
  end;
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
  if not (csDesigning in ComponentState) and (FEditor <> nil) and (Grid <> nil) then
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

procedure TMetaCellEditor.GridWndDestroying;
begin
  if FEditor <> nil then
    TWinControlCracker(FEditor).DestroyWnd;
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
  AllowEndEdit := false;
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := true;
      VK_DOWN:   AllowEndEdit := true;
      VK_LEFT:   AllowEndEdit := (SelLength = 0) and (SelStart = 0);
      VK_RIGHT:  AllowEndEdit := (SelLength = 0) and (SelStart >= length(Text));
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.FGrid.Options
    end;
  end;

  if assigned(FCellEditor.FAllowEndEditEvent) then
    FCellEditor.FAllowEndEditEvent(self, Key, Shift, AllowEndEdit);
  if AllowEndEdit then begin
    DoExit;
    FCellEditor.Grid.KeyDown(Key, Shift);
    FCellEditor.Grid.SetFocus;
    Key := 0;
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
  end
  else if Key = #9 then
    Key := #0;

  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TEditInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

procedure TEditInplace.CreateWnd;
begin
  inherited CreateWnd;
  if FCellEditor.grid <> nil then
    windows.SetParent(Handle, FCellEditor.grid.Handle);
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
var
  s: string;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with FEditor as TEditInplace do begin
    s := Grid.GetEditText(Grid.Col, Grid.Row);
    if s = '' then
      Text := FDefaultText
    else
      Text := s;

    SelStart := 0;
    SelLength := -1;
  end;
end;

procedure TEditCellEditor.EndEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  SetCellText((FEditor as TEditInplace).Text);
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
  AllowEndEdit := false;
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := false;
      VK_DOWN:   AllowEndEdit := false;
      VK_LEFT:   AllowEndEdit := ((SelLength = 0) and (SelStart = 0)) or (Style <> csDropDown);
      VK_RIGHT:  AllowEndEdit := ((SelLength = 0) and (SelStart >= length(Text))) or (Style <> csDropDown);
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.FGrid.Options
    end;
  end;

  if assigned(FCellEditor.FAllowEndEditEvent) then
    FCellEditor.FAllowEndEditEvent(self, Key, Shift, AllowEndEdit);
  if AllowEndEdit then begin
    DoExit;
    FCellEditor.Grid.KeyDown(Key, Shift);
    FCellEditor.Grid.SetFocus;
    Key := 0;
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
  end
  else if Key = #9 then
    Key := #0;

  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TComboInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

procedure TComboInplace.CreateWnd;
begin
  inherited CreateWnd;
  if FCellEditor.grid <> nil then
    windows.SetParent(Handle, FCellEditor.grid.Handle);
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

  SetCellText((FEditor as TComboInplace).Text);
end;

function TComboCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := TComboInplace.Create(AOwner, self);
  TComboInplace(result).Style := FStyle;
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
  AllowEndEdit := false;
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
  end
  else if Key = #9 then
    Key := #0;

  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TMaskEditInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

procedure TMaskEditInplace.CreateWnd;
begin
  inherited CreateWnd;
  if FCellEditor.grid <> nil then
    windows.SetParent(Handle, FCellEditor.grid.Handle);
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
  TMaskEditInplace(result).EditMask := FEditMask;
end;

procedure TMaskEditCellEditor.StartEdit;
var
  s: string;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  with FEditor as TMaskEditInplace do begin
    s := Grid.GetEditText(Grid.Col, Grid.Row);
    if s = '' then
      Text := FDefaultText
    else
      Text := s;
  end;
end;

procedure TMaskEditCellEditor.EndEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  SetCellText((FEditor as TMaskEditInplace).Text);
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
    btNext:  if c + FUpDown.Increment <= FUpDown.Max then
               inc(c, FUpDown.Increment);
    btPrev:  if c - FUpDown.Increment >= FUpDown.Min then
               dec(c, FUpDown.Increment);
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
  AllowEndEdit := false;
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := false;
      VK_DOWN:   AllowEndEdit := false;
      VK_LEFT:   AllowEndEdit := (SelLength = 0) and (SelStart = 0);
      VK_RIGHT:  AllowEndEdit := (SelLength = 0) and (SelStart >= length(Text));
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.FGrid.Options;
    end;
  end;

  if assigned(FCellEditor.FAllowEndEditEvent) then
    FCellEditor.FAllowEndEditEvent(self, Key, Shift, AllowEndEdit);
  if AllowEndEdit then begin
    DoExit;
    FCellEditor.Grid.KeyDown(Key, Shift);
    FCellEditor.Grid.SetFocus;
    Key := 0;
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
  end
  else if Key = #9 then
    Key := #0;

  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TUpDownInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

procedure TUpDownInplace.CreateWnd;
begin
  inherited CreateWnd;
  if FCellEditor.grid <> nil then begin
    windows.SetParent(FUpDown.Handle, FCellEditor.FGrid.Handle);
    windows.SetParent(Handle, FCellEditor.grid.Handle);
  end;
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
    Max := TUpDownCellEditor(CellEditor).Max;
    Min := TUpDownCellEditor(CellEditor).Min;
    Increment := TUpDownCellEditor(CellEditor).Increment;
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

constructor TUpDownCellEditor.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FIncrement := 1;
end;

procedure TUpDownCellEditor.Draw(Rect: TRect);
begin
  if FEditor = nil then
    exit;

  with TUpDownInplace(FEditor) do begin
    Inc(Rect.Left);
    Rect.Right := Rect.Right - UpDown.Width;
    Inc(Rect.Top);
    Dec(Rect.Bottom);
    inherited Draw(Rect);

    UpDown.left := Rect.right;
    UpDown.top := Rect.Top;
    UpDown.height := Rect.bottom - Rect.Top;
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

  SetCellText((FEditor as TUpDownInplace).Text);
end;

procedure TUpDownCellEditor.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation <> opRemove) or (FEditor = nil) then
    exit;

  if AComponent = TUpDownInplace(FEditor).UpDown then
    TUpDownInplace(FEditor).FUpDown := nil;
end;

function TUpDownCellEditor.getMin: Smallint;
begin
  if FEditor = nil then
    result := FMin
  else
    result := TUpDownInplace(FEditor).FUpDown.Min;
end;

procedure TUpDownCellEditor.setMin(Value: Smallint);
begin
  if FEditor = nil then
    FMin := Value
  else
    TUpDownInplace(FEditor).FUpDown.Min := Value;
end;

function TUpDownCellEditor.getMax: Smallint;
begin
  if FEditor = nil then
    result := FMax
  else
    result := TUpDownInplace(FEditor).FUpDown.Max;
end;

procedure TUpDownCellEditor.setMax(Value: Smallint);
begin
  if FEditor = nil then
    FMax := Value
  else
    TUpDownInplace(FEditor).FUpDown.Max := Value;
end;

procedure TUpDownCellEditor.setIncrement(Value: integer);
begin
  if FEditor = nil then
    FIncrement := Value
  else
    TUpDownInplace(FEditor).FUpDown.Increment := Value;
end;

function TUpDownCellEditor.getIncrement: integer;
begin
  if FEditor = nil then
    result := FIncrement
  else
    result := TUpDownInplace(FEditor).FUpDown.Increment;
end;

end.
