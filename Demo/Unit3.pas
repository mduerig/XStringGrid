unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CEForm, ComCtrls;

type
  TDateCellEditor = class(TFormInplace)
    DateTimePicker1: TDateTimePicker;
    procedure FormResize(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TDateCellEditor.FormResize(Sender: TObject);
begin
  DateTimePicker1.Height := ClientHeight;
  DateTimePicker1.Width := ClientWidth;
end;

initialization
  RegisterClass(TDateCellEditor);

end.
 