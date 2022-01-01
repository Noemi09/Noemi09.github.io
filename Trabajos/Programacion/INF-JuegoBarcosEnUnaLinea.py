#Los barcos se sitúan en una línea y solo pueden estar en horizontal.
#Se situarán: 1 portaaviones (3 cuadros); 2 cruceros (2 cuadros); 3 destructores (1 cuadro).
#Longitud del mapa: 25 cuadrados.
#Jugador GANA si hunde todos los barcos antes de 15 tiradas.
#Jugador PIERDE si llega a 15 tiradas y no ha undido todos los barcos.
#Tirada del jugador:NÚMERO ENTRE 1 Y 25 que indica la casilla a la que se dispara.
#El juego debe dibujar las 25 casillas indicando con "-" casilla con agua/casilla que no se ha disparado y una casilla con "X" si se ha tocado un barco anteriormente o lo ha hundido.
#Además deberá decir "TOCADO" o "AGUA" en cada jugada. (jamás "UNDIDO", ya que complica el juego y no dar pistas).
#La situación de los barcos tiene que estar especificada de antemano en el programa.

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#Introducción al juego:
print('El Juego de los Barcos en una Línea.')

print('MAPA: el mapa consta de 25 cuadrados en una línea \
horizontal donde se encuentra un portaaviones (de 3 cuadros),\
dos cruceros(de 2 cuadros cada uno) y 3 destructores \
(de 1 cuadro cada uno).')


print('Un ejemplo de un mapa seria este: --XX--X-X---XX----XXX--X-(las X representan los barcos que se encuentran \
ocultos al empezar la partida)')

print('REGLAS DEL JUEGO: tu misión es localizar todos los barcos con un máximo de 15 tiradas. Si en este límite de \
tiradas no consigues encontrar todos los barcos, pierdes.')

print('¡EMPECEMOS!')

#Datos:

mapa=['-']*25
    #barcos= '----XX--X-X----XX-X---XXX'

#Juego:
tirada= 1
X_encontradas=0
barcos= [5,6,9,11,16,17,19,23,24,25] #Elementos donde hay barcos(X)

while tirada <= 15:

    jugada= int(input('Tirada {0}.Introduce jugada: '.format(tirada)))

    while jugada < 1 or jugada > 25 :
        jugada=int(input('La jugada se encuentra entre 1 y 25: '.format(tirada)))

    if jugada in barcos:

        mapa[jugada-1]= 'X'

        X_encontradas+=1 #suponiendo de que no me ponen jugadas repetidas.

        print('ENHORABUENA. TOCADO')

        print(mapa)

    else:
        print('LO SIENTO. AGUA')

        print(mapa)

    tirada+= 1

    if X_encontradas == 10:
        print('ENHORABUENA: HAS GANADO.')
        break
    
else:
    print('LO SIENTO: HAS PERDIDO.')








    
