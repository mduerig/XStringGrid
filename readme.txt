XStringrid Version 2.6
======================

OVERVIEW
--------
XStringgrid is an extended version of the stringgrid which
offers a lot more flexibility. It's possible to apply different
colors and fonts to each column and it's header and align the
content of the cells. In addition it offers different inplace
editors which can be assigned to columns to edit their cells.
So far edit, combo, maskedit, updown, checklist, button checkbox
and form inplace editors are implemented. TXStringgrid also 
implements a flexible sort mechanism.
See the demo project to get started.

INSTALLATION
------------
Use the appropriate package file for installation:
  - Delphi3: XStringGrid_D3.dpk
  - Delphi4: XStringGrid_D4.dpk
  - Delphi5: XStringGrid_D5.dpk
  - Delphi6: XStringGrid_D6.dpk
  - Delphi7: XStringGrid_D7.dpk
  - BCB3: XStringGrid_BC3.bpk
  - BCB5: XStringGrid_BC5.bpk
  - BCB6: XStringGrid_BC6.bpk

If you succeed to install the component on any other version of 
Delphi or CBuilder please send me a note and the patches required
if any.

KNOWN ISSUES
------------
There is a problem in D3 with the Align property. When setting the
Align property of the grid or of any parent container to any other 
value than alNone, the inplace editors "jump around" whenever they 
are activated. The problem is due to a flaw in the VCL. 
TControl.RequestAlign is static rather than virtual so the inplace 
editors have no chance to override this method to handle their 
alignment properly (which is doing nothing really). This was fixed 
in D4.

NOTES
-----
This component is freeware and it comes with full source code
included. You are free to use it and all its associated files in
any way you want, but dont expect me to support it. However, if
you encounter any problems and live in a warm and sunny country,
please feel free to send me an air ticket and I'll see what I
can do :)

DISCLAIMER
----------
THIS PROGRAM IS PROVIDED "AS-IS". NO WARRANTIES OF ANY KIND,
EXPRESSED OR IMPLIED, ARE MADE. NO REMEDY WILL BE PROVIDED FOR
INDIRECT, CONSEQUENTIAL, PUNITIVE OR INCIDENTAL DAMAGES ARISING
FROM IT, INCLUDING SUCH FROM NEGLIGENCE, STRICT LIABILITY, OR
BREACH OF WARRANTY OR CONTRACT, EVEN AFTER NOTICE OF THE
POSSIBILITY OF SUCH DAMAGES.

2003-06-29
Michael Dürig
mduerig@eye.ch
