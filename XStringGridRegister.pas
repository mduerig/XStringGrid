{
  ----------------------------------------------------------------------------
    Filename: XStringGridRegister.pas
    Version:  v1.1
    Authors:  Michael Dürig (md)
    Purpose:  The design time part of the XStringGrid component implemnts the
              register procedure and the property editors.
  ----------------------------------------------------------------------------
    (C) 1997  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / http://www.eye.ch/~mduerig
  ----------------------------------------------------------------------------
    History:  11.03.97md  v1.0 Release v1.0
              14.09.97md  v1.1 Added Component Editor
              07.08.98md  v1.1 Little patch for D4
              12.08.99md  v2.0 Release v2.0
              03.10.99md  v2.0 Components go to separate Palette
              26.11.2k md v2.1 Included new features from Marcus Wirth
  ----------------------------------------------------------------------------
}

{$I VERSIONS.INC}
unit XStringGridRegister;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  XStringGrid, StdCtrls, ComCtrls, colorcombo, Grids, DBGrids,
{$IFNDEF DSGNINTF_GONE}
  DsgnIntf;
{$ELSE}
  DesignEditors, DesignIntf;
{$ENDIF}

type
{$IFDEF NOIFORMDESIGNER}
  IFormDesigner = TFormDesigner;
{$ENDIF}

{$IFDEF IFORMDESIGNER_MOVED}
  IFormDesigner = DesignIntf.IDesigner;
{$ENDIF}

  TXStringColumnsProperty = class(TClassProperty)
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TXStringColumnsEditor = class(TDefaultEditor)
  protected
{$IFDEF EDITPROPERTY_CHANGED}
    procedure EditProperty(const PropertyEditor: IProperty;     
      var Continue: Boolean); override;
{$ELSE}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
{$ENDIF}
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

type
  TDlgProps = class(TForm)
    BtnClose: TButton;
    DlgFont: TFontDialog;
    GroupBox1: TGroupBox;
    LBColumns: TListBox;
    GroupBox2: TGroupBox;
    TBWidth: TTrackBar;
    LabelWidth: TLabel;
    Label1: TLabel;
    btnAbout: TButton;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    EditHeader: TEdit;
    Label7: TLabel;
    CBHdrAlignment: TComboBox;
    BtnHdrFont: TButton;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    CBAlignment: TComboBox;
    Label4: TLabel;
    CBColor: TColorCombo;
    Label3: TLabel;
    CBHdrColor: TColorCombo;
    BtnFont: TButton;
    Label5: TLabel;
    CBEditor: TComboBox;
    procedure LBColumnsClick(Sender: TObject);
    procedure TBWidthChange(Sender: TObject);
    procedure EditHeaderExit(Sender: TObject);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnHdrFontClick(Sender: TObject);
    procedure CBColorChange(Sender: TObject);
    procedure CBHdrColorChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBEditorChange(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure CBAlignmentChange(Sender: TObject);
    procedure CBHdrAlignmentChange(Sender: TObject);
  private
    FColumns: TXStringColumns;
    FDesigner: IFormDesigner;
    procedure AddEditorClass(const S: string);
    procedure SetColumns(Value: TXStringColumns);
    function GetColCaption: TCaption;
    procedure SetColCaption(Value: TCaption);
    function GetAlignment: TAlignment;
    procedure SetAlignment(Value: TAlignment);
    function GetHdrAlignment: TAlignment;
    procedure SetHdrAlignment(Value: TAlignment);
    function GetColWidth: integer;
    procedure SetColWidth(Value: integer);
    function GetColColor: TColor;
    procedure SetColColor(Value: TColor);
    function GetColHdrColor: TColor;
    procedure SetColHdrColor(Value: TColor);
    function GetColFont: TFont;
    procedure SetColFont(Value: TFont);
    function GetColHdrFont: TFont;
    procedure SetColHdrFont(Value: TFont);
    function GetCellEditor: TCellEditor;
    procedure SetCellEditor(Value: TCellEditor);
    property ColCaption: TCaption read GetColCaption write SetColCaption;
    property Aligmnent: TAlignment read GetAlignment write SetAlignment;
    property HdrAlignment: TAlignment read GetHdrAlignment write SetHdrAlignment;
    property ColWidth: integer read GetColWidth write SetColWidth;
    property ColColor: TColor read GetColColor write SetColColor;
    property ColHdrColor: TColor read GetColHdrColor write SetColHdrColor;
    property ColFont: TFont read GetColFont write SetColFont;
    property ColHdrFont: TFont read GetColHdrFont write SetColHdrFont;
    property CellEditor: TCellEditor read GetCellEditor write SetCellEditor;
  public
    constructor Create(AOwner: TComponent; Designer: IFormDesigner); {$IFDEF HAS_REINTRODUCE} reintroduce; {$ENDIF} 
    property Columns: TXStringColumns read FColumns write SetColumns;
  end;

procedure Register;
procedure EditColumns(Cols: TXStringColumns; Designer: IFormDesigner);

implementation

uses
  TypInfo, about;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
// public Globals
//

procedure Register;
begin
  RegisterComponents('XStringGrid', [TXStringgrid, TComboCellEditor,
    TEditCellEditor, TMaskEditCellEditor, TUpDownCellEditor]);
  RegisterPropertyEditor(TypeInfo(TXStringColumns), TXStringGrid, '', TXStringColumnsProperty);
  RegisterComponentEditor(TXStringGrid, TXStringColumnsEditor);
end;

procedure EditColumns(Cols: TXStringColumns; Designer: IFormDesigner);
begin
  with TDlgProps.Create(Application, Designer) do
    try
      Columns := Cols;
      ShowModal;
    finally
      Free;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
// TXStringColumnsProperty
//

procedure TXStringColumnsProperty.Edit;
begin
  EditColumns(TXStringColumns(GetOrdValue), Designer);
  Modified;
end;

function TXStringColumnsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog, paReadOnly] - [paSubProperties];
end;

////////////////////////////////////////////////////////////////////////////////
// TXStringColumnsEditor
//

{$IFDEF EDITPROPERTY_CHANGED}
procedure TXStringColumnsEditor.EditProperty(const PropertyEditor: IProperty;
  var Continue: Boolean);
{$ELSE}
procedure TXStringColumnsEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
{$ENDIF}
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'COLUMNS') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;

function TXStringColumnsEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TXStringColumnsEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Colu&mns...'
  else Result := '';
end;

procedure TXStringColumnsEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;

////////////////////////////////////////////////////////////////////////////////
// private TDlgProps
//

constructor TDlgProps.Create(AOwner: TComponent; Designer: IFormDesigner);
begin
  FDesigner := Designer;
  inherited Create(AOwner);
end;

procedure TDlgProps.AddEditorClass(const S: string);
begin
  CBEditor.items.add(s);
end;

procedure TDlgProps.SetColumns(Value: TXStringColumns);
var
  c: integer;
begin
  FColumns := Value;
  with LBColumns.Items do begin
    clear;
    for c := 0 to FColumns.count - 1 do
      AddObject(IntToStr(c) + ': ' + FColumns[c].Caption, FColumns[c]);
  end;
  LBColumns.ItemIndex := 0;
  LBColumns.OnClick(self);
end;

function TDlgProps.GetColCaption: TCaption;
begin
  result := '';
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).Caption;
end;

procedure TDlgProps.SetColCaption(Value: TCaption);
var
  i: integer;
begin
  with LBColumns do begin
    i := ItemIndex;
    if  i >= 0 then begin
      TXStringColumnItem(items.objects[ItemIndex]).Caption := Value;
      items[ItemIndex] := IntToStr(ItemIndex) + ': ' + Value;
      ItemIndex := i;
    end;
  end;
end;

function TDlgProps.GetAlignment: TAlignment;
begin
  result := taLeftJustify;
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).Alignment;
end;

procedure TDlgProps.SetAlignment(Value: TAlignment);
begin
  with LBColumns do
    if ItemIndex >= 0 then
      TXStringColumnItem(items.objects[ItemIndex]).Alignment := Value;
end;

function TDlgProps.GetHdrAlignment: TAlignment;
begin
  result := taLeftJustify;
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).HeaderAlignment;
end;

procedure TDlgProps.SetHdrAlignment(Value: TAlignment);
begin
  with LBColumns do
    if ItemIndex >= 0 then
      TXStringColumnItem(items.objects[ItemIndex]).HeaderAlignment := Value;
end;

function TDlgProps.GetColWidth: integer;
begin
  result := 0;
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).Width;
end;

procedure TDlgProps.SetColWidth(Value: integer);
begin
  with LBColumns do
    if ItemIndex >= 0 then
      TXStringColumnItem(items.objects[ItemIndex]).Width := Value;
end;

function TDlgProps.GetColColor: TColor;
begin
  result := clWindow;
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).Color;
end;

procedure TDlgProps.SetColColor(Value: TColor);
begin
  with LBColumns do
    if ItemIndex >= 0 then
      TXStringColumnItem(items.objects[ItemIndex]).Color := Value;
end;

function TDlgProps.GetColHdrColor: TColor;
begin
  result := clBtnFace;
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).HeaderColor;
end;

procedure TDlgProps.SetColHdrColor(Value: TColor);
begin
  with LBColumns do
    if ItemIndex >= 0 then
      TXStringColumnItem(items.objects[ItemIndex]).HeaderColor := Value;
end;

function TDlgProps.GetColFont: TFont;
begin
  result := nil;
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).Font;
end;

procedure TDlgProps.SetColFont(Value: TFont);
begin
  with LBColumns do
    if ItemIndex >= 0 then
      TXStringColumnItem(items.objects[ItemIndex]).Font := Value;
end;

function TDlgProps.GetColHdrFont: TFont;
begin
  result := nil;
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).HeaderFont;
end;

procedure TDlgProps.SetColHdrFont(Value: TFont);
begin
  with LBColumns do
    if ItemIndex >= 0 then
      TXStringColumnItem(items.objects[ItemIndex]).HeaderFont := Value;
end;

function TDlgProps.GetCellEditor: TCellEditor;
begin
  result := nil;
  with LBColumns do
    if ItemIndex >= 0 then
      result := TXStringColumnItem(items.objects[ItemIndex]).Editor;
end;

procedure TDlgProps.SetCellEditor(Value: TCellEditor);
begin
  with LBColumns do
    if ItemIndex >= 0 then
      TXStringColumnItem(items.objects[ItemIndex]).Editor := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// EventHandler TDlgProps
//

procedure TDlgProps.LBColumnsClick(Sender: TObject);
begin
  EditHeader.text := ColCaption;
  TBWidth.Max := trunc(1.02 * (ColWidth)) + 100;
  TBWidth.position := ColWidth;
  LabelWidth.Caption := IntToStr(ColWidth);
  case Aligmnent of
    taLeftJustify:   CBAlignment.ItemIndex := 0;
    taCenter:        CBAlignment.ItemIndex := 1;
    taRightJustify:  CBAlignment.ItemIndex := 2;
  end;
  case HdrAlignment of
    taLeftJustify:   CBHdrAlignment.ItemIndex := 0;
    taCenter:        CBHdrAlignment.ItemIndex := 1;
    taRightJustify:  CBHdrAlignment.ItemIndex := 2;
  end;
  CBColor.Selection := ColColor;
  CBHdrColor.Selection := ColHdrColor;
  BtnFont.Font := ColFont;
  BtnHdrFont.Font := ColHdrFont;
  if CellEditor = nil then
      CBEditor.ItemIndex := -1
  else
    try
      if CellEditor is TCellEditor then
        CBEditor.ItemIndex := CBEditor.Items.IndexOf(CellEditor.Name);
    except
      CBEditor.ItemIndex := -1;
      CellEditor := nil;
    end;
end;

procedure TDlgProps.EditHeaderExit(Sender: TObject);
begin
  ColCaption := EditHeader.text;
end;

procedure TDlgProps.TBWidthChange(Sender: TObject);
begin
  ColWidth := TBWidth.position;
    TBWidth.Max := trunc(1.02 * (TBWidth.position)) + 100;
  LabelWidth.Caption := IntToStr(ColWidth);
end;

procedure TDlgProps.BtnFontClick(Sender: TObject);
begin
  if LBColumns.ItemIndex < 0 then
    exit;

  with DlgFont do begin
    Font := ColFont;
    if Execute then
      ColFont := Font;
  end;
  BtnFont.Font := ColFont;
end;

procedure TDlgProps.BtnHdrFontClick(Sender: TObject);
begin
  if LBColumns.ItemIndex < 0 then
    exit;

  with DlgFont do begin
    Font := ColHdrFont;
    if Execute then
      ColHdrFont := Font;
  end;
  BtnHdrFont.Font := ColHdrFont;
end;

procedure TDlgProps.CBColorChange(Sender: TObject);
begin
  ColColor := CBColor.Selection;
end;

procedure TDlgProps.CBHdrColorChange(Sender: TObject);
begin
  ColHdrColor := CBHdrColor.Selection;
end;

procedure TDlgProps.FormCreate(Sender: TObject);
begin
  CBEditor.items.clear;

  if FDesigner <> nil then
    FDesigner.GetComponentNames(GetTypeData(TypeInfo(TCellEditor)), AddEditorClass);
end;

procedure TDlgProps.CBEditorChange(Sender: TObject);
begin
  try
    CellEditor := FDesigner.GetComponent(CBEditor.Text) as TCellEditor;
  except
    CellEditor := nil;
    CBEditor.ItemIndex := -1;
    raise;
  end;
end;

procedure TDlgProps.btnAboutClick(Sender: TObject);
begin
  with TAboutBox.Create(self) do begin
    try
      ShowModal;
    finally
      Destroy;
    end;
  end;
end;

procedure TDlgProps.CBAlignmentChange(Sender: TObject);
begin
  case CBAlignment.ItemIndex of
    0:  Aligmnent := taLeftJustify;
    1:  Aligmnent := taCenter;
    2:  Aligmnent := taRightJustify;
  end;
end;

procedure TDlgProps.CBHdrAlignmentChange(Sender: TObject);
begin
  case CBHdrAlignment.ItemIndex of
    0:  HdrAlignment := taLeftJustify;
    1:  HdrAlignment := taCenter;
    2:  HdrAlignment := taRightJustify;
  end;
end;

end.
