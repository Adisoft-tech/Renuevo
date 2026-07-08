import Foundation

struct SeasonalCollection: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var subtitle: String
    var symbol: String
    var startMonth: Int
    var startDay: Int
    var endMonth: Int
    var endDay: Int
    var quotes: [Quote]

    /// Whether `date` falls within this collection's month/day range, wrapping
    /// across year-end for ranges like Dec 18 → Jan 6.
    func isActive(on date: Date) -> Bool {
        let components = Calendar.current.dateComponents([.month, .day], from: date)
        guard let month = components.month, let day = components.day else { return false }
        let value = month * 100 + day
        let start = startMonth * 100 + startDay
        let end = endMonth * 100 + endDay
        if start <= end {
            return value >= start && value <= end
        } else {
            return value >= start || value <= end
        }
    }
}

enum SeasonalLibrary {
    static let all: [SeasonalCollection] = [
        SeasonalCollection(
            id: "anio-nuevo",
            title: "Un año nuevo, un corazón renovado",
            subtitle: "1–7 de enero",
            symbol: "sparkles",
            startMonth: 1, startDay: 1, endMonth: 1, endDay: 7,
            quotes: [
                Quote(
                    id: 9001,
                    text: "He aquí, yo hago nueva todas las cosas.",
                    reference: "Apocalipsis 21:5",
                    category: .fe,
                    reflection: "Un año nuevo no borra lo vivido, pero sí abre espacio para algo distinto. La renovación que promete este versículo no depende de que el calendario cambie, pero un inicio de año es una buena ocasión para preguntarte con honestidad qué quieres dejar atrás y qué quieres cultivar.",
                    practicalTeaching: "Renovarse no es fingir que el pasado no existió, es decidir qué haces con lo que viene.",
                    question: "Si este año fuera realmente distinto al anterior, ¿qué sería lo primero en cambiar?",
                    action: "Escribe una sola palabra que quieras que defina este año, y una acción concreta que la refleje esta semana.",
                    prayer: "Señor, gracias por este nuevo comienzo. Renueva en mí lo que necesita cambiar y dame constancia para lo que quiero cultivar. Amén."
                ),
                Quote(
                    id: 9002,
                    text: "Encomienda a Jehová tu camino, y confía en él; y él hará.",
                    reference: "Salmos 37:5",
                    category: .fe,
                    reflection: "Al empezar el año solemos llenar la lista de metas por nuestra cuenta, como si todo dependiera solo de la disciplina. Este versículo no pide dejar de planear, pide encomendar el camino — planear con humildad, sabiendo que no todo está en tus manos.",
                    practicalTeaching: "Planea con intención, pero suelta el control absoluto del resultado.",
                    question: "¿Qué meta de este año necesitas encomendar en vez de solo forzar?",
                    action: "Escribe tus 3 metas principales del año y, junto a cada una, entrégala en oración.",
                    prayer: "Padre, este año encomiendo mi camino en tus manos. Ayúdame a caminar con esfuerzo y con confianza a la vez. Amén."
                ),
                Quote(
                    id: 9003,
                    text: "Olvidando ciertamente lo que queda atrás, y extendiéndome a lo que está delante.",
                    reference: "Filipenses 3:13",
                    category: .crecimiento,
                    reflection: "Pablo no dice que el pasado no importó, dice que no se queda viviendo ahí. Hay una diferencia entre aprender del año anterior y quedarte instalado en él, ya sea en la nostalgia o en el arrepentimiento. Extenderte hacia adelante es una decisión activa, no algo que simplemente ocurre con el cambio de calendario.",
                    practicalTeaching: "Aprender del pasado y vivir instalado en él son cosas distintas.",
                    question: "¿Qué de tu año anterior necesitas honrar antes de soltar?",
                    action: "Escribe una cosa que aprendiste el año pasado y una intención concreta para este año que la aplica.",
                    prayer: "Señor, ayúdame a soltar lo que ya cumplió su propósito y a mirar con esperanza lo que viene. Amén."
                ),
            ]
        ),
        SeasonalCollection(
            id: "adviento",
            title: "Adviento: esperando con el corazón despierto",
            subtitle: "18–31 de diciembre",
            symbol: "star.fill",
            startMonth: 12, startDay: 18, endMonth: 12, endDay: 31,
            quotes: [
                Quote(
                    id: 9101,
                    text: "Y llamarás su nombre Emanuel, que traducido es: Dios con nosotros.",
                    reference: "Mateo 1:23",
                    category: .fe,
                    reflection: "En medio del ruido de fin de año — compras, reuniones, balances — esta temporada recuerda algo mucho más simple: Dios decidió no quedarse lejos. Emanuel no es una idea abstracta, es una promesa de cercanía concreta, incluso en medio del caos de diciembre.",
                    practicalTeaching: "La promesa de esta temporada no es un ambiente perfecto, es compañía real en medio del ambiente que sí tienes.",
                    question: "¿Dónde necesitas recordar hoy que no estás enfrentando las cosas solo?",
                    action: "Aparta 10 minutos hoy, en medio del ajetreo de la temporada, solo para estar en silencio y recordar esa cercanía.",
                    prayer: "Señor, gracias porque decidiste estar cerca. En medio del ruido de esta temporada, ayúdame a notar tu compañía. Amén."
                ),
                Quote(
                    id: 9102,
                    text: "No temas, María, porque has hallado gracia delante de Dios.",
                    reference: "Lucas 1:30",
                    category: .fe,
                    reflection: "María recibió una noticia que cambiaría todo, en un momento que ella no había planeado ni pedido. Su respuesta no fue tener todas las respuestas — fue decir que sí en medio de la incertidumbre. Adviento es también esperar sin tener todo resuelto, confiando en que lo inesperado puede traer algo bueno.",
                    practicalTeaching: "No necesitas entenderlo todo para decir que sí a lo que viene.",
                    question: "¿Qué situación inesperada de este año podrías empezar a ver con más apertura que miedo?",
                    action: "Escribe una frase de apertura ('sí, aunque no entienda todo') hacia algo incierto que estás viviendo.",
                    prayer: "Padre, dame la fe de decir sí aunque no tenga todas las respuestas todavía. Amén."
                ),
                Quote(
                    id: 9103,
                    text: "Gloria a Dios en las alturas, y en la tierra paz.",
                    reference: "Lucas 2:14",
                    category: .gratitud,
                    reflection: "La paz que anuncia esta temporada no es la ausencia de una lista de pendientes o de una familia complicada — es una paz que se sostiene en medio de todo eso. Vale la pena buscarla activamente en estos días, en vez de posponerla hasta que 'todo esté en orden', porque nunca lo está del todo.",
                    practicalTeaching: "La paz de esta temporada se busca activamente, no llega sola cuando todo está resuelto.",
                    question: "¿Qué pequeño espacio de paz puedes proteger hoy, en medio del ajetreo de diciembre?",
                    action: "Elige un momento hoy para desconectar del ajetreo y agradecer, aunque sea diez minutos.",
                    prayer: "Señor, en medio de esta temporada ocupada, dame tu paz. Ayúdame a no posponerla hasta que todo esté perfecto. Amén."
                ),
            ]
        ),
    ]

    static func active(on date: Date = Date()) -> SeasonalCollection? {
        all.first { $0.isActive(on: date) }
    }
}
