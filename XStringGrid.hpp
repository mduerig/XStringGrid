// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'XStringGrid.pas' rev: 6.00

#ifndef XStringGridHPP
#define XStringGridHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Buttons.hpp>	// Pascal unit
#include <ComCtrls.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Mask.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Grids.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Xstringgrid
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS ECellEditorError;
class PASCALIMPLEMENTATION ECellEditorError : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall ECellEditorError(const AnsiString Msg) : Sysutils::Exception(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall ECellEditorError(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall ECellEditorError(int Ident)/* overload */ : Sysutils::Exception(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall ECellEditorError(int Ident, const System::TVarRec * Args, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall ECellEditorError(const AnsiString Msg, int AHelpContext) : Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall ECellEditorError(const AnsiString Msg, const System::TVarRec * Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall ECellEditorError(int Ident, int AHelpContext)/* overload */ : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall ECellEditorError(System::PResStringRec ResStringRec, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~ECellEditorError(void) { }
	#pragma option pop
	
};


typedef void __fastcall (__closure *TAllowEndEditEvent)(System::TObject* Sender, Word &Key, Classes::TShiftState Shift, bool &EndEdit);

class DELPHICLASS TCellEditor;
class DELPHICLASS TXStringGrid;
class DELPHICLASS TXStringColumns;
class DELPHICLASS TXStringColumnItem;
class PASCALIMPLEMENTATION TXStringColumns : public Classes::TCollection 
{
	typedef Classes::TCollection inherited;
	
public:
	TXStringColumnItem* operator[](int Index) { return Items[Index]; }
	
private:
	TXStringGrid* FOwner;
	HIDESBASE TXStringColumnItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TXStringColumnItem* Value);
	
protected:
	DYNAMIC Classes::TPersistent* __fastcall GetOwner(void);
	
public:
	__fastcall TXStringColumns(TXStringGrid* AOwner);
	__fastcall virtual ~TXStringColumns(void);
	HIDESBASE TXStringGrid* __fastcall Owner(void);
	__property TXStringColumnItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
};


typedef void __fastcall (__closure *TDrawEditorEvent)(System::TObject* Sender, int ACol, int ARow, TCellEditor* Editor);

typedef int __fastcall (*TCompareProc)(TXStringGrid* Sender, int SortCol, int row1, int row2);

typedef void __fastcall (*TSwapProc)(TXStringGrid* Sender, int SortCol, int row1, int row2);

class PASCALIMPLEMENTATION TXStringGrid : public Grids::TStringGrid 
{
	typedef Grids::TStringGrid inherited;
	
private:
	int FLastChar;
	int FEditCol;
	int FEditRow;
	bool FMultiLine;
	TCellEditor* FCellEditor;
	TXStringColumns* FColumns;
	TDrawEditorEvent FOnDrawEditor;
	Graphics::TColor FFixedLineColor;
	Graphics::TColor FGridLineColor;
	bool FImmediateEditMode;
	void __fastcall SetColumns(TXStringColumns* Value);
	void __fastcall quickSort(int col, int bottom, int top, TCompareProc compare, TSwapProc swap);
	void __fastcall SetFixedLineColor(const Graphics::TColor Value);
	void __fastcall SetGridLineColor(const Graphics::TColor Value);
	
protected:
	DYNAMIC void __fastcall SizeChanged(int OldColCount, int OldRowCount);
	DYNAMIC void __fastcall ColumnMoved(int FromIndex, int ToIndex);
	virtual void __fastcall DrawCell(int ACol, int ARow, const Types::TRect &ARect, Grids::TGridDrawState AState);
	virtual bool __fastcall CanEditShow(void);
	virtual void __fastcall DrawEditor(int ACol, int ARow);
	DYNAMIC void __fastcall TopLeftChanged(void);
	HIDESBASE MESSAGE void __fastcall WMChar(Messages::TWMKey &Msg);
	DYNAMIC void __fastcall MouseDown(Controls::TMouseButton Button, Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall DestroyWnd(void);
	HIDESBASE MESSAGE void __fastcall WMCommand(Messages::TWMCommand &Message);
	
public:
	__fastcall virtual TXStringGrid(Classes::TComponent* AOwner);
	__fastcall virtual ~TXStringGrid(void);
	void __fastcall HandleKey(Word &Key, Classes::TShiftState Shift);
	void __fastcall sort(int col, TCompareProc compare, TSwapProc swap);
	__property TCellEditor* CellEditor = {read=FCellEditor};
	__property int LastChar = {read=FLastChar, write=FLastChar, nodefault};
	
__published:
	__property Ctl3D ;
	__property Graphics::TColor FixedLineColor = {read=FFixedLineColor, write=SetFixedLineColor, nodefault};
	__property Graphics::TColor GridLineColor = {read=FGridLineColor, write=SetGridLineColor, default=12632256};
	__property TXStringColumns* Columns = {read=FColumns, write=SetColumns};
	__property TDrawEditorEvent OnDrawEditor = {read=FOnDrawEditor, write=FOnDrawEditor};
	__property bool MultiLine = {read=FMultiLine, write=FMultiLine, nodefault};
	__property bool ImmediateEditMode = {read=FImmediateEditMode, write=FImmediateEditMode, nodefault};
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TXStringGrid(HWND ParentWindow) : Grids::TStringGrid(ParentWindow) { }
	#pragma option pop
	
};


class PASCALIMPLEMENTATION TCellEditor : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	AnsiString FDefaultText;
	TXStringGrid* FGrid;
	int FReferences;
	TAllowEndEditEvent FAllowEndEditEvent;
	TXStringGrid* __fastcall GetGrid(void);
	
protected:
	virtual void __fastcall Attatch(TXStringGrid* AGrid);
	virtual void __fastcall Detach(void);
	virtual void __fastcall GridWndDestroying(void);
	__property AnsiString DefaultText = {read=FDefaultText, write=FDefaultText};
	
public:
	__fastcall virtual ~TCellEditor(void);
	virtual void __fastcall init(void);
	virtual void __fastcall StartEdit(void) = 0 ;
	virtual void __fastcall EndEdit(void) = 0 ;
	virtual void __fastcall SetCellText(AnsiString Value);
	virtual void __fastcall Draw(const Types::TRect &Rect) = 0 ;
	virtual void __fastcall Clear(void) = 0 ;
	__property TXStringGrid* Grid = {read=GetGrid};
	__property int References = {read=FReferences, nodefault};
	
__published:
	__property TAllowEndEditEvent AllowEndEditEvent = {read=FAllowEndEditEvent, write=FAllowEndEditEvent};
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TCellEditor(Classes::TComponent* AOwner) : Classes::TComponent(AOwner) { }
	#pragma option pop
	
};


class DELPHICLASS TWinControlInterface;
class PASCALIMPLEMENTATION TWinControlInterface : public Controls::TWinControl 
{
	typedef Controls::TWinControl inherited;
	
public:
	__property Caption ;
	__property Color  = {default=-2147483643};
	__property Ctl3D ;
	__property DragCursor  = {default=-12};
	__property DragMode  = {default=0};
	__property Font ;
	__property OnClick ;
	__property OnDblClick ;
	__property OnDragDrop ;
	__property OnDragOver ;
	__property OnEnter ;
	__property OnExit ;
	__property OnKeyDown ;
	__property OnKeyPress ;
	__property OnKeyUp ;
	__property OnMouseDown ;
	__property OnMouseMove ;
	__property OnMouseUp ;
	__property OnStartDrag ;
	__property ParentColor  = {default=1};
	__property ParentCtl3D  = {default=1};
	__property ParentFont  = {default=1};
	__property ParentShowHint  = {default=1};
	__property PopupMenu ;
	__property Text ;
public:
	#pragma option push -w-inl
	/* TWinControl.Create */ inline __fastcall virtual TWinControlInterface(Classes::TComponent* AOwner) : Controls::TWinControl(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TWinControlInterface(HWND ParentWindow) : Controls::TWinControl(ParentWindow) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TWinControl.Destroy */ inline __fastcall virtual ~TWinControlInterface(void) { }
	#pragma option pop
	
};


class DELPHICLASS TMetaCellEditor;
class PASCALIMPLEMENTATION TMetaCellEditor : public TCellEditor 
{
	typedef TCellEditor inherited;
	
protected:
	Controls::TWinControl* FEditor;
	virtual void __fastcall Attatch(TXStringGrid* AGrid);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation);
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	virtual TWinControlInterface* __fastcall GetEditor(void);
	virtual void __fastcall GridWndDestroying(void);
	virtual void __fastcall loaded(void);
	
public:
	__fastcall virtual ~TMetaCellEditor(void);
	virtual void __fastcall init(void);
	virtual void __fastcall Draw(const Types::TRect &Rect);
	virtual void __fastcall Clear(void);
	__property TWinControlInterface* Editor = {read=GetEditor};
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TMetaCellEditor(Classes::TComponent* AOwner) : TCellEditor(AOwner) { }
	#pragma option pop
	
};


class DELPHICLASS TInplaceSpeedButton;
class PASCALIMPLEMENTATION TInplaceSpeedButton : public Buttons::TSpeedButton 
{
	typedef Buttons::TSpeedButton inherited;
	
protected:
	DYNAMIC void __fastcall RequestAlign(void);
public:
	#pragma option push -w-inl
	/* TSpeedButton.Create */ inline __fastcall virtual TInplaceSpeedButton(Classes::TComponent* AOwner) : Buttons::TSpeedButton(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TSpeedButton.Destroy */ inline __fastcall virtual ~TInplaceSpeedButton(void) { }
	#pragma option pop
	
};


class DELPHICLASS TEditInplace;
class PASCALIMPLEMENTATION TEditInplace : public Stdctrls::TCustomEdit 
{
	typedef Stdctrls::TCustomEdit inherited;
	
private:
	TCellEditor* FCellEditor;
	Buttons::TSpeedButton* FButton;
	
protected:
	DYNAMIC void __fastcall RequestAlign(void);
	virtual void __fastcall CreateParams(Controls::TCreateParams &Params);
	DYNAMIC void __fastcall KeyDown(Word &Key, Classes::TShiftState Shift);
	MESSAGE void __fastcall WMGetDlgCode(Messages::TWMNoParams &Message);
	DYNAMIC void __fastcall KeyPress(char &Key);
	DYNAMIC void __fastcall DoExit(void);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TEditInplace(Classes::TComponent* AOwner, TCellEditor* CellEditor);
	__fastcall virtual ~TEditInplace(void);
	__property Buttons::TSpeedButton* Button = {read=FButton};
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TEditInplace(HWND ParentWindow) : Stdctrls::TCustomEdit(ParentWindow) { }
	#pragma option pop
	
};


class DELPHICLASS TEditCellEditor;
class PASCALIMPLEMENTATION TEditCellEditor : public TMetaCellEditor 
{
	typedef TMetaCellEditor inherited;
	
private:
	bool FhasElipsis;
	Classes::TNotifyEvent FOnElipsisClick;
	AnsiString FElipsisCaption;
	AnsiString __fastcall getElipsisCaption();
	Classes::TNotifyEvent __fastcall getOnElipsisClick();
	void __fastcall setElipsisCaption(const AnsiString Value);
	void __fastcall setOnElipsisClick(const Classes::TNotifyEvent Value);
	
protected:
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation);
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	
public:
	virtual void __fastcall StartEdit(void);
	virtual void __fastcall EndEdit(void);
	virtual void __fastcall Clear(void);
	virtual void __fastcall Draw(const Types::TRect &Rect);
	
__published:
	__property DefaultText ;
	__property bool hasElipsis = {read=FhasElipsis, write=FhasElipsis, nodefault};
	__property Classes::TNotifyEvent OnElipsisClick = {read=getOnElipsisClick, write=setOnElipsisClick};
	__property AnsiString ElipsisCaption = {read=getElipsisCaption, write=setElipsisCaption};
public:
	#pragma option push -w-inl
	/* TMetaCellEditor.Destroy */ inline __fastcall virtual ~TEditCellEditor(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TEditCellEditor(Classes::TComponent* AOwner) : TMetaCellEditor(AOwner) { }
	#pragma option pop
	
};


class DELPHICLASS TComboInplace;
class PASCALIMPLEMENTATION TComboInplace : public Stdctrls::TCustomComboBox 
{
	typedef Stdctrls::TCustomComboBox inherited;
	
private:
	TCellEditor* FCellEditor;
	
protected:
	DYNAMIC void __fastcall RequestAlign(void);
	virtual void __fastcall CreateParams(Controls::TCreateParams &Params);
	DYNAMIC void __fastcall KeyDown(Word &Key, Classes::TShiftState Shift);
	HIDESBASE MESSAGE void __fastcall WMGetDlgCode(Messages::TWMNoParams &Message);
	DYNAMIC void __fastcall KeyPress(char &Key);
	DYNAMIC void __fastcall DoExit(void);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TComboInplace(Classes::TComponent* AOwner, TCellEditor* CellEditor);
public:
	#pragma option push -w-inl
	/* TCustomComboBox.Destroy */ inline __fastcall virtual ~TComboInplace(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TComboInplace(HWND ParentWindow) : Stdctrls::TCustomComboBox(ParentWindow) { }
	#pragma option pop
	
};


class DELPHICLASS TComboCellEditor;
class PASCALIMPLEMENTATION TComboCellEditor : public TMetaCellEditor 
{
	typedef TMetaCellEditor inherited;
	
private:
	Stdctrls::TComboBoxStyle FStyle;
	Classes::TStrings* FItems;
	
protected:
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	void __fastcall SetItems(Classes::TStrings* Value);
	virtual Stdctrls::TComboBoxStyle __fastcall GetStyle(void);
	virtual void __fastcall SetStyle(Stdctrls::TComboBoxStyle Value);
	
public:
	__fastcall virtual TComboCellEditor(Classes::TComponent* AOwner);
	__fastcall virtual ~TComboCellEditor(void);
	virtual void __fastcall StartEdit(void);
	virtual void __fastcall EndEdit(void);
	
__published:
	__property DefaultText ;
	__property Stdctrls::TComboBoxStyle Style = {read=GetStyle, write=SetStyle, default=0};
	__property Classes::TStrings* Items = {read=FItems, write=SetItems};
};


class DELPHICLASS TMaskEditInplace;
class PASCALIMPLEMENTATION TMaskEditInplace : public Mask::TCustomMaskEdit 
{
	typedef Mask::TCustomMaskEdit inherited;
	
private:
	TCellEditor* FCellEditor;
	
protected:
	DYNAMIC void __fastcall RequestAlign(void);
	virtual void __fastcall CreateParams(Controls::TCreateParams &Params);
	DYNAMIC void __fastcall KeyDown(Word &Key, Classes::TShiftState Shift);
	MESSAGE void __fastcall WMGetDlgCode(Messages::TWMNoParams &Message);
	DYNAMIC void __fastcall KeyPress(char &Key);
	DYNAMIC void __fastcall DoExit(void);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TMaskEditInplace(Classes::TComponent* AOwner, TCellEditor* CellEditor);
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TMaskEditInplace(HWND ParentWindow) : Mask::TCustomMaskEdit(ParentWindow) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TWinControl.Destroy */ inline __fastcall virtual ~TMaskEditInplace(void) { }
	#pragma option pop
	
};


class DELPHICLASS TMaskEditCellEditor;
class PASCALIMPLEMENTATION TMaskEditCellEditor : public TMetaCellEditor 
{
	typedef TMetaCellEditor inherited;
	
private:
	AnsiString FEditMask;
	AnsiString __fastcall GetEditMask();
	void __fastcall SetEditMask(AnsiString Value);
	
protected:
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	
public:
	virtual void __fastcall StartEdit(void);
	virtual void __fastcall EndEdit(void);
	virtual void __fastcall Draw(const Types::TRect &Rect);
	
__published:
	__property DefaultText ;
	__property AnsiString EditMask = {read=GetEditMask, write=SetEditMask};
public:
	#pragma option push -w-inl
	/* TMetaCellEditor.Destroy */ inline __fastcall virtual ~TMaskEditCellEditor(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TMaskEditCellEditor(Classes::TComponent* AOwner) : TMetaCellEditor(AOwner) { }
	#pragma option pop
	
};


class DELPHICLASS TInplaceUpDown;
class PASCALIMPLEMENTATION TInplaceUpDown : public Comctrls::TUpDown 
{
	typedef Comctrls::TUpDown inherited;
	
protected:
	DYNAMIC void __fastcall RequestAlign(void);
public:
	#pragma option push -w-inl
	/* TCustomUpDown.Create */ inline __fastcall virtual TInplaceUpDown(Classes::TComponent* AOwner) : Comctrls::TUpDown(AOwner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TInplaceUpDown(HWND ParentWindow) : Comctrls::TUpDown(ParentWindow) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TWinControl.Destroy */ inline __fastcall virtual ~TInplaceUpDown(void) { }
	#pragma option pop
	
};


class DELPHICLASS TUpDownInplace;
class PASCALIMPLEMENTATION TUpDownInplace : public Stdctrls::TCustomEdit 
{
	typedef Stdctrls::TCustomEdit inherited;
	
private:
	TCellEditor* FCellEditor;
	Comctrls::TUpDown* FUpDown;
	void __fastcall UpDownClick(System::TObject* Sender, Comctrls::TUDBtnType Button);
	
protected:
	DYNAMIC void __fastcall RequestAlign(void);
	virtual void __fastcall CreateParams(Controls::TCreateParams &Params);
	DYNAMIC void __fastcall KeyDown(Word &Key, Classes::TShiftState Shift);
	MESSAGE void __fastcall WMGetDlgCode(Messages::TWMNoParams &Message);
	DYNAMIC void __fastcall KeyPress(char &Key);
	DYNAMIC void __fastcall DoExit(void);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TUpDownInplace(Classes::TComponent* AOwner, TCellEditor* CellEditor);
	__fastcall virtual ~TUpDownInplace(void);
	__property Comctrls::TUpDown* UpDown = {read=FUpDown};
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TUpDownInplace(HWND ParentWindow) : Stdctrls::TCustomEdit(ParentWindow) { }
	#pragma option pop
	
};


class DELPHICLASS TUpDownCellEditor;
class PASCALIMPLEMENTATION TUpDownCellEditor : public TMetaCellEditor 
{
	typedef TMetaCellEditor inherited;
	
private:
	short FMin;
	short FMax;
	int FIncrement;
	
protected:
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation);
	short __fastcall getMin(void);
	void __fastcall setMin(short Value);
	short __fastcall getMax(void);
	void __fastcall setMax(short Value);
	void __fastcall setIncrement(int Value);
	int __fastcall getIncrement(void);
	
public:
	__fastcall virtual TUpDownCellEditor(Classes::TComponent* AOwner);
	virtual void __fastcall StartEdit(void);
	virtual void __fastcall EndEdit(void);
	virtual void __fastcall Draw(const Types::TRect &Rect);
	virtual void __fastcall Clear(void);
	
__published:
	__property DefaultText ;
	__property short Min = {read=getMin, write=setMin, default=0};
	__property short Max = {read=getMax, write=setMax, default=10};
	__property int Increment = {read=getIncrement, write=setIncrement, default=1};
public:
	#pragma option push -w-inl
	/* TMetaCellEditor.Destroy */ inline __fastcall virtual ~TUpDownCellEditor(void) { }
	#pragma option pop
	
};


class PASCALIMPLEMENTATION TXStringColumnItem : public Classes::TCollectionItem 
{
	typedef Classes::TCollectionItem inherited;
	
private:
	Graphics::TColor FHeaderColor;
	Graphics::TFont* FHeaderFont;
	Classes::TAlignment FHeaderAlignment;
	Graphics::TColor FColor;
	Graphics::TFont* FFont;
	Classes::TAlignment FAlignment;
	TCellEditor* FEditor;
	void __fastcall SetHeaderColor(Graphics::TColor Value);
	void __fastcall SetHeaderFont(Graphics::TFont* Value);
	void __fastcall SetHeaderAlignment(Classes::TAlignment Value);
	void __fastcall SetCaption(AnsiString Value);
	AnsiString __fastcall GetCaption();
	void __fastcall SetColor(Graphics::TColor Value);
	void __fastcall SetWidth(int Value);
	int __fastcall GetWidth(void);
	void __fastcall SetFont(Graphics::TFont* Value);
	void __fastcall SetAlignment(Classes::TAlignment Value);
	void __fastcall SetEditor(TCellEditor* Value);
	TXStringGrid* __fastcall GetGrid(void);
	
public:
	__fastcall virtual TXStringColumnItem(Classes::TCollection* XStringColumns);
	__fastcall virtual ~TXStringColumnItem(void);
	virtual void __fastcall Assign(Classes::TPersistent* Source);
	virtual void __fastcall ShowEditor(int ARow);
	__property TXStringGrid* Grid = {read=GetGrid};
	
__published:
	__property Graphics::TColor HeaderColor = {read=FHeaderColor, write=SetHeaderColor, default=-2147483633};
	__property Graphics::TFont* HeaderFont = {read=FHeaderFont, write=SetHeaderFont};
	__property Classes::TAlignment HeaderAlignment = {read=FHeaderAlignment, write=SetHeaderAlignment, default=0};
	__property AnsiString Caption = {read=GetCaption, write=SetCaption};
	__property Graphics::TColor Color = {read=FColor, write=SetColor, default=-2147483643};
	__property int Width = {read=GetWidth, write=SetWidth, default=64};
	__property Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property Classes::TAlignment Alignment = {read=FAlignment, write=SetAlignment, default=0};
	__property TCellEditor* Editor = {read=FEditor, write=SetEditor};
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE int __fastcall CompareProc(TXStringGrid* Sender, int SortCol, int row1, int row2);
extern PACKAGE void __fastcall SwapProc(TXStringGrid* Sender, int SortCol, int row1, int row2);

}	/* namespace Xstringgrid */
using namespace Xstringgrid;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// XStringGrid
