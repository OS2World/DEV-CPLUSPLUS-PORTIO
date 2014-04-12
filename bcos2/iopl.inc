;; The $IOPL macro is designed to fill a gap left by Borland's Turbo Linker
;; (TLINK) when creating IOPL code segments.  Apparently TLINK fills the
;; count field of the gate descriptor with zero thereby disallowing the
;; passing of parameters from non-IOPL code to IOPL code.  This macro
;; copies the parameters from a non-priviledged stack to a priviledged
;; stack as the hardware would as if the count field were filled.  The only
;; limitation is that if this macro is used it assumes that the routine
;; is called by a non-priviledged routine.  It will not work when this
;; code is called by priviledged code.  Once Borland has TLINK fixed this
;; macro will no longer be required.
;;
;; To use the macro code the following:
;;
;;	$IOPL #_of_bytes_to_copy,program_to_call
;;
;;		INCLUDE	iopl.inc
;;entry_point   PROC	FAR
;;		$IOPL	number_of_bytes,called_proc
;;		public	entry_point
;;outp		ENDP
;;
;;called_proc	PROC    NEAR
;;		.
;;		.
;;		.
;;		ret
;;
;;outp2 		endp
;;
;;
$IOPL	MACRO	numbytes,entry_point
	enterw	numbytes,0		; stack frame for parameters
	push	cx
	push	si
	push	di
	push	ds
	push	es
	mov	cx,numbytes
	lds	si,[bp + 6]		; non-priviledged stack
	mov	di,ss			; priviledged stack
	mov	es,di
	mov	di,bp
	sub	di, numbytes
	rep	movsb			; copy stack
	pop	es
	pop	ds
	pop	di
	pop	si
	pop	cx
	call	entry_point		; call program
	add	sp,numbytes
	leavew
	ret
	ENDM
