{
  ------------------------------------------------------------------------------
    Filename: CEFormRegister.pas
    Version:  v1.0
    Authors:  Michael Dürig (md)
    Purpose:  Design time suppor for CEForm
    Remark:   Needs TXStringGrid v1.2
  ------------------------------------------------------------------------------
    (C) 1999  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / http://www.eye.ch/~mduerig
  ------------------------------------------------------------------------------
    History:  12.08.99md  v1.0 Creation
  ------------------------------------------------------------------------------
}

{$I VERSIONS.INC}
unit CEFormRegister;

interface
uses
  classes, Exptintf,
{$IFNDEF D6UP}
  DsgnIntf;
{$ELSE}
  DesignEditors, DesignIntf;
{$ENDIF}


type
  TFormClassEditorProperty = class(TStringProperty)
  private
    cbEnumForm: TGetStrProc;
  public
    procedure GetValues(Proc: TGetStrProc); override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  procedure Register;

implementation
uses
  CEForm;

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
