{
  ------------------------------------------------------------------------------
    Filename: CEForm.pas
    Version:  v1.0
    Authors:  Michael Dürig (md)
    Purpose:  Grid cell editor using a form custom designed form.
    Remark:   Needs TXStringGrid v1.2
  ------------------------------------------------------------------------------
    (C) 1999  M. Dürig
              CH-4056 Basel
              mduerig@eye.ch / http://www.eye.ch/~mduerig
  ------------------------------------------------------------------------------
    History:  05.07.99md  v1.0  Creation
              12.08.99md  v2.0 Release v2.0
              25.02.2k md v2.0 Fixed bug with runtime assigning
              16.08.01md  v2.5 Release 2.5
  ------------------------------------------------------------------------------
}

{$I VERSIONS.INC}
unit CEForm;

interface
uses
  windows, graphics, messages, classes, Controls, XStringGrid, forms;

type
  TFormInplace = class(TForm)
  private
    FCellEditor: TCellEditor;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent; CellEditor: TCellEditor); {$IFDEF HAS_REINTRODUCE} reintroduce; {$ENDIF} virtual;  
  end;

  TFormInplaceName = string;

  TFormCellEditor = class(TMetaCellEditor)
  private
    FHeight: integer;
    FWidth: integer;
    FOnStartEdit: TNotifyEvent;
    FOnEndEdit: TNotifyEvent;
    FCellEditorForm: TFormInplaceName;
    procedure setHeight(Value: integer);
    procedure setWidth(Value: integer);
    procedure setCellEditorForm(Value: string);
  protected
    function InitEditor(AOwner: TComponent): TWinControl; override;
    procedure Attatch(AGrid: TXStringGrid); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure StartEdit; override;
    procedure EndEdit; override;
    procedure Draw(Rect: TRect); override;
  published
    property Height: integer read FHeight write setHeight;
    property Width: integer read FWidth write setWidth;
    property CellEditorForm: TFormInplaceName read FCellEditorForm write setCellEditorForm;
    property OnStartEdit: TNotifyEvent read FOnStartEdit write FOnStartEdit;
    property OnEndEdit: TNotifyEvent read FOnEndEdit write FOnEndEdit;
  end;

implementation
uses
  grids;

// -- TFormCellEditor ----------------------------------------------------

constructor TFormCellEditor.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FHeight := 0;
  FWidth := 0;
end;

procedure TFormCellEditor.setHeight(Value: integer);
begin
  FHeight := Value
end;

procedure TFormCellEditor.setWidth(Value: integer);
begin
  FWidth := Value
end;

procedure TFormCellEditor.setCellEditorForm(Value: string);
begin
  FCellEditorForm := Value;
end;

procedure TFormCellEditor.StartEdit;
begin
  if Assigned(FOnStartEdit) then
    FOnStartEdit(self);
end;

procedure TFormCellEditor.EndEdit;
begin
  if Assigned(FOnEndEdit) then
    FOnEndEdit(self);
end;

function TFormCellEditor.InitEditor(AOwner: TComponent): TWinControl;
begin
  result := (FindClass(FCellEditorForm).NewInstance) as TFormInplace;
  TFormInplace(result).create(AOwner, self);
end;

procedure TFormCellEditor.Draw(Rect: TRect);
begin
  if FEditor = nil then
    init;

  with FEditor do begin
    Parent := grid;

    left := Rect.left;
    top := Rect.top;

    // Use the cells width if FormCellEditor.Width = 0
    if FWidth = 0 then
      Width := rect.right - rect.left
    else
      width := FWidth;

    // Use the cells width if FormCellEditor.Height = 0
    if FHeight = 0 then
      Height := rect.bottom - rect.top
    else
      Height := FHeight;             

    // Check if the FormCellEditor.Height exceeds the bottom of the grid and
    if Top + Height > Grid.ClientHeight - 5 then
      // if the editing occures in the under half of the grid
      if Top - Rect.Bottom + Rect.Top > Grid.ClientHeight div 2 then begin
        // draw the dropdown upwards.
        Top := Rect.Bottom - Height;
        // If it exceeds the uper half now, clip it.
        if Top < 0 then begin
          Height := Height + Top - 5;
          Top := 5;
        end
      end
      else begin
        // else draw it downwards and clip it.
        Height := Height - Top - Height + Grid.ClientHeight - 5;
      end;

    visible := true;
    if not(goAlwaysShowEditor in Grid.Options) then
      Grid.EditorMode := false;
    SetFocus;
  end;
end;

// -- TFormInplace -------------------------------------------------------

procedure TFormInplace.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and not (WS_CLIPCHILDREN or WS_CAPTION or WS_CLIPSIBLINGS);
end;

procedure TFormInplace.KeyDown(var Key: Word; Shift: TShiftState);
var
  AllowEndEdit: boolean;
begin
  AllowEndEdit := false;
  if Key in [VK_TAB, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    case Key of
      VK_UP:     AllowEndEdit := true;
      VK_DOWN:   AllowEndEdit := true;
      VK_LEFT:   AllowEndEdit := true;
      VK_RIGHT:  AllowEndEdit := true;
      VK_TAB:    AllowEndEdit := goTabs in FCellEditor.Grid.Options;
    end;
  end;

  if assigned(FCellEditor.AllowEndEditEvent) then
    FCellEditor.AllowEndEditEvent(self, Key, Shift, AllowEndEdit);
  if AllowEndEdit then begin
    DoExit;
    FCellEditor.Grid.HandleKey(Key, Shift);
    FCellEditor.Grid.SetFocus;
    Key := 0;
  end;
  if Key <> 0 then
    inherited KeyDown(Key, Shift);
end;

procedure TFormInplace.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in FCellEditor.Grid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;

  Message.Result := Message.Result or DLGC_WANTARROWS;
end;

procedure TFormInplace.DoExit;
begin
  FCellEditor.EndEdit;
  FCellEditor.Clear;
  inherited
end;

constructor TFormInplace.Create(AOwner: TComponent; CellEditor: TCellEditor);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csClickEvents];
  FCellEditor := CellEditor;
  VertScrollBar.visible := false;
  HorzScrollBar.visible := false;
  visible := false;
  TabStop := false;
end;

procedure TFormCellEditor.Attatch(AGrid: TXStringGrid);
begin
  if FEditor <> nil then
    FEditor.Parent := AGrid;
    
  inherited Attatch(AGrid);
end;

end.
