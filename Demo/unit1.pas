{
  ----------------------------------------------------------------------------
    Filename: Unit1.pas
    Version:  v1.0
    Authors:  Michael Dürig (md)
    Purpose:  Simple demo for the XStringGrid component.
  ----------------------------------------------------------------------------
    (C) 1997  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / http://www.eye.ch/~mduerig
  ----------------------------------------------------------------------------
    History:  13.10.97md  v1.0 Release v1.0
              12.08.99md  v2.0 Release v2.0
              16.08.01md  v2.5 Release 2.5
  ----------------------------------------------------------------------------
}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  XStringGrid, Grids, StdCtrls, Menus, CEForm, CECheckList, CEButton,
  ExtCtrls, Buttons, CECheckbox;

type
  TDemoForm = class(TForm)
    xg: TXStringGrid;
    UpDownCellEditor1: TUpDownCellEditor;
    ComboCellEditor1: TComboCellEditor;
    EditCellEditor1: TEditCellEditor;
    PopupMenu: TPopupMenu;
    miLeftAlign: TMenuItem;
    miRightAlign: TMenuItem;
    miCenter: TMenuItem;
    N1: TMenuItem;
    miColor: TMenuItem;
    miFont: TMenuItem;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    Label2: TLabel;
    CheckListCellEditor1: TCheckListCellEditor;
    FormCellEditor1: TFormCellEditor;
    ButtonCellEditor1: TButtonCellEditor;
    FormCellEditor2: TFormCellEditor;
    cbSortWholeRows: TCheckBox;
    cbSortDesc: TCheckBox;
    Label1: TLabel;
    CheckBoxCellEditor1: TCheckBoxCellEditor;
    procedure FormCreate(Sender: TObject);
    procedure miLeftAlignClick(Sender: TObject);
    procedure miRightAlignClick(Sender: TObject);
    procedure miCenterClick(Sender: TObject);
    procedure miColorClick(Sender: TObject);
    procedure miFontClick(Sender: TObject);
    procedure xgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonCellEditor1Click(Sender: TObject);
    procedure CheckListCellEditor1SetChecks(Sender: TCheckListCellEditor);
    procedure CheckListCellEditor1SetText(Sender: TCheckListCellEditor;
      var Value: String);
    procedure FormCellEditor1EndEdit(Sender: TObject);
    procedure FormCellEditor2EndEdit(Sender: TObject);
    procedure FormCellEditor2StartEdit(Sender: TObject);
    procedure xgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditCellEditor1ElipsisClick(Sender: TObject);
    procedure CheckBoxCellEditor1SetState(Sender: TCheckBoxCellEditor);
    procedure CheckBoxCellEditor1SetText(Sender: TCheckBoxCellEditor;
      var Value: String);
  private
    CurrentRow: Longint;
    CurrentCol: Longint;
  end;

var
  DemoForm: TDemoForm;

implementation

uses Unit2, Unit3;
{$R *.DFM}

function DescSortCompareProc(Sender: TXStringGrid; SortCol, row1, row2: integer): Integer;
begin
  result := - CompareProc(Sender, SortCol, row1, row2);
end;

procedure WholeRowSwapProc(Sender: TXStringGrid; SortCol, row1, row2: integer);
var
  r: TStringList;
begin
  r := TStringList.Create;
  try
    with Sender do begin
      r.Assign(Rows[row1]);
      Rows[row1].Assign(Rows[row2]);
      Rows[row2].Assign(r);
    end;
  finally
    r.free;
  end;
end;

procedure TDemoForm.xgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  xg.MouseToCell(X, Y, CurrentCol, CurrentRow);
end;

procedure TDemoForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  ComboCellEditor1.Items.Add('Betty Boo');
  ComboCellEditor1.Items.Add('John Zorn');
  ComboCellEditor1.Items.Add('Frank Zappa');
  ComboCellEditor1.Items.Add('Jonny Cash');
  CheckListCellEditor1.Items.add('A');
  CheckListCellEditor1.Items.add('B');
  CheckListCellEditor1.Items.add('C');
  CheckListCellEditor1.Items.add('D');

  for i := 1 to xg.RowCount - 1 do
    xg.Cells[1, i] := format('%2d', [xg.RowCount - i]);
end;

procedure TDemoForm.miLeftAlignClick(Sender: TObject);
begin
  xg.Columns[CurrentCol].Alignment := taLeftJustify;
end;

procedure TDemoForm.miRightAlignClick(Sender: TObject);
begin
  xg.Columns[CurrentCol].Alignment := taRightJustify;
end;

procedure TDemoForm.miCenterClick(Sender: TObject);
begin
  xg.Columns[CurrentCol].Alignment := taCenter;
end;

procedure TDemoForm.miColorClick(Sender: TObject);
begin
  ColorDialog.Color := xg.Columns[CurrentCol].Color;
  if ColorDialog.Execute then
    xg.Columns[CurrentCol].Color := ColorDialog.Color;
end;

procedure TDemoForm.miFontClick(Sender: TObject);
begin
  FontDialog.Font := xg.Columns[CurrentCol].Font;
  if FontDialog.Execute then
    xg.Columns[CurrentCol].Font := FontDialog.Font;
end;

procedure TDemoForm.ButtonCellEditor1Click(Sender: TObject);
var
  s: string;
begin
  with xg do begin
    s := Cells[Col, Row];
    if s = '' then
      s := 'Where are you baby?';
    if InputQuery('XString Grid Demo', 'More: ', s) then
      Cells[Col, Row] := s;
  end;
end;

procedure TDemoForm.CheckListCellEditor1SetChecks(
  Sender: TCheckListCellEditor);
var
  i: integer;
begin
  with xg do
    for i := 0 to Sender.Items.count - 1 do
      if Pos(Sender.Items[i], Cells[Col, Row]) > 0 then
        Sender.checked[i] := true
      else
        Sender.checked[i] := false;
end;

procedure TDemoForm.CheckListCellEditor1SetText(
  Sender: TCheckListCellEditor; var Value: String);
var
  i: integer;
begin
  Value := '';
  with xg do
    for i := 0 to CheckListCellEditor1.Items.count - 1 do
      if Sender.checked[i] then
        Value := Value + Sender.Items[i] + ' ';
end;

procedure TDemoForm.FormCellEditor1EndEdit(Sender: TObject);
begin
  with TCustomCellEditor(FormCellEditor1.Editor) do
    if ListView1.Selected <> nil then
      xg.Cells[xg.Col, xg.Row] := ListView1.Selected.Caption;
end;

procedure TDemoForm.FormCellEditor2EndEdit(Sender: TObject);
begin
  with TDateCellEditor((Sender as TFormCellEditor).Editor) do begin
    xg.Cells[xg.Col, xg.Row] := datetostr(DateTimePicker1.date);
  end;
end;

procedure TDemoForm.FormCellEditor2StartEdit(Sender: TObject);
var
  d: TDate;
begin
  try
    d := StrToDate(xg.Cells[xg.Col, xg.Row]);
  except
    d := now;
  end;

  with TDateCellEditor((Sender as TFormCellEditor).Editor) do begin
    DateTimePicker1.Date := d;
  end;
end;

procedure TDemoForm.xgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  c: TCompareProc;
  s: TSwapProc;
begin
  s := nil;
  c := nil;
  if (CurrentRow < xg.FixedRows) and (CurrentCol >= xg.FixedCols) then begin
    if cbSortWholeRows.Checked then
      s := WholeRowSwapProc;

    if cbSortDesc.Checked then
      c := DescSortCompareProc;

    xg.sort(CurrentCol, c, s);
  end;
end;

procedure TDemoForm.EditCellEditor1ElipsisClick(Sender: TObject);
var
  s: string;
begin
  with xg do begin
    s := EditCellEditor1.Editor.Text;
    if InputQuery('XString Grid Demo', 'More: ', s) then
      EditCellEditor1.Editor.Text := s;
  end;
end;

procedure TDemoForm.CheckBoxCellEditor1SetState(
  Sender: TCheckBoxCellEditor);
begin
  if xg.Cells[xg.Col, xg.Row] = 'X' then
    Sender.State := cbChecked
  else
    Sender.State := cbUnchecked;
end;

procedure TDemoForm.CheckBoxCellEditor1SetText(Sender: TCheckBoxCellEditor;
  var Value: String);
begin
  if Sender.State = cbChecked then
    Value := 'X'
  else
    Value := '';
end;

end.
