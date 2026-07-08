import Foundation

extension String {
    /// Lowercased and stripped of accents, so "así me siento" matches "asi" keywords.
    var normalizedForMatching: String {
        folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "es"))
    }
}

enum MoodLibrary {
    /// Looks for the first mood whose keywords appear in the free text the user typed.
    /// Falls back to a general, still-complete response if nothing matches.
    static func respond(to text: String) -> MoodResponse {
        let normalized = text.normalizedForMatching
        for mood in MoodCategory.allCases where mood != .general {
            for keyword in mood.keywords {
                if normalized.contains(keyword.normalizedForMatching) {
                    return responses[mood] ?? responses[.general]!
                }
            }
        }
        return responses[.general]!
    }

    static let responses: [MoodCategory: MoodResponse] = [
        .ansiedad: MoodResponse(
            mood: .ansiedad,
            passage: "Por nada estéis afanosos, sino sean conocidas vuestras peticiones delante de Dios en toda oración y ruego, con acción de gracias.",
            passageReference: "Filipenses 4:6",
            reflection: "La ansiedad suele venir de intentar sostener mentalmente algo que todavía no ha pasado. Este versículo no pide que dejes de sentir preocupación de golpe, invita a algo más concreto: convertir esa preocupación en una petición específica, entregada, en vez de dejarla dando vueltas sin destino.",
            prayer: "Señor, hoy traigo delante de ti esta ansiedad. No sé resolver todo lo que siento, pero te lo entrego. Dame tu paz, que sé que sobrepasa lo que puedo entender. Amén.",
            exercises: [
                "Respira contando: inhala 4 segundos, sostén 4, exhala 6. Repite 5 veces.",
                "Nombra 5 cosas que puedes ver, 4 que puedes tocar y 3 que puedes oír ahora mismo.",
                "Escribe en una sola frase qué es exactamente lo que te preocupa — ponerlo en palabras reduce su tamaño."
            ],
            encouragement: "Lo que sientes ahora es real, pero no es permanente. Un paso a la vez es suficiente por hoy."
        ),
        .tristeza: MoodResponse(
            mood: .tristeza,
            passage: "Bienaventurados los que lloran, porque ellos recibirán consolación.",
            passageReference: "Mateo 5:4",
            reflection: "Este versículo no le pide a la tristeza que se vaya rápido — reconoce que llorar tiene su lugar, y promete que no es el final de la historia. Sentir tristeza no es una falla tuya; es parte de estar vivo y de que te importan las cosas.",
            prayer: "Padre, hoy me siento triste y no quiero fingir lo contrario. Consuélame en este momento y recuérdame que no estoy solo en esto. Amén.",
            exercises: [
                "Permítete sentir la tristeza sin apurarte a 'estar bien' de inmediato.",
                "Sal a caminar aunque sean 10 minutos; el movimiento suave ayuda a procesar la emoción.",
                "Escríbele o llama a alguien de confianza, aunque solo sea para decir 'hoy estoy triste'."
            ],
            encouragement: "Este sentimiento tiene permiso de estar aquí hoy. Mañana no tiene que sentirse igual."
        ),
        .miedo: MoodResponse(
            mood: .miedo,
            passage: "No temas, porque yo estoy contigo; no desmayes, porque yo soy tu Dios.",
            passageReference: "Isaías 41:10",
            reflection: "El miedo casi nunca se va porque alguien te diga 'no temas' — se calma cuando sientes que no lo enfrentas solo. Esta promesa no borra la amenaza, ofrece compañía dentro de ella.",
            prayer: "Dios, reconozco mi miedo delante de ti. No te pido que lo quites por completo, sino que camines conmigo a través de él. Amén.",
            exercises: [
                "Nombra específicamente a qué le tienes miedo, en una sola frase concreta.",
                "Pregúntate: ¿qué está realmente dentro de mi control ahora mismo sobre esto?",
                "Respira lento, coloca una mano en el pecho y recuerda que en este momento exacto estás a salvo."
            ],
            encouragement: "Puedes sentir miedo y aun así dar el siguiente paso. El miedo no tiene la última palabra."
        ),
        .soledad: MoodResponse(
            mood: .soledad,
            passage: "No te dejaré, ni te desampararé.",
            passageReference: "Hebreos 13:5",
            reflection: "La soledad puede sentirse como una verdad absoluta, cuando en realidad es una emoción del momento. Sentirte solo no significa que estés desamparado — a veces solo significa que necesitas dar el primer paso hacia alguien, aunque cueste.",
            prayer: "Señor, hoy me siento solo. Gracias porque tu promesa es no dejarme. Ayúdame también a buscar y recibir compañía humana. Amén.",
            exercises: [
                "Contacta a una persona hoy, aunque sea con un mensaje corto y sencillo.",
                "Escribe en tu diario cómo te sientes; ponerlo en palabras ya es una forma de acompañarte.",
                "Recuerda un momento reciente en el que alguien mostró que le importas, por pequeño que haya sido."
            ],
            encouragement: "Sentirte solo ahora no significa estar solo siempre. Buscar compañía es un acto de valentía, no de debilidad."
        ),
        .enojo: MoodResponse(
            mood: .enojo,
            passage: "Airaos, pero no pequéis; no se ponga el sol sobre vuestro enojo.",
            passageReference: "Efesios 4:26",
            reflection: "El enojo en sí mismo no es el problema — casi siempre señala que algo importante para ti fue pisoteado o ignorado. El reto no es no sentirlo, es no dejar que decida tus siguientes acciones sin pasar primero por un momento de calma.",
            prayer: "Padre, hoy siento enojo. Ayúdame a no actuar desde él sin pensar, y a identificar qué necesito realmente detrás de esta emoción. Amén.",
            exercises: [
                "Antes de responder a nada, cuenta hasta 10 respirando profundo.",
                "Escribe lo que sientes sin filtro en un papel — no lo envíes todavía, solo sácalo de tu cabeza.",
                "Pregúntate qué necesidad tuya no está siendo atendida detrás de este enojo."
            ],
            encouragement: "Tu enojo es información válida. Tienes el control de qué hacer con ella."
        ),
        .cansancio: MoodResponse(
            mood: .cansancio,
            passage: "Venid a mí todos los que estáis trabajados y cargados, y yo os haré descansar.",
            passageReference: "Mateo 11:28",
            reflection: "El descanso que se ofrece aquí no exige que primero resuelvas todo lo pendiente. Puedes venir cansado, tal como estás, sin haber terminado la lista.",
            prayer: "Señor, vengo cansado tal como estoy. Gracias por no pedirme que llegue con todo resuelto. Dame descanso hoy. Amén.",
            exercises: [
                "Date permiso de descansar sin culpa, aunque sean solo 15 minutos.",
                "Bebe agua y, si puedes, sal a tomar un poco de aire.",
                "Pospón una tarea no urgente de hoy para mañana, sin culpa."
            ],
            encouragement: "No necesitas ganarte el descanso. Está bien parar antes de estar completamente agotado."
        ),
        .culpa: MoodResponse(
            mood: .culpa,
            passage: "Si confesamos nuestros pecados, él es fiel y justo para perdonar nuestros pecados.",
            passageReference: "1 Juan 1:9",
            reflection: "La culpa vaga pesa más que la culpa específica. Nombrar exactamente qué pasó y qué harías distinto la próxima vez es más sanador que cargar una sensación difusa de 'soy un desastre'.",
            prayer: "Padre, reconozco lo que hice mal. Gracias por tu perdón. Ayúdame a aprender de esto sin quedarme atrapado en la vergüenza. Amén.",
            exercises: [
                "Escribe específicamente qué hiciste y qué harías diferente — es más ligero que la culpa vaga.",
                "Si puedes reparar algo concreto, da un paso hacia eso hoy.",
                "Practica decirte a ti mismo lo que le dirías a un buen amigo en tu misma situación."
            ],
            encouragement: "Equivocarte no borra tu valor. Puedes reparar y seguir adelante."
        ),
        .confusion: MoodResponse(
            mood: .confusion,
            passage: "Si alguno de vosotros tiene falta de sabiduría, pídala a Dios, el cual da a todos abundantemente y sin reproche, y le será dada.",
            passageReference: "Santiago 1:5",
            reflection: "No necesitas ver todo el camino para dar el siguiente paso. La claridad total casi nunca llega antes de moverse — llega mientras se avanza.",
            prayer: "Señor, no tengo claridad hoy. Te pido sabiduría, no para verlo todo, sino para dar el siguiente paso correcto. Amén.",
            exercises: [
                "Escribe todas las opciones que tienes, sin filtrar todavía cuál es la correcta.",
                "Habla en voz alta de tu situación con alguien de confianza; a veces se aclara al decirla.",
                "Pregúntate: ¿qué decisión podría tomar hoy sin necesitar el 100% de certeza?"
            ],
            encouragement: "Está bien no tener todas las respuestas todavía. El siguiente paso pequeño es suficiente por hoy."
        ),
        .estres: MoodResponse(
            mood: .estres,
            passage: "Echa toda tu ansiedad sobre él, porque él tiene cuidado de ti.",
            passageReference: "1 Pedro 5:7",
            reflection: "El estrés suele venir de sostener mentalmente todo a la vez. Casi nunca todo es igual de urgente — solo se siente así cuando no lo hemos separado en partes.",
            prayer: "Padre, hoy me siento abrumado. Ayúdame a soltar lo que no puedo controlar y a enfocarme solo en lo que sí puedo hacer hoy. Amén.",
            exercises: [
                "Haz una lista de todo lo pendiente y marca solo lo verdaderamente urgente de hoy.",
                "Respira profundo 5 veces antes de seguir con tu lista.",
                "Pregúntate qué puedes delegar, posponer o soltar por hoy."
            ],
            encouragement: "No tienes que con todo hoy. Solo con lo de hoy."
        ),
        .alegria: MoodResponse(
            mood: .alegria,
            passage: "Este es el día que hizo Jehová; nos gozaremos y alegraremos en él.",
            passageReference: "Salmos 118:24",
            reflection: "Los momentos de alegría genuina merecen notarse, no solo dejarse pasar. Detenerte a reconocerla la hace más presente y más fácil de recordar en los días difíciles.",
            prayer: "Gracias, Señor, por este momento de alegría. Ayúdame a disfrutarlo plenamente y a recordarlo cuando lo necesite. Amén.",
            exercises: [
                "Comparte esta alegría con alguien más hoy.",
                "Anota este momento en tu diario para poder volver a él después.",
                "Agradece conscientemente, en voz alta o por escrito, por lo que hoy te alegra."
            ],
            encouragement: "Disfruta este momento sin culpa. Te lo mereces tanto como cualquier otro."
        ),
        .gratitud: MoodResponse(
            mood: .gratitud,
            passage: "Dad gracias en todo, porque esta es la voluntad de Dios para con vosotros en Cristo Jesús.",
            passageReference: "1 Tesalonicenses 5:18",
            reflection: "La gratitud que sientes hoy vale la pena anotarla — no solo sentirla y dejarla pasar. Guardar este momento te da algo a lo que volver en los días más difíciles.",
            prayer: "Señor, gracias por lo que hoy tengo y por lo que hoy soy. Ayúdame a no dar por sentado este momento. Amén.",
            exercises: [
                "Escribe 3 cosas específicas por las que hoy te sientes agradecido.",
                "Dile directamente a alguien por qué le agradeces algo.",
                "Guarda este sentimiento en tu diario para releerlo en un día difícil."
            ],
            encouragement: "Notar lo bueno no niega lo difícil. Sigue cultivando esta gratitud."
        ),
        .esperanza: MoodResponse(
            mood: .esperanza,
            passage: "Los que esperan a Jehová tendrán nuevas fuerzas; levantarán alas como las águilas.",
            passageReference: "Isaías 40:31",
            reflection: "La esperanza que sientes hoy es un buen combustible — vale la pena convertirla en un paso concreto mientras está presente, en vez de dejar que se quede solo como una sensación pasajera.",
            prayer: "Padre, gracias por esta esperanza que hoy siento. Ayúdame a convertirla en acción y a sostenerla en los días donde no la sienta tan fuerte. Amén.",
            exercises: [
                "Escribe una meta concreta que esta esperanza te impulsa a perseguir.",
                "Comparte tu esperanza con alguien que pueda animarte a sostenerla.",
                "Da un paso pequeño hoy mismo hacia lo que esperas."
            ],
            encouragement: "Sostén esta esperanza. Es una buena base para construir lo que sigue."
        ),
        .general: MoodResponse(
            mood: .general,
            passage: "Cercano está Jehová a los quebrantados de corazón; y salva a los contritos de espíritu.",
            passageReference: "Salmos 34:18",
            reflection: "Gracias por compartir cómo te sientes hoy. Sea lo que sea que estés viviendo, ponerlo en palabras ya es un paso valioso — no tienes que tener todo claro ni resuelto para que este momento cuente.",
            prayer: "Señor, gracias porque estás cerca sin importar cómo me sienta hoy. Ayúdame a atravesar este momento con tu compañía. Amén.",
            exercises: [
                "Respira profundo unas cuantas veces, despacio.",
                "Escribe en tu diario cómo te sientes ahora mismo, sin juzgarlo.",
                "Recuerda que no tienes que resolver todo hoy — un paso a la vez es suficiente."
            ],
            encouragement: "Gracias por escribir esto. Sea lo que sea que sientas, no estás solo o sola en ello."
        ),
    ]
}
