// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'CECheckList.pas' rev: 6.00

#ifndef CECheckListHPP
#define CECheckListHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <StdCtrls.hpp>	// Pascal unit
#include <XStringGrid.hpp>	// Pascal unit
#include <CheckLst.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Cechecklist
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TCheckListCellEditor;
typedef void __fastcall (__closure *TSetTextEvent)(TCheckListCellEditor* Sender, AnsiString &Value);

typedef void __fastcall (__closure *TSetChecksEvent)(TCheckListCellEditor* Sender);

#pragma option push -b-
enum TDropDownStyle { dsFixed, dsAuto };
#pragma option pop

class DELPHICLASS TCheckListInplace;
class PASCALIMPLEMENTATION TCheckListInplace : public Checklst::TCheckListBox 
{
	typedef Checklst::TCheckListBox inherited;
	
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
	__fastcall TCheckListInplace(Classes::TComponent* AOwner, Xstringgrid::TCellEditor* CellEditor);
public:
	#pragma option push -w-inl
	/* TCheckListBox.Destroy */ inline __fastcall virtual ~TCheckListInplace(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TCheckListInplace(HWND ParentWindow) : Checklst::TCheckListBox(ParentWindow) { }
	#pragma option pop
	
};


class PASCALIMPLEMENTATION TCheckListCellEditor : public Xstringgrid::TMetaCellEditor 
{
	typedef Xstringgrid::TMetaCellEditor inherited;
	
private:
	int FHeight;
	int FWidth;
	int FColumns;
	TDropDownStyle FDropDownStyle;
	Classes::TStrings* FItems;
	TSetChecksEvent FOnSetChecks;
	TSetTextEvent FOnSetText;
	int __fastcall getColumns(void);
	void __fastcall setColumns(int Value);
	
protected:
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	void __fastcall SetItems(Classes::TStrings* Value);
	bool __fastcall getChecked(int Index);
	void __fastcall setChecked(int Index, bool Value);
	
public:
	__fastcall virtual TCheckListCellEditor(Classes::TComponent* AOwner);
	__fastcall virtual ~TCheckListCellEditor(void);
	virtual void __fastcall StartEdit(void);
	virtual void __fastcall EndEdit(void);
	virtual void __fastcall Draw(const Types::TRect &Rect);
	__property bool Checked[int Index] = {read=getChecked, write=setChecked};
	
__published:
	__property int DropdownHeight = {read=FHeight, write=FHeight, nodefault};
	__property TDropDownStyle DropDownStyle = {read=FDropDownStyle, write=FDropDownStyle, nodefault};
	__property int DropdownWidth = {read=FWidth, write=FWidth, nodefault};
	__property TSetChecksEvent OnSetChecks = {read=FOnSetChecks, write=FOnSetChecks};
	__property TSetTextEvent OnSetText = {read=FOnSetText, write=FOnSetText};
	__property int Columns = {read=getColumns, write=setColumns, nodefault};
	__property Classes::TStrings* Items = {read=FItems, write=SetItems};
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Cechecklist */
using namespace Cechecklist;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// CECheckList
