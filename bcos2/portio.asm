; ******************************************************************
;   <portio.asm> code file
;
;   Function definitions for port access routines
;        inp(port)   - read single byte from I/O port
;        inpw(port)  - read single word from I/O port pair
;        outp(port,short)  - write single byte to I/O port
;        outpw(port,short) - write single word to I/O port pair
;
;   Originally for IBM C Set/2  Version 1.0
;   Ported to Borland C++ for OS/2 Version 1.0
;
;  DISCLAIMER:
;  -------------------------
;  This code and the accompanying documentation is hereby placed in
;  the public domain.  It is not part of any standard product and
;  is provided solely as an example for your private and/or
;  commercial use.  You may freely use or distribute this code in
;  derived works as long as you do not attempt to prevent others
;  from doing likewise.  Neither the authors, nor their employers,
;  shall be liable for any damages arising from your use of this
;  code; it is provided solely ASIS with no warranty whatsoever.
;
;  Author contact:   Michael Thompson
;                    tommy@msc.cornell.edu
;
;  Ported to Borland C++ for OS/2 by:
;		     Cy Schubert
;		     cschuber@bcsc02.gov.bc.ca
; ******************************************************************

		MASM
		.486P
		.LALL
		NOSMART
		.MODEL	OS2 LARGE, C
P@IOCODE        segment WORD PUBLIC USE16 'CODE'
		assume  cs:P@IOCODE
		INCLUDE	iopl.inc

;=============================================================================
; These routines must be declared as
;
;       unsigned short _far16 _cdecl inp(unsigned short port);
;       unsigned short _far16 _cdecl inpw(unsigned short port);
;       unsigned short _far16 _cdecl outp(unsigned short, unsigned short);
;       unsigned short _far16 _cdecl outpw(unsigned short, unsigned short);
;
; in the BCOS2 declarations.  The "C" calling convention passes parameters
; on the stack.  I would have been simpler to store the variables in
; registers AX and DX but in order to prove that it could be done,
; parameters are passed on the stack.  The reason for using the "C" calling
; convention is so that registers get popped off the callers stack upon
; return.  This is due to a bug in the Turbo Linker (TLINK).  OS/2
; linkage editors should create a call gate in order to allow non-priviledged
; programs to invoke priviledged programs.  TLINK does this but it does not
; allow for filling in of the number of words to be copied from the
; non-priviledged stack to the priviledged stack.  Therefore parameters must
; be copied over by the application.  This imposes a limitiation on on this
; code.  This code may only be called by less priviledged code.  If code of
; equal priviledge requires to call this code the $IOPL macro must be
; removed.  The short return allows the use of AX only on exit.This should
; be nearly at the limit of the 32->16 call convention.
;
; Compiling and linkage requires these routines to be stored in a DLL so are
; 16 bit.  I could make them 32 bit IF I could get a true protected mode 32
; bit assembler.  Microsoft maybe there, but I refuse to buy their toys
; anymore.
;
; General make process can be viewed in MAKEFILE.
;
; portio.def must contain:
;    LIBRARY PORTIO
;    DESCRIPTION 'Dynamically-linked Run-Time Library for Port Access'
;    PROTMODE
;    CODE PRELOAD EXECUTEONLY
;    STACKSIZE 1024
;
;    SEGMENTS
;     P@IOCODE    CLASS 'CODE' PRELOAD EXECUTEONLY IOPL
;
;    EXPORTS
;     _inp
;     _outp
;     _inpw
;     _outpw
;
; CODE IOPL cannot be specified.  It must be specified in a separate
; Segments statement.  If CODE IOPL is specified, TLINK abends with a
; "general error".  Granting the _TEXT segment also results in a "general
; error" in TLINK.
;=============================================================================



;=============================================================================
; Subroutine to output byte to specified port
;
; Usage:  unsigned short = outp (unsigned short port, unsigned short byte)
;         unsigned short = outpw(unsigned short port, unsigned short word)
;
; Inputs: AX - port
;         DX - contains value to be sent (low byte only for outp)
;
; Output: AX - byte value sent
;=============================================================================
outp            PROC	FAR
		$IOPL	4,outp2
		public	outp
outp		ENDP

outp2 		PROC    NEAR
USES	dx
		assume  ds:nothing,es:nothing
		enterw	0,0
		mov	dx, [bp+6]	   	; get port
		mov	ax, [bp+8]		; get byte
		out     dx,al                   ; And send one byte
		movzx   eax,al                  ; Say didn't send hi
;
		leavew
		ret
;
outp2 		endp

outpw		PROC	FAR
		$IOPL	4,outpw2
		public	outpw
outpw		ENDP

outpw2 		PROC    NEAR
USES	dx
		assume  ds:nothing,es:nothing
		enterw	0,0
;
		mov	dx, [bp+6]		; get port
		mov	ax, [bp+8]		; get byte
		out     dx,ax                   ; And send one word
;
		leavew
		ret
;
outpw2		endp


;=============================================================================
; Subroutine to read input from a specified port
;
; Usage:  unsigned short = inp (unsigned short port)
;         unsigned short = inpw(unsigned short port)
;
; Inputs: AX - port
;
; Output: AX - byte (word) value received
;=============================================================================
inp             PROC	FAR
		$IOPL	2,inp2
		public	inp
inp		ENDP

inp2 		PROC    NEAR
USES	dx
		assume  ds:nothing,es:nothing
		enterw	0,0
;
		mov	dx, [bp+6]		; get port
		in      al,dx                   ; Read the byte
		movzx   eax,al                  ; Clear AH
;
		leavew
		ret
;
inp2 		endp

inpw            PROC	FAR
		$IOPL	2,inpw2
		public	inpw
inpw		ENDP

inpw2 		PROC    NEAR
USES	dx
		assume  ds:nothing,es:nothing
		enterw	0,0
;
		mov	dx, [bp+8]	 	; get port
		in      ax,dx                   ; Read the word
;
		leavew
		ret
;
inpw2 		endp

P@IOCODE                ends
;
		end
