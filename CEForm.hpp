// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'CEForm.pas' rev: 6.00

#ifndef CEFormHPP
#define CEFormHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Forms.hpp>	// Pascal unit
#include <XStringGrid.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Ceform
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TFormInplace;
class PASCALIMPLEMENTATION TFormInplace : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
private:
	Xstringgrid::TCellEditor* FCellEditor;
	
protected:
	virtual void __fastcall CreateParams(Controls::TCreateParams &Params);
	DYNAMIC void __fastcall KeyDown(Word &Key, Classes::TShiftState Shift);
	MESSAGE void __fastcall WMGetDlgCode(Messages::TWMNoParams &Message);
	DYNAMIC void __fastcall DoExit(void);
	
public:
	__fastcall virtual TFormInplace(Classes::TComponent* AOwner, Xstringgrid::TCellEditor* CellEditor);
public:
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFormInplace(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFormInplace(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TFormInplace(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	#pragma option pop
	
};


typedef AnsiString TFormInplaceName;

class DELPHICLASS TFormCellEditor;
class PASCALIMPLEMENTATION TFormCellEditor : public Xstringgrid::TMetaCellEditor 
{
	typedef Xstringgrid::TMetaCellEditor inherited;
	
private:
	int FHeight;
	int FWidth;
	Classes::TNotifyEvent FOnStartEdit;
	Classes::TNotifyEvent FOnEndEdit;
	AnsiString FCellEditorForm;
	void __fastcall setHeight(int Value);
	void __fastcall setWidth(int Value);
	void __fastcall setCellEditorForm(AnsiString Value);
	
protected:
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	virtual void __fastcall Attatch(Xstringgrid::TXStringGrid* AGrid);
	
public:
	__fastcall virtual TFormCellEditor(Classes::TComponent* AOwner);
	virtual void __fastcall StartEdit(void);
	virtual void __fastcall EndEdit(void);
	virtual void __fastcall Draw(const Types::TRect &Rect);
	
__published:
	__property int Height = {read=FHeight, write=setHeight, nodefault};
	__property int Width = {read=FWidth, write=setWidth, nodefault};
	__property AnsiString CellEditorForm = {read=FCellEditorForm, write=setCellEditorForm};
	__property Classes::TNotifyEvent OnStartEdit = {read=FOnStartEdit, write=FOnStartEdit};
	__property Classes::TNotifyEvent OnEndEdit = {read=FOnEndEdit, write=FOnEndEdit};
public:
	#pragma option push -w-inl
	/* TMetaCellEditor.Destroy */ inline __fastcall virtual ~TFormCellEditor(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Ceform */
using namespace Ceform;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// CEForm
