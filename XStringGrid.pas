{
  ------------------------------------------------------------------------------
    Filename: XStringGrid.pas
    Version:  v2.0
    Authors:  Michael Dürig (md)
    Purpose:  XStringgrid is an extended version of the stringgrid which offers
              a lot more flexibility. It's possible to apply different colours
              and fonts to each column and it's header and align the content
              of the cells. In addition it offers different inplace editors
              which can be assigned to columns to edit their cells. So far
              there are edit, combo, maskedit and spincontrol inplace editors
              implemented.
  ------------------------------------------------------------------------------
    (C) 1999  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / http://www.eye.ch/~mduerig
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
              26.11.2k md v2.1 Included new features from Marcus Wirth
              03.12.2k md v2.1 Fixed bug which caused wrong content in OnSelectCell
              10.08.01md  v2.5 ImmediateEditMode added. Thanx to Ahmet Semiz
              10.08.01md  v2.5 Added Elipsis button to TEditCellEditor. Thanx to
                               Mitja for the idea.
              10.08.01md  v2.5 Ctl3D property is now published. Thanx to Mitja
              10.08.01md  v2.5 Added properties FixedLineColor and
                               GridLineColor. Thanx to Mitja.
              12.08.01md  v2.5 Fixed problem when grid used in a frame.
                               Thanks to Andreas Schmidt
              13.08.01md  v2.5 Fixed problem with aligning the grid
              16.08.01md  v2.5 Fixed problem with editors in appearing fixed rows
              16.08.01md  v2.5 Release 2.5
------------------------------------------------------------------------------
}

{$I VERSIONS.INC}
unit XStringGrid;

interface

uses
  Grids, Classes, Graphics, Controls, Windows, StdCtrls, SysUtils, Messages,
  Mask, Dialogs, ComCtrls, Buttons;

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


  TInplaceSpeedButton = class(TSpeedButton)
{$IFDEF REQUESTALIGN_FIXED}
  protected
    procedure RequestAlign; override; 
{$ENDIF}
  end;

  TEditInplace = class(TCustomEdit)
  private
    FCellEditor: TCellEditor;
    FButton: TSpeedButton;
  protected
{$IFDEF REQUESTALIGN_FIXED}
    procedure RequestAlign; override;
{$ENDIF}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); {$IFDEF HAS_REINTRODUCE} reintroduce; {$ENDIF} virtual;
    destructor Destroy; override;
    property Button: TSpeedButton read FButton;
  end;

  TEditCellEditor = class(TMetaCellEditor)
  private
    FhasElipsis: boolean;
    FOnElipsisClick: TNotifyEvent;
    FElipsisCaption: string;
    function getElipsisCaption: string;
    function getOnElipsisClick: TNotifyEvent;
    procedure setElipsisCaption(const Value: string);
    procedure setOnElipsisClick(const Value: TNotifyEvent);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function InitEditor(AOwner: TComponent): TWinControl; override;
  public
    procedure StartEdit; override;
    procedure EndEdit; override;
    procedure Clear; override;
    procedure Draw(Rect: TRect); override;
  published
    property DefaultText;
    property hasElipsis: boolean read FhasElipsis write FhasElipsis;
    property OnElipsisClick: TNotifyEvent read getOnElipsisClick write setOnElipsisClick;
    property ElipsisCaption: string read getElipsisCaption write setElipsisCaption;
  end;

  TComboInplace = class(TCustomComboBox)
  private
    FCellEditor: TCellEditor;
  protected
{$IFDEF REQUESTALIGN_FIXED}
    procedure RequestAlign; override;
{$ENDIF}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); {$IFDEF HAS_REINTRODUCE} reintroduce; {$ENDIF} virtual;
  end;

  TComboCellEditor = class(TMetaCellEditor)
  private
    FStyle: TComboBoxStyle;
    FItems: TStrings;
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
    procedure SetItems(Value: TStrings);
    function GetStyle: TComboBoxStyle; virtual;
    procedure SetStyle(Value: TComboBoxStyle); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartEdit; override;
    procedure EndEdit; override;
  published
    property DefaultText;
    property Style: TComboBoxStyle read GetStyle write SetStyle default csDropDown;
    property Items: TStrings read FItems write SetItems;
  end;

  TMaskEditInplace = class(TCustomMaskEdit)
  private
    FCellEditor: TCellEditor;
  protected
{$IFDEF REQUESTALIGN_FIXED}
    procedure RequestAlign; override;
{$ENDIF}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); {$IFDEF HAS_REINTRODUCE} reintroduce; {$ENDIF} virtual;
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

  TInplaceUpDown = class(TUpDown)
  protected
{$IFDEF REQUESTALIGN_FIXED}
    procedure RequestAlign; override;
{$ENDIF}
  end;

  TUpDownInplace = class(TCustomEdit)
  private
    FCellEditor: TCellEditor;
    FUpDown: TUpDown;
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
  protected
{$IFDEF REQUESTALIGN_FIXED}
    procedure RequestAlign; override;
{$ENDIF}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); {$IFDEF HAS_REINTRODUCE} reintroduce;  {$ENDIF} virtual;
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
    property Min: Smallint read getMin write setMin default 0;
    property Max: Smallint read getMax write setMax default 10;
    property Increment: integer read getIncrement write setIncrement default 1;
  end;

  TXStringColumnItem = class(TCollectionItem)
  private
    FHeaderColor: TColor;
    FHeaderFont: TFont;
    FHeaderAlignment: TAlignment;
    FColor: TColor;
    FFont: TFont;
    FAlignment: TAlignment;
    FEditor: TCellEditor;
    procedure SetHeaderColor(Value: TColor);
    procedure SetHeaderFont(Value: TFont);
    procedure SetHeaderAlignment(Value: TAlignment);
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
    procedure Assign(Source: TPersistent); override;
    procedure ShowEditor(ARow: integer); virtual;
    property Grid: TXStringGrid read GetGrid;
  published
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor default clBtnFace;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property HeaderAlignment:TAlignment read FHeaderAlignment write SetHeaderAlignment default taLeftJustify;
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
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TXStringGrid);
    destructor Destroy; override;
    function Owner: TXStringgrid;
    property Items[Index: Integer]: TXStringColumnItem read GetItem write SetItem; default;
  end;

  TDrawEditorEvent = procedure (Sender: TObject; ACol, ARow: Longint; Editor: TCellEditor) of object;
  TCompareProc = function(Sender: TXStringGrid; SortCol, row1, row2: integer): Integer;
  TSwapProc = procedure(Sender: TXStringGrid; SortCol, row1, row2: integer);

  TXStringGrid = class(TStringgrid)
  private
    FLastChar: integer;
    FEditCol: integer;
    FEditRow: integer;
    FMultiLine: boolean;
    FCellEditor: TCellEditor;
    FColumns: TXStringColumns;
    FOnDrawEditor: TDrawEditorEvent;
    FFixedLineColor: TColor;
    FGridLineColor: TColor;
    FImmediateEditMode: boolean;
    procedure SetColumns(Value: TXStringColumns);
    procedure quickSort(col, bottom, top: integer; compare: TCompareProc; swap: TSwapProc);
    procedure SetFixedLineColor(const Value: TColor);
    procedure SetGridLineColor(const Value: TColor);
  protected
    procedure SizeChanged(OldColCount, OldRowCount: Longint); override;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    function CanEditShow: Boolean; override;
    procedure DrawEditor(ACol, ARow: integer); virtual;
    procedure TopLeftChanged; override;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DestroyWnd; override;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure HandleKey(var Key: Word; Shift: TShiftState);
    procedure sort(col: integer; compare: TCompareProc; swap: TSwapProc);
    property CellEditor: TCellEditor read FCellEditor;
    property LastChar: integer read FLastChar write FLastChar;
  published
    property Ctl3D;
    property FixedLineColor: TColor read FFixedLineColor write SetFixedLineColor;
    property GridLineColor: TColor read FGridLineColor write SetGridLineColor default clSilver;
    property Columns: TXStringColumns read FColumns write SetColumns;
    property OnDrawEditor: TDrawEditorEvent read FOnDrawEditor write FOnDrawEditor;
    property MultiLine: boolean read FMultiLine write FMultiLine;
    property ImmediateEditMode: boolean read FImmediateEditMode write FImmediateEditMode;
  end;

  function CompareProc(Sender: TXStringGrid; SortCol, row1, row2: integer): Integer;
  procedure SwapProc(Sender: TXStringGrid; SortCol, row1, row2: integer);

implementation
uses
  Forms;

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
// TXStringColumnItem
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

procedure TXStringColumnItem.SetHeaderAlignment(Value: TAlignment);
begin
  if FHeaderAlignment <> Value then begin
    FHeaderAlignment := Value;
    Grid.InvalidateCol(Index);
  end;
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

constructor TXStringColumnItem.Create(XStringColumns: TCollection);
begin
  inherited Create(XStringColumns);
  FHeaderColor := Grid.FixedColor;
  FHeaderFont := TFont.Create;
  FHeaderFont.assign(Grid.Font);
  FHeaderAlignment := taLeftJustify;
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

procedure TXStringColumnItem.Assign(Source: TPersistent);

  function FindEditor(const Container: TControl; const Editor: TCellEditor): TCellEditor;
  begin
    if (Editor = nil) or (Container = nil) then
      result := nil
    else begin
      result := TCellEditor(Container.FindComponent(Editor.Name));
      if result = nil then
        result := FindEditor(Container.Parent, Editor);
    end;
  end;

begin
  if Source is TXStringColumnItem then begin
    HeaderColor := TXStringColumnItem(Source).HeaderColor;
    HeaderFont.Assign(TXStringColumnItem(Source).HeaderFont);
    Color := TXStringColumnItem(Source).Color;
    Font.Assign(TXStringColumnItem(Source).Font);
    Alignment := TXStringColumnItem(Source).Alignment;
    HeaderAlignment := TXStringColumnItem(Source).HeaderAlignment;
    Caption := TXStringColumnItem(Source).Caption;

    // Editors cannot be shared between grids. So no assignement
    // at run time. This is called at design time when working with
    // frames. Delphi provides a unique Editor in the target frame
    // so we have to find this one for the assignment.
    if not(csDesigning in Grid.ComponentState) then
      Editor := nil
    else
      Editor := FindEditor(Grid.Parent, TXStringColumnItem(Source).Editor);

  end
  else inherited Assign(Source);
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
// TXStringColumns
//

function TXStringColumns.GetItem(Index: Integer): TXStringColumnItem;
begin
  result := TXStringColumnItem(inherited GetItem(Index));
end;

procedure TXStringColumns.SetItem(Index: Integer; Value: TXStringColumnItem);
begin
  inherited SetItem(Index, Value);
end;

function TXStringColumns.GetOwner: TPersistent;
begin
  result := FOwner;
end;

constructor TXStringColumns.Create(AOwner: TXStringgrid);
begin
  FOwner := AOwner;
  inherited Create(TXStringColumnItem);
end;

destructor TXStringColumns.Destroy;
begin
  inherited Destroy;
end;

function TXStringColumns.Owner: TXStringgrid;
begin
  result := FOwner;
end;

////////////////////////////////////////////////////////////////////////////////
// TXStringgrid
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
  i: integer;
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
    if ARow < FixedRows
      then DrawCellText(Column.HeaderAlignment)
      else DrawCellText(Column.Alignment);
    inherited DrawCell(ACol, ARow, ARect, AState);
    if gdFixed in AState then begin
      Canvas.Brush.Color := FFixedLineColor;
      for i:=1 to GridLineWidth do begin
        InflateRect(ARect,1,1);
        Canvas.FrameRect(ARect);
      end;
    end
    else begin
      Canvas.Brush.Color := FGridLineColor;
      for i:=1 to GridLineWidth do begin
        InflateRect(ARect,1,1);
        Canvas.FrameRect(ARect);
      end;
    end;
    DefaultDrawing := true;
  end
  else
    inherited DrawCell(ACol, ARow, ARect, AState);
end;

function TXStringgrid.CanEditShow: Boolean;
begin
  if inherited CanEditShow and Focused and (Row >= FixedRows) then
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

procedure TXStringGrid.WMChar(var Msg: TWMChar);
begin
  if FImmediateEditMode then begin
    if (goEditing in Options) and (char(Msg.CharCode) in [#32..#255]) then
      LastChar := Msg.CharCode
    else
      LastChar := 0;
  end;

  inherited;
end;

procedure TXStringGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  c, r: LongInt;
  s: TGridRect;
begin
  MouseToCell(X, Y, c, r);
  if (goAlwaysShowEditor in Options) and (c >= FixedCols) and (r >= FixedRows) then begin
    if FCellEditor <> nil then
      FCellEditor.EndEdit;
  end;

  if SelectCell(c, r) then begin
    if FCellEditor <> nil then
      FCellEditor.Clear;

    if (c >= FixedCols) and (r >= FixedRows) then begin
      s.left := c;
      s.Right := c;
      s.Top := r;
      s.Bottom := r;
      Selection := s;
    end;
  end;
  inherited MouseDown(Button, Shift, X, Y);

  if (FCellEditor = nil) and not (goAlwaysShowEditor in Options) then
    EditorMode := false;
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

procedure TXStringGrid.SetFixedLineColor(const Value: TColor);
begin
  FFixedLineColor := Value;
  Invalidate;
end;

procedure TXStringGrid.SetGridLineColor(const Value: TColor);
begin
  FGridLineColor := Value;
  Invalidate;
end;

constructor TXStringgrid.Create(AOwner: TComponent);
var
  c: integer;
begin
  inherited Create(AOwner);
  FGridLineColor := clSilver;
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

// This is a workaround for a VCL weirdness which I don't really understand.
// It seems that TCustomGrid.WMCommand forgets to call inherited (bug?)
// because the events checkbox doesn't work as expected. However, fixing
// this 'bug' causes the button not to work as expected.
// Therefore I'm 'fixing' this for the checkbox only, so everything hopefully works
// as expected.
{ TODO : Test (D6 ok) }
procedure TXStringGrid.WMCommand(var Message: TWMCommand);
var
  Control: TWinControl;
begin
  Control := FindControl(Message.Ctl);
  if Control is TCheckBox then
    with TMessage(Message) do
      Result := Control.Perform(Msg + CN_BASE, WParam, LParam)

  else
    inherited;
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
// TMetaCellEditor
//

procedure TMetaCellEditor.loaded;
begin
  inherited loaded;
  Init;
end;

destructor TMetaCellEditor.Destroy;
begin
  FEditor.free;            // FEdit propably set to nil by notification
  inherited Destroy;       // method. So FEdit has been freed already
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

procedure TMetaCellEditor.Attatch(AGrid: TXStringGrid);
begin
  inherited Attatch(AGrid);
  if not (csDesigning in ComponentState) and (FEditor <> nil) and (Grid <> nil) then
    windows.SetParent(FEditor.Handle, Grid.Handle);
end;

procedure TMetaCellEditor.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
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
// TInplaceSpeedButton
//

{$IFDEF REQUESTALIGN_FIXED}
procedure TInplaceSpeedButton.RequestAlign;
begin
// Empty. Don't call inherited this disallows alignment
end;
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// TEditInplace
//

{$IFDEF REQUESTALIGN_FIXED}
procedure TEditInplace.RequestAlign;
begin
// Empty. Don't call inherited this disallows alignment
end;
{$ENDIF}

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
  if FCellEditor.grid <> nil then begin
    if FButton <> nil then
      FButton.Parent := FCellEditor.FGrid;
    windows.SetParent(Handle, FCellEditor.grid.Handle);
  end;
end;

constructor TEditInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FCellEditor := CellEditor;
  if TEditCellEditor(FCellEditor).FhasElipsis then begin
    FButton := TInplaceSpeedButton.Create(AOwner);
    with FButton do begin
      visible := false;
      TabStop := false;
      OnClick := TEditCellEditor(FCellEditor).FOnElipsisClick;
      Caption := TEditCellEditor(FCellEditor).FElipsisCaption;
    end;
  end;
  visible := false;
  Ctl3d := false;
  BorderStyle := bsNone;
  ParentCtl3D := False;
  TabStop := False;
end;

destructor TEditInplace.Destroy;
begin
  FButton.free;
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// TEditCellEditor
//

procedure TEditCellEditor.Draw(Rect: TRect);
var
  R: TRect;
begin
  if FEditor = nil then
    exit;

  if FhasElipsis then
    Rect.Right := Rect.Right - Rect.Bottom + Rect.Top;

  inherited Draw(Rect);
  with FEditor do begin
    R := Classes.Rect(2, 2, Width - 2, Height);
    SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  end;

  if FhasElipsis then
    with TEditInplace(FEditor) do begin
      Button.left := Rect.right;
      Button.top := Rect.Top;
      Button.height := Rect.bottom - Rect.Top;
      Button.width := Rect.bottom - Rect.Top;
      Button.visible := true;
    end;
end;

procedure TEditCellEditor.Clear;
begin
  inherited Clear;
  if FhasElipsis then
    TEditInplace(FEditor).Button.visible := false;
end;

function TEditCellEditor.getElipsisCaption: string;
begin
  if FEditor = nil then
    result := FElipsisCaption
  else
    result := TEditInplace(FEditor).Button.Caption;
end;

procedure TEditCellEditor.setElipsisCaption(const Value: string);
begin
  if FEditor = nil then
    FElipsisCaption := Value
  else
    TEditInplace(FEditor).Button.Caption := Value;
end;

function TEditCellEditor.getOnElipsisClick: TNotifyEvent;
begin
  if FEditor = nil then
    result := FOnElipsisClick
  else
    result := TEditInplace(FEditor).Button.OnClick;
end;

procedure TEditCellEditor.setOnElipsisClick(const Value: TNotifyEvent);
begin
  if FEditor = nil then
    FOnElipsisClick := Value
  else
    TEditInplace(FEditor).Button.OnClick := Value;
end;

procedure TEditCellEditor.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation <> opRemove) or (FEditor = nil) then
    exit;

  if AComponent = TEditInplace(FEditor).Button then
    TEditInplace(FEditor).FButton := nil;
end;

function TEditCellEditor.InitEditor(AOwner: TComponent): TWinControl;
var
  Inplace: TEditInplace;
begin
  Inplace := TEditInplace.Create(AOwner, self);
  result := Inplace;

  if FhasElipsis then
    try
      if Inplace = nil then
        raise ECellEditorError.Create(StrCellEditorError);
       Inplace.FreeNotification(self);  // Notify me if FButton gets freed by someone
      (AOwner as TWinControl).InsertControl(Inplace.Button);
    except
      raise ECellEditorError.Create(StrCellEditorError);
    end;
end;

procedure TEditCellEditor.StartEdit;
var
  s: string;
begin
  if (FEditor = nil) or (Grid = nil) then
    init;

  with FEditor as TEditInplace do begin
    if Grid.LastChar <> 0 then begin
      Text := char(Grid.LastChar);
      Grid.LastChar := 0;
      SelStart := 1;
      SelLength := 0;
    end
    else begin
      s := Grid.GetEditText(Grid.Col, Grid.Row);
      if s = '' then
        Text := FDefaultText
      else
        Text := s;

      SelStart := 0;
      SelLength := -1;
    end;
  end;
end;

procedure TEditCellEditor.EndEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  SetCellText((FEditor as TEditInplace).Text);
end;

////////////////////////////////////////////////////////////////////////////////
// TComboInplace
//

{$IFDEF REQUESTALIGN_FIXED}
procedure TComboInplace.RequestAlign;
begin
// Empty. Don't call inherited this disallows alignment
end;
{$ENDIF}

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

constructor TComboInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FCellEditor := CellEditor;
  Visible := false;
  Ctl3d := false;
  ParentCtl3D := False;
  TabStop := False;
end;

////////////////////////////////////////////////////////////////////////////////
// TComboCellEditor
//

constructor TComboCellEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
end;

destructor TComboCellEditor.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TComboCellEditor.StartEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    init;

  with FEditor as TComboInplace do begin
    Items.Assign(FItems);
    if Grid.LastChar <> 0 then begin
      PostMessage(Handle, WM_KEYDOWN, integer(upcase(char(Grid.LastChar))), 0);
      Grid.LastChar := 0;
    end
    else begin
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

procedure TComboCellEditor.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
  if FEditor <> nil
    then TComboInplace(FEditor).Items.Assign(Value);
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
// TMaskEditInplace
//

{$IFDEF REQUESTALIGN_FIXED}
procedure TMaskEditInplace.RequestAlign;
begin
// Empty. Don't call inherited this disallows alignment
end;
{$ENDIF}

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
// TMaskEditCellEditor
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
    init;

  with FEditor as TMaskEditInplace do begin
    if Grid.LastChar <> 0 then begin
      Text := char(Grid.LastChar);
      Grid.LastChar := 0;
    end
    else begin
      s := Grid.GetEditText(Grid.Col, Grid.Row);
      if s = '' then
        Text := FDefaultText
      else
        Text := s;
    end;
  end;
end;

procedure TMaskEditCellEditor.EndEdit;
begin
  if (FEditor = nil) or (Grid = nil) then
    exit;

  SetCellText((FEditor as TMaskEditInplace).Text);
end;

////////////////////////////////////////////////////////////////////////////////
// TInplaceUpDown
//

{$IFDEF REQUESTALIGN_FIXED}
procedure TInplaceUpDown.RequestAlign;
begin
// Empty. Don't call inherited this disallows alignment
end;
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// TUpDownInplace
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

{$IFDEF REQUESTALIGN_FIXED}
procedure TUpDownInplace.RequestAlign;
begin
// Empty. Don't call inherited this disallows alignment
end;
{$ENDIF}

procedure TUpDownInplace.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
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

constructor TUpDownInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  FUpDown := TInplaceUpDown.Create(AOwner);
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
// TUpDownCellEditor
//

constructor TUpDownCellEditor.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FIncrement := 1;
  FMax := 10;
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
    init;

  with FEditor as TUpDownInplace do begin
    if Grid.LastChar <> 0 then begin
      Text := char(Grid.LastChar);
      Grid.LastChar := 0;
      SelStart := 1;
      SelLength := 0;
    end
    else begin
      Text := Grid.GetEditText(Grid.Col, Grid.Row);
      if Text = '' then
        Text := FDefaultText;

      SelStart := 0;
      SelLength := -1;
    end;
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

