{
  ----------------------------------------------------------------------------
    Filename: about.pas
    Version:  v1.0
    Authors:  Michael D�rig (md)
    Purpose:  Aboutbox no mas...
  ----------------------------------------------------------------------------
    (C) 1997  M. D�rig
              CH-4056 Basel
              mduerig@eye.ch / www.eye.ch/~mduerig
  ----------------------------------------------------------------------------
    History:  11.3.97md  Release v1.0
  ----------------------------------------------------------------------------
}

unit about;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    ProgramIcon: TImage;
    Memo: TMemo;
  end;

implementation

{$R *.DFM}

end.
 
