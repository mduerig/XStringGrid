// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'CEButton.pas' rev: 6.00

#ifndef CEButtonHPP
#define CEButtonHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <StdCtrls.hpp>	// Pascal unit
#include <XStringGrid.hpp>	// Pascal unit
#include <Buttons.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Cebutton
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TButtonInplace;
class PASCALIMPLEMENTATION TButtonInplace : public Buttons::TBitBtn 
{
	typedef Buttons::TBitBtn inherited;
	
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
	__fastcall virtual TButtonInplace(Classes::TComponent* AOwner, Xstringgrid::TCellEditor* CellEditor);
public:
	#pragma option push -w-inl
	/* TBitBtn.Destroy */ inline __fastcall virtual ~TButtonInplace(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TButtonInplace(HWND ParentWindow) : Buttons::TBitBtn(ParentWindow) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TAlignMode { amAbsolute, amRelative };
#pragma option pop

#pragma option push -b-
enum THAlign { haLeft, haCenter, haRight };
#pragma option pop

#pragma option push -b-
enum TVAlign { vaTop, vaCenter, vaBottom };
#pragma option pop

class DELPHICLASS TButtonCellEditor;
class PASCALIMPLEMENTATION TButtonCellEditor : public Xstringgrid::TMetaCellEditor 
{
	typedef Xstringgrid::TMetaCellEditor inherited;
	
private:
	Classes::TNotifyEvent FOnClick;
	TAlignMode FAlignMode;
	THAlign FHAlign;
	TVAlign FVAlign;
	int FHeight;
	int FWidth;
	AnsiString FCaption;
	Graphics::TBitmap* FGlyph;
	Buttons::TButtonLayout FLayout;
	int FMargin;
	int FSpacing;
	Buttons::TNumGlyphs FNumGlyphs;
	AnsiString __fastcall getCaption();
	void __fastcall setCaption(AnsiString Value);
	Graphics::TBitmap* __fastcall getGlyph(void);
	void __fastcall setGlyph(Graphics::TBitmap* Value);
	Buttons::TButtonLayout __fastcall getLayout(void);
	void __fastcall setLayout(Buttons::TButtonLayout Value);
	int __fastcall getMargin(void);
	void __fastcall setMargin(int Value);
	void __fastcall setHeight(int Value);
	void __fastcall setWidth(int Value);
	void __fastcall setAlignMode(TAlignMode Value);
	int __fastcall getSpacing(void);
	void __fastcall setSpacing(int Value);
	Classes::TNotifyEvent __fastcall getOnClick();
	void __fastcall setOnClick(Classes::TNotifyEvent Value);
	
protected:
	virtual Controls::TWinControl* __fastcall InitEditor(Classes::TComponent* AOwner);
	
public:
	__fastcall virtual TButtonCellEditor(Classes::TComponent* AOwner);
	virtual void __fastcall StartEdit(void);
	virtual void __fastcall EndEdit(void);
	__fastcall virtual ~TButtonCellEditor(void);
	virtual void __fastcall Draw(const Types::TRect &Rect);
	
__published:
	__property Classes::TNotifyEvent OnClick = {read=getOnClick, write=setOnClick};
	__property TAlignMode AlignMode = {read=FAlignMode, write=setAlignMode, default=1};
	__property THAlign HAlign = {read=FHAlign, write=FHAlign, default=2};
	__property TVAlign VAlign = {read=FVAlign, write=FVAlign, default=1};
	__property int Height = {read=FHeight, write=setHeight, nodefault};
	__property int Width = {read=FWidth, write=setWidth, nodefault};
	__property AnsiString Caption = {read=getCaption, write=setCaption};
	__property Graphics::TBitmap* Glyph = {read=getGlyph, write=setGlyph};
	__property Buttons::TButtonLayout Layout = {read=getLayout, write=setLayout, nodefault};
	__property int Margin = {read=getMargin, write=setMargin, nodefault};
	__property Buttons::TNumGlyphs NumGlyphs = {read=FNumGlyphs, write=FNumGlyphs, nodefault};
	__property int Spacing = {read=getSpacing, write=setSpacing, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Cebutton */
using namespace Cebutton;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// CEButton
