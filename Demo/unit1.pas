{
  ----------------------------------------------------------------------------
    Filename: Unit1.pas
    Version:  v1.0
    Authors:  Michael Dürig (md)
    Purpose:  Simple demo for the XStringGrid component.
  ----------------------------------------------------------------------------
    (C) 1997  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / www.eye.ch/~mduerig
  ----------------------------------------------------------------------------
    History:  13.10.97md  v1.0 Release v1.0
  ----------------------------------------------------------------------------
}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  XStringGrid, Grids, StdCtrls, Menus;

type
  TDemoForm = class(TForm)
    xg: TXStringGrid;
    UpDownCellEditor1: TUpDownCellEditor;
    ComboCellEditor1: TComboCellEditor;
    EditCellEditor1: TEditCellEditor;
    MaskEditCellEditor1: TMaskEditCellEditor;
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
    procedure FormCreate(Sender: TObject);
    procedure miLeftAlignClick(Sender: TObject);
    procedure miRightAlignClick(Sender: TObject);
    procedure miCenterClick(Sender: TObject);
    procedure miColorClick(Sender: TObject);
    procedure miFontClick(Sender: TObject);
    procedure xgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    CurrentRow: Longint;
    CurrentCol: Longint;
  end;

var
  DemoForm: TDemoForm;

implementation

{$R *.DFM}

procedure TDemoForm.xgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  xg.MouseToCell(X, Y, CurrentCol, CurrentRow);
end;

procedure TDemoForm.FormCreate(Sender: TObject);
begin
  ComboCellEditor1.Items.Add('Betty Boo');
  ComboCellEditor1.Items.Add('John Zorn');
  ComboCellEditor1.Items.Add('Frank Zappa');
  ComboCellEditor1.Items.Add('Jonny Cash');
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

end.
