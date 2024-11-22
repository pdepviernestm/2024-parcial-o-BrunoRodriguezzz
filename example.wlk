// PERSONA / GRUPO
class Persona {
  var property edad
  const emociones

  method esAdolescente() = edad.between(12, 19)

  method agregarEmocion(emocion) {
    emociones.add(emocion)
  }

  method estaPorExplotar() = emociones.all({emocion => emocion.puedeLiberarse()})

  method vivirEvento(evento) {
    emociones.forEach({emocion => emocion.liberarse(evento)})
  }
}

class Grupo {
  const integrantes

  method agregarMiembro(miembro) {integrantes.add(miembro)}
  method vivirEvento(evento) {integrantes.forEach({miembro => miembro.vivirEvento(evento)})}
}

// EVENTOS
class Evento {
  var property impacto
  const property descripcion
}

// EMOCIONES
class Emocion {
  const eventosExperimentados = []
  var property fuiLiberada = false
  var property intensidad

  method eventosExperimentados() = eventosExperimentados.size()
  method puedeLiberarse() = intensidad > manejoIntensidad.intensidadElevada() && !fuiLiberada
  method liberarse(evento) {
    if(self.puedeLiberarse()) {
      self.efectoLiberarse(evento)
      fuiLiberada = true
    }
    eventosExperimentados.add(evento)
    // Considero que se agrega como evento experimentado despues de vivirlo
  }
  method efectoLiberarse(evento) {
    intensidad =- evento.impacto()
    // Como solo aclara que alegría no puede tener intensidad negativa interpreto que el resto si
  }
}

// Con este objeto manejo el valor de la intensidadElevada que es el mismo para todos
object manejoIntensidad {
  var property intensidadElevada = 300 // Valor de ejemplo
}

class Furia inherits Emocion(intensidad = 100) {
  var palabrotas // Lista de string

  method agregarPalabrota(palabra) {palabrotas.add(palabra)}
  method olvidarPalabrota() {palabrotas = palabrotas.drop(1)}
  method conozcoPalabrota() = palabrotas.any({palabra => palabra.size() > 7})
  method cuantasPalabrotasConozco() = palabrotas.size() //Es para el segundo test

  override method puedeLiberarse() = super() && self.conozcoPalabrota()
  override method efectoLiberarse(evento) {
    super(evento)
    self.olvidarPalabrota()
  }
}

class Alegria inherits Emocion() {
  override method efectoLiberarse(evento){
    const resultadoResta = intensidad - evento.impacto()
    intensidad = resultadoResta.abs()
  }
  override method puedeLiberarse() = super() && self.eventosExperimentados().even()
}

class Tristeza inherits Emocion() {
  var property causa = "melancolia"
  
  override method puedeLiberarse() = super() && causa != "melancolia"
  override method efectoLiberarse(evento) {
    super(evento)
    causa = evento.descripcion()
  }
}

class EmocionComun inherits Emocion() {
  override method puedeLiberarse() = super() && eventosExperimentados > intensidad
}

// En este caso desagrado y temor son representadas por EmocionComun

// INTENSAMENTE 2

class Ansiedad inherits Emocion(intensidad = 150) {
  var property paranoia = 100

  override method puedeLiberarse() = paranoia > intensidad
  override method efectoLiberarse(evento) {
    paranoia -= 10
    intensidad += 40
  }
  override method liberarse(evento) {
    if(self.puedeLiberarse()) {self.efectoLiberarse(evento)}
    else {paranoia += 30}
  }
}

// Polimorfismo: Este concepto de fue utilidad ya que me permite tratar a todas las emociones de la misma
// forma a pesar de que la implementación de sus métodos sea distinta. Todo esto es gracias a la existencia
// de un contrato que define que métodos deben ser implementados y con que parametros. 
// Herencia: La herencia fue de gran ayuda al modelar las clases ya que estas tienen muchas características
// en común lo que muestran como están relacionadas y en caso de no tener herencia debería escribir 
// el mismo código varias veces.