// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'CECheckbox.pas' rev: 6.00

#ifndef CECheckboxHPP
#define CECheckboxHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <XStringGrid.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Cecheckbox
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TCheckBoxCellEditor;
typedef void __fastcall (__closure *TSetTextEvent)(TCheckBoxCellEditor* Sender, AnsiString &Value);

typedef void __fastcall (__closure *TSetStateEvent)(TCheckBoxCellEditor* Sender);

class DELPHICLASS TCheckBoxInplace;
class PASCALIMPLEMENTATION TCheckBoxInplace : public Stdctrls::TCheckBox 
{
	typedef Stdctrls::TCheckBox inherited;
	
private:
	Xstringgrid::TCellEditor* FCellEditor;
	
protected:
	DYNAMIC void __fastcall RequestAlign(void);
	DYNAMIC void __fastcall KeyDown(Word &Key, Classes::TShiftState Shift);
	MESSAGE void __fastcall WMGetDlgCode(Messages::TWMNoParams &Message);
	DYNAMIC void __fastcall KeyPress(char &Key);
	DYNAMIC void __fastcall DoExit(void);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TCheckBoxInplace(Classes::TComponent* AOwner, Xstringgrid::TCellEditor* CellEditor);
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TCheckBoxInplace(HWND ParentWindow) : Stdctrls::TCheckBox(ParentWindow) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TWinControl.Destroy */ inline __fastcall virtual ~TCheckBoxInplace(void) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TVAlign { vaTop, vaCenter, vaBottom };
#pragma option pop

class PASCALIMPLEMENTATION TCheckBoxCellEditor : public Xstringgrid::TMetaCellEditor 
{
	typedef Xstringgrid::TMetaCellEditor inherited;
	
private:
	Classes::TNotifyEvent FOnClick;
	TSetStateEvent FOnSetState;
	TSetTextEvent FOnSetText;
	AnsiString FCaption;
	Stdctrls::TCheckBoxState FCheckBoxState;
	int FSpacing;
	Classes::TAlignment FAlignment;
	AnsiString __fastcall getCaption();
	void __fastcall setCaption(AnsiString Value);
	Classes::TNotifyEvent __fastcall getOnClick();
	void __fastcall setOnClick(Classes::TNotifyEvent Value);
	Stdctrls::TCheckBoxState __fastcall getCheckBoxState(void);
	void __fastcall setCheckBoxState(const Stdctrls::TCheckBoxState Value);
	void __fastcall setAlignment(const Classes::TLeftRight Value);
	Classes::TLeftRight __fastcall getAlignment(void);
	
protected:
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	
public:
	virtual void __fastcall StartEdit(void);
	virtual void __fastcall EndEdit(void);
	virtual void __fastcall Draw(const Types::TRect &Rect);
	
__published:
	__property Classes::TNotifyEvent OnClick = {read=getOnClick, write=setOnClick};
	__property TSetTextEvent OnSetText = {read=FOnSetText, write=FOnSetText};
	__property TSetStateEvent OnSetState = {read=FOnSetState, write=FOnSetState};
	__property AnsiString Caption = {read=getCaption, write=setCaption};
	__property Stdctrls::TCheckBoxState State = {read=getCheckBoxState, write=setCheckBoxState, nodefault};
	__property int Spacing = {read=FSpacing, write=FSpacing, default=0};
	__property Classes::TLeftRight Alignment = {read=getAlignment, write=setAlignment, nodefault};
public:
	#pragma option push -w-inl
	/* TMetaCellEditor.Destroy */ inline __fastcall virtual ~TCheckBoxCellEditor(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TCheckBoxCellEditor(Classes::TComponent* AOwner) : Xstringgrid::TMetaCellEditor(AOwner) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Cecheckbox */
using namespace Cecheckbox;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// CECheckbox
