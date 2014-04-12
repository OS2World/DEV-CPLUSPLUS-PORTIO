#===========================================================================
# This make file will create the general utility files:
#   portio.dll - Dynamic link library containing inp/outp/inpw/outpw
#   portio.lib - Library for resolving references INTO the portio.dll
#   portio.obj - Object file for statically linking inp/outp with programs
#
# It will also build the two example programs
#   test.exe   - Test program to print "hello world" to LPT1 directly
#                using the dynamic link module portio.dll
#   test2.exe  - Test program to print "hello world" to LPT1 directly
#                using statically linked versions of these routines
#
# Other files of interest:
#   portio.h   - Include file with appropriate definitions of inp/...
#   test.c     - The test program (only linking differences with test2)
#
# ICC is used as the C compiler and for invoking the linker.  Map files
# are generated though unnecessary. 
#   
# Software Versions:
#     MASM   - Microsoft    Version 5.1
#     ICC    - IBM CSET/2   Version 1.0   Patch level 42
#     IMPLIB - IBM ToolKt20 Version 2.00
#===========================================================================

#--------------------------------------------------
# Set compilers/assemblers and options
#
# ICC options - no logo, all warnings, 486 optimize
# masm options - Preserve case in external names
#--------------------------------------------------
ASM  = masm
CC   = icc
ICC  = -Q+ -W3 -Kb+ -G4
MASM = /Mx


DEFAULT: portio.dll portio.lib test.exe test2.exe

portio.obj : portio.asm
	$(ASM) $(MASM) portio.asm;

portio.dll : portio.obj portio.def
	$(CC) $(ICC) /Fmportio.map /Feportio.dll portio.obj portio.def

portio.lib : portio.def
	implib portio.lib portio.def

test.obj : test.c
	$(CC) $(ICC) -c test.c

test.exe : test.obj portio.lib
	$(CC) $(ICC) -Fmtest.map -Fetest.exe $**

test2.exe : test.obj portio.obj test2.def
	$(CC) $(ICC) -Fmtest2.map -Fetest2.exe $**
