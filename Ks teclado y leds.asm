
				LIST P=16F887
				INCLUDE <p16f887.inc>
;Declaracion variables
tecla						EQU 0x20
num_tecla					EQU 0x21
barrido_display 			EQU 0x22
;auxiliar					EQU 0x23
ayuda						EQU 0x24
cont1_pausa					EQU 0x25
cont2_pausa					EQU 0X26
cont3_pausa					EQU 0X27
contador_barrido_display	EQU 0x28
display1					EQU 0x29
display2					EQU 0x2A
display3					EQU 0x2B
display4					EQU 0x2C
display5					EQU 0x2D
display6					EQU 0x2F



ORG 0X00
goto INICIO

ORG 0x10

INICIO:
	;inicializo variable barrido y num_tecla
	clrf contador_barrido_display
	clrf barrido_display
	clrf num_tecla
	clrf ayuda
	clrf cont1_pausa
	clrf cont2_pausa
	movlw 0x01
	movwf cont3_pausa
;	clrf auxiliar	

	;Banco 3
	bsf STATUS,RP0
	bsf STATUS,RP1

	;Valores digitales Puerto B
	clrf ANSELH		
	bcf OPTION_REG,NOT_RBPU

	;Banco 2
	bcf STATUS,RP1
	bsf STATUS,RP0

	;Mitad entradas(1) mitad salidas(0)
	movlw 0xF0
	movwf TRISB

	;Salidas puerto C puerto D
	clrf TRISC
	clrf TRISD

	;Banco 0
	bcf STATUS,RP0
	bcf STATUS,RP1

	;PORT B mitad en alto(entradas) y mitad el bajo(salidas)
	movlw 0xF0
	movwf PORTB

	;En bajo puerto C y con el contador puerto D
	clrf PORTC
	movlw 0xFF
	movwf PORTC
	movwf display1
	movwf display2
	movwf display3
	movwf display4
	movwf display5
	movwf display6
	clrf PORTD


BARRIDO_DISPLAY:
		clrf num_tecla
		call TABLA_POSICIONES
		movwf barrido_display
		movwf PORTD		
		
		;si es el display1
		movlw 0x00
		xorwf contador_barrido_display,W
		btfss STATUS,Z
		goto DISPLAY2
		movfw display1
		movwf PORTC
		goto SIGUIENTE_DISPLAY


DISPLAY2:		
		;si es el display2
		movlw 0x01
		xorwf contador_barrido_display,W
		btfss STATUS,Z
		goto DISPLAY3
		movfw display2
		movwf PORTC
		goto SIGUIENTE_DISPLAY

DISPLAY3:
		;si es el display3
		movlw 0x02
		xorwf contador_barrido_display,W
		btfss STATUS,Z
		goto DISPLAY4
		movfw display3
		movwf PORTC
		goto SIGUIENTE_DISPLAY

DISPLAY4:
		;si es el display4
		movlw 0x03
		xorwf contador_barrido_display,W
		btfss STATUS,Z
		goto DISPLAY5
		movfw display4
		movwf PORTC
		goto SIGUIENTE_DISPLAY

DISPLAY5
		;si es el display5
		movlw 0x04
		xorwf contador_barrido_display,W
		btfss STATUS,Z
		goto DISPLAY6
		movfw display5
		movwf PORTC
		goto SIGUIENTE_DISPLAY

DISPLAY6
		;si es el display6
		movfw display6
		movwf PORTC


SIGUIENTE_DISPLAY
		incf contador_barrido_display,F	
		

		;comparo si no a cambiado, es decir sigue siendo 0xF0
		movlw 0xF0
		xorwf PORTB,W
		btfss STATUS,Z
		goto PASO2
		goto RETARDO

PASO2:
		;saco los valores de PORTB a tecla
		movwf tecla

		;cambio entradas por salidas en PORTB
				;Banco 2
				bcf STATUS,RP1
				bsf STATUS,RP0

				;Mitad entradas(1) mitad salidas(0) al revez
				movlw 0x0F
				movwf TRISB

				;Banco 0
				bcf STATUS,RP0
				bcf STATUS,RP1

				;PORT B mitad en alto(entradas) y mitad el bajo(salidas)
				movlw 0x0F
				movwf PORTB

		;Hago XOR con 0xF0 para ver que valor a cambiado nivle bajo
		movlw 0x0F
		xorwf PORTB,W

		;Hago OR con tecla para tener en tecla los bits que se an presionado
		iorwf tecla,F
	
		movlw 0xFF
		movwf PORTC	

		movlw 0x03
		movwf cont3_pausa
PAUSA
		decfsz cont1_pausa
		goto PAUSA
		decfsz cont2_pausa
		goto PAUSA
		decfsz cont3_pausa
		goto PAUSA

		clrf cont1_pausa
		clrf cont2_pausa


		;Comparo de uno en uno los posibles valores para tecla
		
			;Tecla 16(MAS)
		movlw 0x88
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 12(MENOS)
		incf num_tecla,F
		movlw 0x84
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 8(POR)
		incf num_tecla,F
		movlw 0x82
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 4(DIVIDIDO)
		incf num_tecla,F
		movlw 0x81
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 15(IGUAL)
		incf num_tecla,F
		movlw 0x48
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
	
		;Tecla 11(numero 3)
		incf num_tecla,F
		movlw 0x44
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 7(numero 6)
		incf num_tecla,F
		movlw 0x42
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 3(numero 9)
		incf num_tecla,F
		movlw 0x41
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 14(numero 0)
		incf num_tecla,F
		movlw 0x28
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 10(numero 2)
		incf num_tecla,F
		movlw 0x24
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA

		;Tecla 6(numero 5)
		incf num_tecla,F
		movlw 0x22
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 2(numero 8)
		incf num_tecla,F
		movlw 0x21
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
	
		;Tecla 13(ON OFF)
		incf num_tecla,F
		movlw 0x18
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 9(numero 1)
		incf num_tecla,F
		movlw 0x14
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 5(numero 4)
		incf num_tecla,F
		movlw 0x12
		xorwf tecla,W
		btfsc STATUS,Z
		goto FIN_PREGUNTA
		
		;Tecla 1(numero 7)
		incf num_tecla,F
		goto FIN_PREGUNTA
		
		
	

FIN_PREGUNTA

;recorro los datos de la pantalla de displays

	;recorro el display 5 al 6
	movfw display5
	movwf display6
	;recorro el display 4 al 5
	movfw display4
	movwf display5
	;recorro el display 3 al 4
	movfw display3
	movwf display4
	;recorro el display 2 al 3
	movfw display2
	movwf display3
	;recorro el display 1 al 2
	movfw display1
	movwf display2
	

;Cargamos en el display1 el valor segun nuestra tabla	

	call TABLA_DIGITOS
	movwf ayuda	
	comf ayuda,W	
	movwf display1
	goto RETARDO
		

TABLA_POSICIONES
		;Incremento la posicion de barrido de display de tecla al PCL
		movf contador_barrido_display,W
		addwf PCL,f

		retlw 0x20		;valor posicion 1
		retlw 0x10		;valor posicion 2
		retlw 0x08		;valor posicion 3
		retlw 0x04		;valor posicion 4
		retlw 0x02		;valor posicion 5
		retlw 0x01		;valor posicion 6
		clrf contador_barrido_display
		retlw 0x20
			 


TABLA_DIGITOS
		;Incremento el numero de tecla al PCL
		movf num_tecla,W
		addwf PCL,f 
	
		;tabla con numeros segun la tecla

		;Columna 4 de abajo hacia arriba
		retlw 0xE 		; valor para mas
		retlw 0x01 		; valor para menos
		retlw 0x37 		; valor para por
		retlw 0x49 		; valor para dividiendo
		;Columna 3 de abajo hacia arriba
		retlw 0x05 		; valor para igual
		retlw 0x4F 		; 3 en código 7 segmentos
		retlw 0x7D 		; 6 en código 7 segmentos
		retlw 0x6F 		; 9 en código 7 segmentos
		;Columna 2 de abajo hacia arriba
		retlw 0x3F 		; 0 en código 7 segmentos	
		retlw 0x5B 		; 2 en código 7 segmentos
		retlw 0x6D 		; 5 en código 7 segmentos
		retlw 0x7F 		; 8 en código 7 segmentos
		;Columna 1 de abajo hacia arriba
		retlw 0x64 		; valor para on/off
		retlw 0x06 		; 1 en código 7 segmentos		
		retlw 0x66 		; 4 en código 7 segmentos	
		retlw 0x07 		; 7 en código 7 segmentos
		

RETARDO
		;retardo de 0.5 segundos aprox
		decfsz cont1_pausa
		goto RETARDO
	;	decfsz cont2_pausa
	;	goto RETARDO
	;	decfsz cont3_pausa
	;	goto RETARDO
		clrf cont1_pausa
		movlw 0x08
		movwf cont2_pausa
	
		movlw 0xFF
		movwf PORTC	

		clrf cont1_pausa
		clrf cont2_pausa
	
		;Banco 2
		bcf STATUS,RP1
		bsf STATUS,RP0

		;Mitad entradas(1) mitad salidas(0)
		movlw 0xF0
		movwf TRISB
	
		;Banco 0
		bcf STATUS,RP0
		bcf STATUS,RP1
		
		
		;PORT B mitad en alto(entradas) y mitad el bajo(salidas)
		movlw 0xF0
		movwf PORTB

		goto BARRIDO_DISPLAY
	
		

END