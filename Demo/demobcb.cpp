//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("demobcb.res");
USEFORMNS("Unit3.pas", Unit3, DateCellEditor);
USEFORMNS("Unit2.pas", Unit2, CustomCellEditor);
USEFORMNS("unit1.pas", Unit1, DemoForm);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
    try
    {
        Application->Initialize();
        Application->CreateForm(__classid(TDemoForm), &DemoForm);
        Application->Run();
    }
    catch (Exception &exception)
    {
        Application->ShowException(&exception);
    }
    return 0;
}
//---------------------------------------------------------------------------
