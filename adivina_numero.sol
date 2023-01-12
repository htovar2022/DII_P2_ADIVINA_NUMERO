// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

// Referencias: 
// https://medium.com/@lianxiongdi/smart-contract-development-with-solidity-3-number-guessing-game-b3e4c3f1e269

// SmartContract de un minijuego sobre "adivinar el numero ganador". El funcionamiento es el siguiente:

// El propietario del minijuego antes de desplegar el contrato debe aportar 0.5 ether como bote del premio
// Seguido de establecer un numero entre 1 y 10 para adivinar
// El bote del premio es acumulable con las tasas de participaciones de los participantes
// Para participar la tasa es de 0.2 ehter.
// Los participantes tendran un maximo de 3 intentos para adivinar el numero que ha pensado el propietario
// Si en tres intentos no han logrado adivinar el numero, entonces el bote se lo queda el propietario
// En caso de que algun participante adivine el numero, entonces se le realiza la transferencia del bote.


contract AdivinaNumero{

	// Declaracion de variable
	uint8 private numero_ganador; 		// Numero premiado
	address public propietario_juego;
	address public ganador_juego;
	uint public bote; 					// Bote total del juego. El bote del premio es acumulable es decir,
										// El propietario paga inicialmente 0.3 ether y se acumula con cada participacion de los jugadores
	uint intentos = 0;					// Numero de intentos para adivinar el numero, maximo 3	
	bool juego_en_marcha = true;		// Variable bandera, se pone a false cuando el juego acaba

// Antes de desplegar el contrato, el propietario debe poner 
// un bote inicial de 0.3 ether como premio y fijar el número a adivinar

	constructor(uint8 numero) payable{

		require( numero > 0 && numero <= 10, "El numero debe estar entre 1 y 10");
		require( msg.value == 0.5 ether, "La cantidad inicial del bote es de 0.5 ether");
		propietario_juego = msg.sender;
		numero_ganador = numero;		// Igualar el numero introducido es el numero a adivinar
	}

// Los participantes pueden participar pagando 0.1 ether y adivinar el numero para llevarse el bote
	
	function adivinar(uint8 numero) payable public{

		bote = address(this).balance;	// Acumular bote con las participaciones
		require( numero > 0 && numero <= 10, "El numero esta entre 1 y 10");
		require( juego_en_marcha == true, "Se acabo el juego");	// Para poder adivinar la variable bandera debe estar activa
		require( msg.value == 0.2 ether, "La tasa de partipacion es de 0.2 ehter");
		require ( msg.sender != propietario_juego, "El propietario no puede participar" );

		intentos+=1; // Sumar un intento, máximo 3 intentos para adivinar el numero

		// Si el participante ha acertado el numero ganador
		if (numero == numero_ganador){

			ganador_juego = msg.sender;
			payable(ganador_juego).transfer(bote);	// Transferir bote del premio al ganador
			juego_en_marcha = false; // Desactivar variable bandera. Se acabó el juego.
		}
		// Si en 3 intentos nadie ha logrado adivinar el numero
		else if (intentos == 3){

			payable(propietario_juego).transfer(bote); //  El bote se lo queda el propietario
			juego_en_marcha = false; // Desactivar variable bandera
		}

	}

}