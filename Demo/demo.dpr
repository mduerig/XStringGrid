program demo;

uses
  Forms,
  unit1 in 'unit1.pas' {DemoForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.
