// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'CEFormRegister.pas' rev: 6.00

#ifndef CEFormRegisterHPP
#define CEFormRegisterHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <DesignIntf.hpp>	// Pascal unit
#include <DesignEditors.hpp>	// Pascal unit
#include <ExptIntf.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Ceformregister
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TFormClassEditorProperty;
class PASCALIMPLEMENTATION TFormClassEditorProperty : public Designeditors::TStringProperty 
{
	typedef Designeditors::TStringProperty inherited;
	
private:
	Classes::TGetStrProc cbEnumForm;
	
public:
	virtual void __fastcall GetValues(Classes::TGetStrProc Proc);
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
public:
	#pragma option push -w-inl
	/* TPropertyEditor.Create */ inline __fastcall virtual TFormClassEditorProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TFormClassEditorProperty(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Ceformregister */
using namespace Ceformregister;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// CEFormRegister
