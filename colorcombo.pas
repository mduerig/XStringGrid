///////////////////////////////////////////////////////////////////////////
// Dateiname: ColorCombo.pas                                             //
// Version:   1.0.                                                       //
// Autor:     Michael Dürig (md)                                         //
// Beschreib: Combobox zur Auswahl einer Farbe.                          //
//            Items nimmt clXXXX auf. Das public property Selection      //
//            Gibt die aktuelle Selektion zurück.                        //
///////////////////////////////////////////////////////////////////////////
// (C) 1997   Michael Dürig                                              //
//            Vogesenstr. 71                                             //
//            CH-4056 Basel                                              //
//            mduerig@eye.ch                                             //
///////////////////////////////////////////////////////////////////////////
// History:  05.01.96md v1.0 Erstellung                                  //
///////////////////////////////////////////////////////////////////////////

unit colorcombo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TColorCombo = class(TCustomComboBox)
  private
    function GetSelection: TColor;
    procedure SetSelection(Value: TColor);
  protected
    procedure SetStyle(Value: TComboBoxStyle); override;
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetColorList; virtual;
    property Selection: TColor read GetSelection write SetSelection;
  published
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property Items;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
  end;

procedure Register;

implementation

const
  ColorArray: array[0..19] of TColor =
  (
    clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
    clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clLtGray,
    clDkGray, clWhite, clNone, clDefault
  );

////////////////////////////////////////////////////////////////////////////////
// public Globals
//

procedure Register;
begin
  RegisterComponents('Additional', [TColorCombo]);
end;

////////////////////////////////////////////////////////////////////////////////
// private TColorCombo
//

function TColorCombo.GetSelection: TColor;
begin
  result := 0;
  if ItemIndex >= 0 then
    if not IdentToColor(Items[ItemIndex], LongInt(result)) then
      result := 0;
end;

procedure TColorCombo.SetSelection(Value: TColor);
var
  c: integer;
  i: Longint;
begin
  ItemIndex := -1;

  for c := 0 to Items.count do
    if IdentToColor(Items[c], i) then
      if i = Value then
        ItemIndex := c;
end;

////////////////////////////////////////////////////////////////////////////////
// protected TColorCombo
//

procedure TColorCombo.SetStyle(Value: TComboBoxStyle);
begin
  inherited SetStyle(csOwnerDrawFixed);
end;

procedure TColorCombo.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  r: TRect;
  ItemColor, c: TColor;
begin
  r.top := Rect.top + 3;
  r.bottom := Rect.bottom - 3;
  r.left := Rect.left + 3;
  r.right := r.left + 14;
  with Canvas do begin
    FillRect(Rect);
    c := Brush.Color;
    if IdentToColor(Items[Index], LongInt(ItemColor)) then
      Brush.Color := ItemColor;
    FillRect(r);
    Brush.Color := clBlack;
    FrameRect(r);
    Brush.Color := c;
  end;
  r := Rect;
  r.left := r.left + 20;
  inherited DrawItem(Index, r, State);
end;

procedure TColorCombo.CreateWnd;
begin
  inherited CreateWnd;
  SetColorList;
end;

////////////////////////////////////////////////////////////////////////////////
// public TColorCombo
//

constructor TColorCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csOwnerDrawFixed;
end;

procedure TColorCombo.SetColorList;
var
  c: integer;
  s: String;
begin
  if csDesigning in ComponentState then
    with items do begin
      clear;
      for c := 0 to High(ColorArray) do
        if ColorToIdent(ColorArray[c], s) then
          Add(s);
    end;
end;

end.
