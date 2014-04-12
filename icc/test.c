/* Example program to send a string directly to the printer through I/O port */

#include <stdio.h>
#include "portio.h"

/*---------------------------------------------------------------------------	
-- Outputs one character directly to LPT1 handling necessary handshaking
--
-- Syntax:  void SendChar(char chr)
--
-- Inputs:  chr - character (byte) to output to printer port
--
-- Output:  none
--
-- Returns: none
--
-- Action: Direct output via INP/OUTP to printer
----------------------------------------------------------------------------*/
#define OUTPUTPORT			0x378
#define STATUSPORT			OUTPUTPORT+1
#define CONTROLPORT			OUTPUTPORT+2
#define READY_BIT				0x80				/* Ready flag of StatusPort	*/
#define STROBE_OUT			0x0D				/* Bit set to strobe data out */
#define STROBE_OFF			0x0C				/* Reset of strobe bit			*/
#define LOOPCRITICALCOUNT	10000				/* Times before printing		*/

void SendChar(char chr) {
		
	int LoopCnt=0;									/* Waiting loop counter */
		   
	while ( (inp(STATUSPORT) & READY_BIT) == 0) {
		if (LoopCnt++ > LOOPCRITICALCOUNT) {
			printf("I've apparently been busy for a while\n");
			LoopCnt = 0;
		}
	}

	outp(OUTPUTPORT, chr);						/* Send the character */
	outp(CONTROLPORT, STROBE_OUT);			/* Strobe it out */
	outp(CONTROLPORT, STROBE_OFF);			/* And unstrobe  */

	return;
}

/* ---------------------------------------------------------------------------
-- Routine to send a command string (including potentially nulls) to printer
--
-- Usage:  void SendCommand(char *str)
--
-- Inputs: str - command string
---------------------------------------------------------------------------- */
void SendCommand(char *str) {
	while (*str) SendChar(*(str++));
	return;
}

/* ---------------------------------------------------------------------------
-- Main routine.  Calls SendCommand for single page.
---------------------------------------------------------------------------- */
int main(int argc, char *argv[]) {

	SendCommand("Hi there, I'm a print output\n\r\f");
	return(0);
}
