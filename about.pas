{
  ----------------------------------------------------------------------------
    Filename: about.pas
    Version:  v1.0
    Authors:  Michael Dürig (md)
    Purpose:  Aboutbox no mas...
  ----------------------------------------------------------------------------
    (C) 1997  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / www.eye.ch/~mduerig
  ----------------------------------------------------------------------------
    History:  11.3.97md   v1.0 Release v1.0
              12.08.99md  v2.0 Release v2.0
  ----------------------------------------------------------------------------
}

unit about;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    LabelMailto: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    ProgramIcon: TImage;
    Memo: TMemo;
    LabelWWW: TLabel;
    procedure LabelWWWClick(Sender: TObject);
    procedure LabelMailtoClick(Sender: TObject);
  end;

implementation
uses
  shellapi;

{$R *.DFM}

procedure TAboutBox.LabelWWWClick(Sender: TObject);
var
  s: string;
begin
  s := LabelWWW.Caption;
  ShellExecute(0, 'open', pChar(s), nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutBox.LabelMailtoClick(Sender: TObject);
var
  s: string;
begin
  s := 'mailto:' + LabelMailto.Caption;
  ShellExecute(0, 'open', pChar(s), nil, nil, SW_SHOWNORMAL);
end;

end.

