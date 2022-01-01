	.data
cad:	.asciz "Texto de prueba: cuantas letras distintas hay?"
EoD:	.ascii "E" @E para Encriptar, D para Desencriptar
sem:	.word 6	@sustituir X por un número cualquiera entre 0-31 para establecer la semilla
vec:	.word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 @intento de vector

	.text
@-----------------------------------------------------------------------------------------------------------------
@ Programa invocador
@-----------------------------------------------------------------------------------------------------------------
@
@  r0= dirección de la cadena        r1= caracter actual de la cadena    r2= semilla          r3= dirección del vector      r4= "E" o "D"     r5= posición   
@  r6=0xDF           r7=letraencriptada o desencriptada
@  
@-----------------------------------------------------------------------------------------------------------------
main:	ldr r0, =cad
	ldr r4, =EoD
	ldrb r4, [r4]
	ldr r2, =sem
	ldr r2, [r2]
	ldr r3, =vec
	mov r5, #0

	mov r6, #0xDF
	and r4, r6 @Para poner la letra que haya en r1 en mayúscula
	cmp r4, #'E' @Comparamos si es una E para encriptar
	beq Enc
	cmp r4, #'D' @Comparamos si es una D para desencriptar
	beq Desnc
	b error
	b fin
Enc:  
	@hacemos un while para recorrer toda la cadena que queremos encriptar
	@El problema en python sería:  
	@
	@ semilla = 6
	@ vector = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
	@ cadena = "Texto de prueba: cuantas letras distintas hay?"
	@ posición = 0
	@ caracteractual= direccióncadena[posición]
	@ cadSolución= []
	@
	@ while caracteractual != 0:
	@
	@ 	if caracteractual < "A" and  caracteractual > "Z":           ( el caracter actual no es una letra)
	@		print ( caracteractual + posición )
	@		
	@
	@	else:     (si es una letra empezamos a encriptar)
	@	
	@		letraencriptada= encriptar(semilla, vector, caracteractual)  
	@		cadsolución += letraencriptada
	@		
	@		if semilla = 31:
	@			semilla = 0
	@
	@		else:
	@			semilla += 1           (para que pase al siguiente contenido del vector)
	@	
	@	posición += 1
	@	caracteractual= cadena[posición]        (cogemos el siguiente caracter de la cadena)
	
	ldrb r1, [r0, r5]     @el caracter actual de la cadena se guarda en r1
while1:	cmp r1, #0       @lo comparamos con cero ya que la cadena está guardada en ascii y esp quiere decir que cuando lleguemos a el caracter 0 se habrá acabado la cadena
	beq finWhile1
	and r1, r6     @r6 = 0xDF
if1:	cmp r1, #'A'
	blt noletra
	cmp r1, #'Z'
	bgt noletra
	b else1
noletra:
	@imprimimos en el simulador de pantalla la posición (r5) y imprimimos el caracter actual (r1)
	b finIE
else1:	
	push{r0,r2}
	bl encriptar
	pop{r0}
	ldrb r7, [r2]    @guardamos la letra encriptada en r7
	@tenemos que guardar la letra encriptada en un word o en una cadena que será la cadena solución 
	pop{r2}

if2:	cmp r2, #31   @la semilla solo puede llegar hasta 31
	beq limite
	b else2
limite:	mov r2, #0 
	b FinIE2

else2:	add r2, #1

finIE2:	
finIE:
	add r5, #1
	ldr r1, [r0, r5]
	b while1


finWhile1:	b seguir


Desnc:
	@hacemos un while para recorrer toda la cadena que queremos desencriptar 
	@El problema en python sería: 
	@
	@ semilla = 6
	@ vector = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
	@ cadena = "Texto de prueba: cuantas letras distintas hay?"
	@ posición = 0
	@ caracteractual= direccióncadena[posición]
	@ cadSolución= []
	@
	@ while caracteractual != 0:
	@
	@	letradesencriptada= desencriptar(semilla, vector, caracteractual)  
	@	cadsolución += letradesencriptada
	@		
	@	if semilla = 31:
	@		semilla = 0
	@
	@	else:
	@		semilla += 1           (para que pase al siguiente contenido del vector)
	@	
	@	posición += 1
	@	caracteractual= cadena[posición]        (cogemos el siguiente caracter de la cadena)
Desnc:
	ldrb r1, [r0, r5]     @el caracter actual de la cadena se guarda en r1
while2:	cmp r1, #0       @lo comparamos con cero ya que la cadena está guardada en ascii y esp quiere decir que cuando lleguemos a el caracter 0 se habrá acabado la cadena
	beq finWhile2
	and r1, r6     @r6 = 0xDF
	
	push{r0,r2}
	bl desencriptar
	pop{r0}
	ldrb r7, [r2]    @guardamos la letra encriptada en r7
	@tenemos que guardar la letra encriptada en un word o en una cadena que será la cadena solución 
	pop{r2}

if3:	cmp r2, #31   @la semilla solo puede llegar hasta 31
	beq limite2
	b else3
limite2:	mov r2, #0 
	b FinIE3

else3:	add r2, #1

finIE3:	
	add r5, #1
	ldr r1, [r0, r5]
	b while2


finWhile2:	b seguir

error:   @cuando no nos dan la letra E ni D
	@ escribir un mensaje de error en pantalla 
	mov pc, lr

seguir:	
@ ya tenemos la cadena solución que estará encriptada o desencriptada dependiendo lo que nos hayan pedido.
@ Ahora hay que monstrar en pantalla la cadena y ya estaría el problema
@
@ El problema en python sería:
@ print( cadsolución )

fin:	wfi

@---------------------------------------------
@ Subrutina encriptar
@----------------------------------------------
@
@   r0= dirección de la cadena  r1= caracter actual de la cadena     r2= semilla      r3= dirección del vector       
@
@ VAMOS A APILAR R0 (SERÁ DONDE SE GUARDE EL CONTENIDO DE VECTOR) Y R2 (PARA LA LETRA ENCRIPTADA)
@
@ Primero cogemos la semilla (r2), cogemos la dirección del vector (r3) y guarda el registro r0, el contenido de la posición que tenga el valor de la semilla en el vector.
@ Cogemos el caracter actual (r1) de la cadena y le sumamos el contenido de r0 (lo que hay en la posición del vector).
@
@ El problema en python sería:
@  
@ def encriptar(semilla, vector, caracteractual):
@	contenidovector= vector[semilla]
@	letradesencriptada= caracteractual + contidovector
@	return letradesencriptada


encriptar: 
	ldr r0, [r3, r2]
	add r2, r0, r1
	mov pc, lr
	
@---------------------------------------------
@ Subrutina desencriptar
@----------------------------------------------
@
@   r0= dirección de la cadena  r1= caracter actual de la cadena     r2= semilla      r3= dirección del vector       
@
@ VAMOS A APILAR R0 (SERÁ DONDE SE GUARDE EL CONTENIDO DE VECTOR) Y R2 (PARA LA LETRA ENCRIPTADA)
@
@ Primero cogemos la semilla (r2), cogemos la dirección del vector (r3) y guarda el registro r0, el contenido de la posición que tenga el valor de la semilla en el vector.
@ Cogemos el caracter actual de la cadena y le restamos el contenido de r0 (lo que hay en la posición del vector).
@
@@ El problema en python sería:
@  
@ def encriptar(semilla, vector, caracteractual):
@	contenidovector= vector[semilla]
@	letradesencriptada= caracteractual - contenidovector
@	return letradesencriptada

desencriptar: 
	ldr r0, [r3, r2]
	sub r2, r0, r1
	mov pc, lr
