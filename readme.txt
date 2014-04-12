			    PORTIO for OS/2

PORTIO was originally written by Michael Thompson (tommy@msc.cornell.edu)
to allow port access under OS/2 2.X using the IBM C Set/2 compiler.  This
code has been ported over to BCOS2.

Since BCOS2's linkage editor (TLINK) does not handle IOPL code properly a
substancial modification was required.	Since TLINK does not fill in the
word count field in call gates, parameters do not get copied to the IOPL
routine's stack (normally done by the hardware transparently if the word
count field is used).  A macro ($IOPL) to copy the non-priviledged stack to
the priviledged stack has been provided as an example of how to build IOPL
code using BCOS2.  Once Borland fixes TLINK this macro will no longer be
required.

 Function definitions for port access routines
      inp(port)   - read single byte from I/O port
      inpw(port)  - read single word from I/O port pair
      outp(port,short)	- write single byte to I/O port
      outpw(port,short) - write single word to I/O port pair

 Originally for IBM C Set/2  Version 1.0
 Ported to Borland C++ for OS/2 Version 1.0

DISCLAIMER:
-------------------------
This code and the accompanying documentation is hereby placed in
the public domain.  It is not part of any standard product and
is provided solely as an example for your private and/or
commercial use.  You may freely use or distribute this code in
derived works as long as you do not attempt to prevent others
from doing likewise.  Neither the authors, nor their employers,
shall be liable for any damages arising from your use of this
code; it is provided solely ASIS with no warranty whatsoever.

Author contact:   Michael Thompson
		  tommy@msc.cornell.edu

Ported to Borland C++ for OS/2 by:
		  Cy Schubert
		  cschuber@bcsc02.gov.bc.ca
