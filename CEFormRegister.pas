{
  ------------------------------------------------------------------------------
    Filename: CEFormRegister.pas
    Version:  v1.0
    Authors:  Michael D�rig (md)
    Purpose:  Design time suppor for CEForm
    Remark:   Needs TXStringGrid v1.2
  ------------------------------------------------------------------------------
    (C) 1999  M. D�rig
              CH-4056 Basel
              mduerig@eye.ch / www.eye.ch/~mduerig
  ------------------------------------------------------------------------------
    History:  12.08.99md  v1.0 Creation
  ------------------------------------------------------------------------------
}
unit CEFormRegister;

interface
uses classes, dsgnintf, Exptintf;

type
  TFormClassEditorProperty = class(TStringProperty)
  private
    cbEnumForm: TGetStrProc;
  protected
    procedure GetValues(Proc: TGetStrProc); override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  procedure Register;

implementation
uses CEForm;

procedure Register;
begin
  RegisterComponents('XStringGrid', [TFormCellEditor]);
  RegisterPropertyEditor(TypeInfo(TFormInplaceName), TFormCellEditor, '', TFormClassEditorProperty);
end;

function TFormClassEditorProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList];
end;

function cbEnumProjectUnits(Param: Pointer; const FileName, UnitName, FormName: string): Boolean stdcall;
begin
  if FormName <> '' then
    TFormClassEditorProperty(Param).cbEnumForm('T' + FormName);

  result := true;
end;

procedure TFormClassEditorProperty.GetValues(Proc: TGetStrProc);
begin
  cbEnumForm := Proc;
  ToolServices.EnumProjectUnits(cbEnumProjectUnits, self);
end;


end.