// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'XStringGridRegister.pas' rev: 6.00

#ifndef XStringGridRegisterHPP
#define XStringGridRegisterHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <DesignIntf.hpp>	// Pascal unit
#include <DesignEditors.hpp>	// Pascal unit
#include <DBGrids.hpp>	// Pascal unit
#include <Grids.hpp>	// Pascal unit
#include <colorcombo.hpp>	// Pascal unit
#include <ComCtrls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <XStringGrid.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Xstringgridregister
{
//-- type declarations -------------------------------------------------------
typedef IDesigner IFormDesigner;
;

class DELPHICLASS TXStringColumnsProperty;
class PASCALIMPLEMENTATION TXStringColumnsProperty : public Designeditors::TClassProperty 
{
	typedef Designeditors::TClassProperty inherited;
	
public:
	virtual void __fastcall Edit(void);
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
public:
	#pragma option push -w-inl
	/* TPropertyEditor.Create */ inline __fastcall virtual TXStringColumnsProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TClassProperty(ADesigner, APropCount) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TXStringColumnsProperty(void) { }
	#pragma option pop
	
};


class DELPHICLASS TXStringColumnsEditor;
class PASCALIMPLEMENTATION TXStringColumnsEditor : public Designeditors::TDefaultEditor 
{
	typedef Designeditors::TDefaultEditor inherited;
	
protected:
	virtual void __fastcall EditProperty(const Designintf::_di_IProperty PropertyEditor, bool &Continue);
	
public:
	virtual void __fastcall ExecuteVerb(int Index);
	virtual AnsiString __fastcall GetVerb(int Index);
	virtual int __fastcall GetVerbCount(void);
public:
	#pragma option push -w-inl
	/* TComponentEditor.Create */ inline __fastcall virtual TXStringColumnsEditor(Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TDefaultEditor(AComponent, ADesigner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TXStringColumnsEditor(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDlgProps;
class PASCALIMPLEMENTATION TDlgProps : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TButton* BtnClose;
	Dialogs::TFontDialog* DlgFont;
	Stdctrls::TGroupBox* GroupBox1;
	Stdctrls::TListBox* LBColumns;
	Stdctrls::TGroupBox* GroupBox2;
	Comctrls::TTrackBar* TBWidth;
	Stdctrls::TLabel* LabelWidth;
	Stdctrls::TLabel* Label1;
	Stdctrls::TButton* btnAbout;
	Stdctrls::TGroupBox* GroupBox3;
	Stdctrls::TLabel* Label2;
	Stdctrls::TEdit* EditHeader;
	Stdctrls::TLabel* Label7;
	Stdctrls::TComboBox* CBHdrAlignment;
	Stdctrls::TButton* BtnHdrFont;
	Stdctrls::TGroupBox* GroupBox4;
	Stdctrls::TLabel* Label6;
	Stdctrls::TComboBox* CBAlignment;
	Stdctrls::TLabel* Label4;
	Colorcombo::TColorCombo* CBColor;
	Stdctrls::TLabel* Label3;
	Colorcombo::TColorCombo* CBHdrColor;
	Stdctrls::TButton* BtnFont;
	Stdctrls::TLabel* Label5;
	Stdctrls::TComboBox* CBEditor;
	void __fastcall LBColumnsClick(System::TObject* Sender);
	void __fastcall TBWidthChange(System::TObject* Sender);
	void __fastcall EditHeaderExit(System::TObject* Sender);
	void __fastcall BtnFontClick(System::TObject* Sender);
	void __fastcall BtnHdrFontClick(System::TObject* Sender);
	void __fastcall CBColorChange(System::TObject* Sender);
	void __fastcall CBHdrColorChange(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall CBEditorChange(System::TObject* Sender);
	void __fastcall btnAboutClick(System::TObject* Sender);
	void __fastcall CBAlignmentChange(System::TObject* Sender);
	void __fastcall CBHdrAlignmentChange(System::TObject* Sender);
	
private:
	Xstringgrid::TXStringColumns* FColumns;
	Designintf::_di_IDesigner FDesigner;
	void __fastcall AddEditorClass(const AnsiString S);
	void __fastcall SetColumns(Xstringgrid::TXStringColumns* Value);
	AnsiString __fastcall GetColCaption();
	void __fastcall SetColCaption(AnsiString Value);
	Classes::TAlignment __fastcall GetAlignment(void);
	void __fastcall SetAlignment(Classes::TAlignment Value);
	Classes::TAlignment __fastcall GetHdrAlignment(void);
	void __fastcall SetHdrAlignment(Classes::TAlignment Value);
	int __fastcall GetColWidth(void);
	void __fastcall SetColWidth(int Value);
	Graphics::TColor __fastcall GetColColor(void);
	void __fastcall SetColColor(Graphics::TColor Value);
	Graphics::TColor __fastcall GetColHdrColor(void);
	void __fastcall SetColHdrColor(Graphics::TColor Value);
	Graphics::TFont* __fastcall GetColFont(void);
	void __fastcall SetColFont(Graphics::TFont* Value);
	Graphics::TFont* __fastcall GetColHdrFont(void);
	void __fastcall SetColHdrFont(Graphics::TFont* Value);
	Xstringgrid::TCellEditor* __fastcall GetCellEditor(void);
	void __fastcall SetCellEditor(Xstringgrid::TCellEditor* Value);
	__property AnsiString ColCaption = {read=GetColCaption, write=SetColCaption};
	__property Classes::TAlignment Aligmnent = {read=GetAlignment, write=SetAlignment, nodefault};
	__property Classes::TAlignment HdrAlignment = {read=GetHdrAlignment, write=SetHdrAlignment, nodefault};
	__property int ColWidth = {read=GetColWidth, write=SetColWidth, nodefault};
	__property Graphics::TColor ColColor = {read=GetColColor, write=SetColColor, nodefault};
	__property Graphics::TColor ColHdrColor = {read=GetColHdrColor, write=SetColHdrColor, nodefault};
	__property Graphics::TFont* ColFont = {read=GetColFont, write=SetColFont};
	__property Graphics::TFont* ColHdrFont = {read=GetColHdrFont, write=SetColHdrFont};
	__property Xstringgrid::TCellEditor* CellEditor = {read=GetCellEditor, write=SetCellEditor};
	
public:
	__fastcall TDlgProps(Classes::TComponent* AOwner, Designintf::_di_IDesigner Designer);
	__property Xstringgrid::TXStringColumns* Columns = {read=FColumns, write=SetColumns};
public:
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TDlgProps(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TDlgProps(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TDlgProps(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);
extern PACKAGE void __fastcall EditColumns(Xstringgrid::TXStringColumns* Cols, Designintf::_di_IDesigner Designer);

}	/* namespace Xstringgridregister */
using namespace Xstringgridregister;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// XStringGridRegister
