import Foundation

enum ReadingPlanLibrary {
    static let all: [ReadingPlan] = [
        ReadingPlan(
            id: "ansiedad-7",
            title: "7 días para soltar la ansiedad",
            subtitle: "Un plan corto para aprender a entregar la preocupación un día a la vez.",
            icon: "wind",
            days: [
                ReadingPlanDay(
                    id: 1,
                    title: "Nombrar antes que cargar",
                    passage: "Por nada estéis afanosos, sino sean conocidas vuestras peticiones delante de Dios en toda oración y ruego, con acción de gracias.",
                    passageReference: "Filipenses 4:6",
                    reflection: "El primer paso para soltar una preocupación no es dejar de sentirla, es nombrarla con precisión. Una ansiedad difusa pesa más que una preocupación concreta y entregada.",
                    action: "Escribe en una sola frase, lo más concreta posible, qué es exactamente lo que te preocupa hoy."
                ),
                ReadingPlanDay(
                    id: 2,
                    title: "Lo que sí está en tus manos",
                    passage: "¿Y quién de vosotros podrá, por mucho que se afane, añadir a su estatura un codo?",
                    passageReference: "Mateo 6:27",
                    reflection: "Gran parte de la ansiedad viene de intentar controlar lo que no depende de nosotros. Separar lo que sí puedes hacer de lo que no, libera energía real.",
                    action: "Divide tu preocupación en dos columnas: lo que sí puedes hacer hoy y lo que no está en tus manos."
                ),
                ReadingPlanDay(
                    id: 3,
                    title: "Un día a la vez",
                    passage: "Así que, no os afanéis por el día de mañana, porque el día de mañana traerá su afán.",
                    passageReference: "Mateo 6:34",
                    reflection: "La mente ansiosa suele vivir tres días a la vez: el de ayer, el de hoy y el de mañana. Este versículo no ignora el mañana, solo pide no cargarlo hoy además de lo de hoy.",
                    action: "Identifica una preocupación de 'mañana' que estás cargando hoy, y suéltala conscientemente hasta que llegue ese día."
                ),
                ReadingPlanDay(
                    id: 4,
                    title: "El cuerpo también escucha",
                    passage: "Echa toda tu ansiedad sobre él, porque él tiene cuidado de ti.",
                    passageReference: "1 Pedro 5:7",
                    reflection: "La ansiedad no es solo un pensamiento, también vive en el cuerpo: tensión, respiración corta, insomnio. Cuidar el cuerpo es también una forma de entregar la ansiedad.",
                    action: "Haz hoy el ejercicio de respiración 4-4-6 (inhala 4, sostén 4, exhala 6) tres veces durante el día."
                ),
                ReadingPlanDay(
                    id: 5,
                    title: "Compañía, no aislamiento",
                    passage: "No te dejaré, ni te desampararé.",
                    passageReference: "Hebreos 13:5",
                    reflection: "La ansiedad crece en el aislamiento y se reduce cuando se comparte. No tienes que resolver todo solo — decirlo en voz alta a alguien de confianza ya es un paso.",
                    action: "Cuéntale a alguien de confianza, aunque sea con un mensaje corto, cómo te has sentido esta semana."
                ),
                ReadingPlanDay(
                    id: 6,
                    title: "Gratitud como ancla",
                    passage: "Sea conocida vuestra gentileza a todos los hombres. El Señor está cerca. Por nada estéis afanosos... con acción de gracias.",
                    passageReference: "Filipenses 4:5-6",
                    reflection: "No es casualidad que Pablo una la entrega de la ansiedad con la gratitud. Agradecer lo que sí tienes hoy es un ancla que te saca de la espiral de lo que podría salir mal.",
                    action: "Escribe 3 cosas concretas de hoy por las que puedes agradecer, aunque la preocupación siga presente."
                ),
                ReadingPlanDay(
                    id: 7,
                    title: "La paz que no depende de que todo esté resuelto",
                    passage: "Y la paz de Dios, que sobrepasa todo entendimiento, guardará vuestros corazones y vuestros pensamientos.",
                    passageReference: "Filipenses 4:7",
                    reflection: "Esta paz no llega porque el problema se resolvió — llega mientras el problema puede seguir sin resolverse. Es una paz que no depende de tener el control, sino de a quién se lo entregas.",
                    action: "Cierra esta semana escribiendo qué cambió en cómo cargas tu preocupación, aunque el problema en sí siga igual."
                ),
            ]
        ),
        ReadingPlan(
            id: "gratitud-7",
            title: "7 días de gratitud",
            subtitle: "Una semana para entrenar la mirada hacia lo que ya tienes.",
            icon: "heart.fill",
            days: [
                ReadingPlanDay(
                    id: 1,
                    title: "Gratitud como punto de partida",
                    passage: "Entrad por sus puertas con acción de gracias, por sus atrios con alabanza.",
                    passageReference: "Salmos 100:4",
                    reflection: "Agradecer no tiene que ser la conclusión del día si salió bien — puede ser el punto de entrada, antes de saber cómo va a salir.",
                    action: "Antes de revisar el teléfono hoy, di en voz alta una cosa por la que agradeces de antemano."
                ),
                ReadingPlanDay(
                    id: 2,
                    title: "Lo pequeño también cuenta",
                    passage: "El corazón alegre constituye buen remedio.",
                    passageReference: "Proverbios 17:22",
                    reflection: "Solemos guardar la gratitud para lo grande: un logro, una noticia. Pero la mayoría de una vida está hecha de momentos pequeños que rara vez notamos.",
                    action: "Anota 3 cosas simples de hoy que normalmente darías por sentadas."
                ),
                ReadingPlanDay(
                    id: 3,
                    title: "Gratitud en medio de lo difícil",
                    passage: "Dad gracias en todo, porque esta es la voluntad de Dios para con vosotros en Cristo Jesús.",
                    passageReference: "1 Tesalonicenses 5:18",
                    reflection: "'En todo' no es 'por todo'. No se trata de agradecer el dolor, sino de encontrar algo real por lo cual agradecer incluso cuando algo más duele al mismo tiempo.",
                    action: "Nombra algo bueno de esta semana difícil, sin que eso niegue lo que también fue duro."
                ),
                ReadingPlanDay(
                    id: 4,
                    title: "Agradecer a las personas, no solo a la vida",
                    passage: "Doy gracias a mi Dios siempre que me acuerdo de vosotros.",
                    passageReference: "Filipenses 1:3",
                    reflection: "Es fácil agradecer en abstracto y nunca decírselo directamente a quien lo merece. La gratitud dicha en voz alta fortalece también la relación, no solo el ánimo propio.",
                    action: "Dile directamente a una persona por qué le agradeces algo específico."
                ),
                ReadingPlanDay(
                    id: 5,
                    title: "Un día nuevo, no una copia de ayer",
                    passage: "Cada mañana son nuevas tus misericordias; grande es tu fidelidad.",
                    passageReference: "Lamentaciones 3:22-23",
                    reflection: "Este versículo aparece en medio de un libro de lamento. La gratitud por hoy no requiere que ayer haya sido bueno, solo que hoy no está obligado a repetirlo.",
                    action: "Nombra algo específico por el que este nuevo día, en sí mismo, ya vale la pena agradecer."
                ),
                ReadingPlanDay(
                    id: 6,
                    title: "Gratitud por el cuerpo",
                    passage: "Te alabaré; porque formidables, maravillosas son tus obras.",
                    passageReference: "Salmos 139:14",
                    reflection: "Rara vez agradecemos el cuerpo hasta que algo en él deja de funcionar bien. Notarlo con cuidado hoy, mientras funciona, es también una forma de gratitud.",
                    action: "Agradece conscientemente algo que tu cuerpo te permitió hacer hoy, por simple que sea."
                ),
                ReadingPlanDay(
                    id: 7,
                    title: "Convertir la gratitud en hábito",
                    passage: "La gratitud convierte lo que tenemos en suficiente.",
                    passageReference: "Reflexión diaria",
                    reflection: "Una semana de gratitud no es el final del ejercicio — es la práctica que, repetida, empieza a cambiar cómo ves tu día a día por defecto.",
                    action: "Elige un momento fijo del día (la cena, antes de dormir) para seguir nombrando 3 cosas de gratitud, más allá de esta semana."
                ),
            ]
        ),
        ReadingPlan(
            id: "perdon-7",
            title: "7 días para sanar el pasado",
            subtitle: "Un recorrido para dejar de cargar heridas viejas en el presente.",
            icon: "arrow.uturn.backward.circle.fill",
            days: [
                ReadingPlanDay(
                    id: 1,
                    title: "Recordar no es lo mismo que cargar",
                    passage: "Olvidando ciertamente lo que queda atrás, y extendiéndome a lo que está delante.",
                    passageReference: "Filipenses 3:13",
                    reflection: "Sanar no es borrar la memoria. Es dejar de reaccionar hoy desde el dolor de algo que ya pasó, aunque lo recuerdes con total claridad.",
                    action: "Nombra una situación reciente en la que reaccionaste más desde una herida vieja que desde el presente real."
                ),
                ReadingPlanDay(
                    id: 2,
                    title: "Nombrar la herida específica",
                    passage: "El Señor está cerca de los quebrantados de corazón.",
                    passageReference: "Salmos 34:18",
                    reflection: "Las heridas vagas duelen más tiempo que las heridas nombradas. Ponerle nombre exacto a lo que pasó es incómodo, pero es el primer paso real hacia soltarlo.",
                    action: "Escribe, solo para ti, qué fue exactamente lo que te dolió y quién estuvo involucrado."
                ),
                ReadingPlanDay(
                    id: 3,
                    title: "Perdonar no es justificar",
                    passage: "Antes sed benignos unos con otros, misericordiosos, perdonándoos unos a otros.",
                    passageReference: "Efesios 4:32",
                    reflection: "Perdonar no significa decir que lo que pasó estuvo bien. Significa dejar de necesitar que la otra persona pague para que tú puedas seguir adelante.",
                    action: "Escribe la diferencia entre 'lo que pasó estuvo bien' y 'decido dejar de cargar esto' en tu propia situación."
                ),
                ReadingPlanDay(
                    id: 4,
                    title: "La culpa propia también se suelta",
                    passage: "Si confesamos nuestros pecados, él es fiel y justo para perdonar nuestros pecados.",
                    passageReference: "1 Juan 1:9",
                    reflection: "A veces la herida que más cuesta sanar es la que nos hicimos a nosotros mismos. La culpa vaga pesa más que el error nombrado y reparado donde se pueda.",
                    action: "Si hay algo que tú hiciste y sigues cargando, escribe qué harías diferente y date el permiso de soltarlo."
                ),
                ReadingPlanDay(
                    id: 5,
                    title: "Un capítulo, no todo el libro",
                    passage: "Aflicción y trabajo he encontrado... más el Señor me libró de todos ellos.",
                    passageReference: "Salmos 34:6",
                    reflection: "El dolor del pasado puede sentirse como si definiera todo lo que sigue. Pero un capítulo doloroso no es el resumen del libro completo de tu vida.",
                    action: "Escribe una cosa buena que ha pasado desde ese momento difícil, por pequeña que sea."
                ),
                ReadingPlanDay(
                    id: 6,
                    title: "Sanar no siempre es reconciliar",
                    passage: "Si es posible, en cuanto dependa de vosotros, estad en paz con todos los hombres.",
                    passageReference: "Romanos 12:18",
                    reflection: "'En cuanto dependa de ti' reconoce que no toda relación se puede reparar, y que sanar tu propio corazón no siempre requiere que la otra persona vuelva a tu vida.",
                    action: "Decide con honestidad si esta herida requiere una conversación pendiente, o solo tu propia decisión interna de soltarla."
                ),
                ReadingPlanDay(
                    id: 7,
                    title: "Extenderte hacia adelante",
                    passage: "He aquí, yo hago nueva todas las cosas.",
                    passageReference: "Apocalipsis 21:5",
                    reflection: "Terminar esta semana no significa que la herida desapareció por completo. Significa que empezaste a cargarla distinto, y eso ya es un cambio real.",
                    action: "Escribe qué cambió en cómo cargas esta herida esta semana, y qué te gustaría seguir cuidando de aquí en adelante."
                ),
            ]
        ),
    ]

    static func plan(withId id: String) -> ReadingPlan? {
        all.first { $0.id == id }
    }
}
