program demo;

uses
  Forms,
  unit1 in 'unit1.pas' {DemoForm},
  Unit2 in 'Unit2.pas' {CustomCellEditor},
  Unit3 in 'Unit3.pas' {DateCellEditor};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.
