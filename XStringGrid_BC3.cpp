//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("XStringGrid_BC3.res");
USEPACKAGE("vclx35.bpi");
USEPACKAGE("VCL35.bpi");
USEPACKAGE("vcldb35.bpi");
USEPACKAGE("vcldbx35.bpi");
USEPACKAGE("bcbsmp35.bpi");
USEPACKAGE("dclocx35.bpi");
USEPACKAGE("Qrpt35.bpi");
USEPACKAGE("teeui35.bpi");
USEPACKAGE("teedb35.bpi");
USEPACKAGE("tee35.bpi");
USEPACKAGE("ibsmp35.bpi");
USEPACKAGE("NMFast35.bpi");
USEPACKAGE("inetdb35.bpi");
USEPACKAGE("inet35.bpi");
USEUNIT("XStringGridRegister.pas");
USERES("XStringGridRegister.dcr");
USEUNIT("CEFormRegister.pas");
USEUNIT("CECheckList.pas");
USEUNIT("CEForm.pas");
USEUNIT("CEButton.pas");
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
