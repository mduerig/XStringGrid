//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("XStringGrid_BC3.res");
USEPACKAGE("vclx35.bpi");
USEPACKAGE("VCL35.bpi");
USEUNIT("XStringGridRegister.pas");
USERES("XStringGridRegister.dcr");
USEUNIT("CEFormRegister.pas");
USEUNIT("CECheckList.pas");
USEUNIT("CEForm.pas");
USEUNIT("CEButton.pas");
USEUNIT("colorcombo.pas");
USERES("colorcombo.dcr");
USEUNIT("XStringGrid.pas");
USEFORMNS("about.pas", About, AboutBox);
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
