unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CEForm,
  ComCtrls, StdCtrls, ToolWin;

type
  TCustomCellEditor = class(TFormInplace)
    ImageList1: TImageList;
    ListView1: TListView;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList2: TImageList;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
  end;

implementation
{$R *.DFM}

procedure TCustomCellEditor.ToolButton1Click(Sender: TObject);
begin
  ListView1.ViewStyle := vsIcon;
end;

procedure TCustomCellEditor.ToolButton2Click(Sender: TObject);
begin
  ListView1.ViewStyle := vsList;
end;

procedure TCustomCellEditor.ToolButton3Click(Sender: TObject);
begin
  ListView1.ViewStyle := vsSmallIcon;
end;

procedure TCustomCellEditor.ToolButton5Click(Sender: TObject);
begin
  close;
end;

initialization
  RegisterClass(TCustomCellEditor);
end.
 