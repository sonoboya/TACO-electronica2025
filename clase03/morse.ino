//LED_MORSE, Andres Cruz, 23 agosto 2025
//Convierte cualquier texto a morse en pulsos de led
// https://es.wikipedia.org/wiki/Frecuencia_de_aparici%C3%B3n_de_letras
const int tiempoPunto   = 300 ;
const int tiempoRaya    = tiempoPunto*3;
const int tiempoLetra   = tiempoPunto*2; //3 veces 1U pero se agraga con intracaracter 
const int tiempoEspacio = tiempoPunto*6;//7 veces 1U pero se agraga con intracaracter 

const int LED_PIN = LED_BUILTIN;

const char poema[]      = {"SOS"};
const int poemaLength   = sizeof(poema) / sizeof(poema[0]);

void setup() {
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  for (int i = 0; i < poemaLength-1; i++) {
    morse(poema[i]);
}
  delay(tiempoPunto*20); //
}



void morse(char x) {
//Concertir minusculas a mayusculas
  if( x >= 'a' && x <= 'z'){
    x = x - ' ';
  }
//Se ordena segun el uso en español
//e, a, o, s, r, n, i, d, l, c, t, u, m, p, b, g, v, y, q, h, f, z, j, ñ, x, k, w. 

  switch (x) {

    case 'E'://E .
      punto();
      delay(tiempoLetra);
      break;
    case 'A'://A .-
      punto();
      raya();
      delay(tiempoLetra);
      break;
    case 'O'://O ---
      raya();
      raya();
      raya();
      delay(tiempoLetra);
      break;
    case 'S'://S ...
      punto();
      punto();
      punto();
      delay(tiempoLetra);
      break;
    case 'R'://R .-.
      punto();
      raya();
      punto();
      delay(tiempoLetra);
      break;
    case 'N'://N -.
      raya();
      punto();
      delay(tiempoLetra);
      break;
    case 'I'://I ..
      punto();
      punto();
      delay(tiempoLetra);
      break;
    case 'D'://D -..
      raya();
      punto();
      punto();
      delay(tiempoLetra);
      break;
    case 'L'://L .-..
      punto();
      raya();
      punto();
      punto();
      delay(tiempoLetra);
      break;
    case 'C'://C -.-.
      raya();
      punto();
      raya();
      punto();
      delay(tiempoLetra);
      break;
    case 'T'://T -
      raya();
      delay(tiempoLetra);
      break;
    case 'U'://U ..-
      punto();
      punto();
      raya();
      delay(tiempoLetra);
      break;
    case 'M'://M --
      raya();
      raya();
      delay(tiempoLetra);
      break;
    case 'P'://P .--.
      punto();
      raya();
      raya();
      punto();
      delay(tiempoLetra);
      break;
    case 'B'://B -...
      raya();
      punto();
      punto();
      punto();
      delay(tiempoLetra);
      break;
    case 'G'://G --.
      raya();
      raya();
      punto();
      delay(tiempoLetra);
      break;
    case 'V'://V ...-
      punto();
      punto();
      punto();
      raya();
      delay(tiempoLetra);
      break;
    case 'Y'://Y -.--
      raya();
      punto();
      raya();
      raya();
      delay(tiempoLetra);
      break;
    case 'Q'://Q --.-
      raya();
      raya();
      punto();
      raya();
      delay(tiempoLetra);
      break;
    case 'H'://H ....
      punto();
      punto();
      punto();
      punto();
      delay(tiempoLetra);
      break;
    case 'F'://F ..-.
      punto();
      punto();
      raya();
      punto();
      delay(tiempoLetra);
      break;
    case 'Z'://Z --..
      raya();
      raya();
      punto();
      punto();
      delay(tiempoLetra);
      break;
        case 'J'://J .---
      punto();
      raya();
      raya();
      raya();
      delay(tiempoLetra);
      break;
    case 'X'://X -..-
      raya();
      punto();
      punto();
      raya();
      delay(tiempoLetra);
      break;
    case 'K'://K -.-
      raya();
      punto();
      raya();
      delay(tiempoLetra);
      break;
    case 'W'://W .--
      punto();
      raya();
      raya();
      delay(tiempoLetra);
      break;
    //------------------------------------------
    
    case '0':
    raya();
    raya();
    raya();
    raya();
    raya();
    delay(tiempoLetra);
    break;
    case '1':
    punto();
    raya();
    raya();
    raya();
    raya();
    delay(tiempoLetra);
    break;
    case '2':
    punto();
    punto();
    raya();
    raya();
    raya();
    delay(tiempoLetra);
    break;
    case '3':
    punto();
    punto();
    punto();
    raya();
    raya();
    delay(tiempoLetra);
    break;
    case '4':
    punto();
    punto();
    punto();
    punto();
    raya();
    delay(tiempoLetra);
    break;
    case '5':
    punto();
    punto();
    punto();
    punto();
    punto();
    delay(tiempoLetra);
    break;
    case '6':
    raya();
    punto();
    punto();
    punto();
    punto();
    delay(tiempoLetra);
    break;
    case '7':
    raya();
    raya();
    punto();
    punto();
    punto();
    delay(tiempoLetra);
    break;
    case '8':
    raya();
    raya();
    raya();
    punto();
    punto();
    delay(tiempoLetra);
    break;
    case '9':
    raya();
    raya();
    raya();
    raya();
    punto();
    delay(tiempoLetra);
    break;

    case '.':
    punto();
    raya();
    punto();
    raya();
    punto();
    raya();
    delay(tiempoLetra);
    break;
    case ',':
    raya();
    raya();
    punto();
    punto();
    raya();
    raya();
    delay(tiempoLetra);
    break;
    case ';':
    raya();
    punto();
    raya();
    punto();
    raya();
    punto();
    delay(tiempoLetra);
    break;
    case ':':
    raya();
    raya();
    raya();
    punto();
    punto();
    punto();
    delay(tiempoLetra);
    break;
    case '?':
    punto();
    punto();
    raya();
    raya();
    punto();
    punto();
    delay(tiempoLetra);
    break;
    case '!':
    raya();
    punto();
    raya();
    punto();
    raya();
    raya();
    delay(tiempoLetra);
    break;
    case '"':
    punto();
    raya();
    punto();
    punto();
    raya();
    punto();
    delay(tiempoLetra);
    break;
    case 39:
    case 145: //''
    case 146:
    punto();
    raya();
    raya();
    raya();
    raya();
    punto();
    delay(tiempoLetra);
    break;
    case '=':
    raya();
    punto();
    punto();
    punto();
    raya();
    delay(tiempoLetra);
    break;
    case '(':
    raya();
    punto();
    raya();
    raya();
    punto();
    delay(tiempoLetra);
    break;
    case ')':
    raya();
    punto();
    raya();
    raya();
    punto();
    raya();
    delay(tiempoLetra);
    break;
    case '+':
    punto();
    raya();
    punto();
    raya();
    punto();
    delay(tiempoLetra);
    break;
    case '-':
    raya();
    punto();
    punto();
    punto();
    punto();
    raya();
    delay(tiempoLetra);
    break;
    case '/':
    raya();
    punto();
    punto();
    raya();
    punto();
    delay(tiempoLetra);
    break;
    case '&':
    punto();
    raya();
    punto();
    punto();
    punto();
    delay(tiempoLetra);
    break;
    case '@':
    punto();
    raya();
    raya();
    punto();
    raya();
    punto();
    delay(tiempoLetra);
    break;
    case '¿':
    punto();
    punto();
    raya();
    punto();
    raya();
    delay(tiempoLetra);
    break;
    case '_':
    punto();
    punto();
    raya();
    raya();
    punto();
    raya();
    delay(tiempoLetra);
    break;
    case '$':
    punto();
    punto();
    punto();
    raya();
    punto();
    punto();
    raya();
    delay(tiempoLetra);
    break;

    case -61: //ñ
    raya();
    raya();
    punto();
    raya();
    raya();
    delay(tiempoLetra);
    break;


    default:
    delay(tiempoEspacio);
    break;


  }
}


void punto(){
  digitalWrite(LED_PIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  delay(tiempoPunto);                      // wait for a second
  digitalWrite(LED_PIN, LOW);   // turn the LED off by making the voltage LOW
  delay(tiempoPunto);    
}

void raya(){
    digitalWrite(LED_PIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  delay(tiempoRaya);                      // wait for a second
  digitalWrite(LED_PIN, LOW);   // turn the LED off by making the voltage LOW
  delay(tiempoPunto);
}



