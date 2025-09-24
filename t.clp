; Preferencias do cliente para sugerir um jogo de tabuleiro ;

(deftemplate Preferencias
    (slot video_game) ; Tony Hawk, Mario Kart, Mortal Kombat, God of War
    (slot ambiente)   ; calmo, animado
    (slot budget)     ; baixo, alto
    (slot area_estudo)) ; exatas, humanas, biologicas

(deftemplate Jogo
    (slot nome)
)

(deftemplate Preco
    (slot valor)
)

;;; =============================== ;;;
;;;     Perguntas ao usuario        ;;;
;;; =============================== ;;;

(defrule GetJogosOnline
    (declare (salience 5))
   =>
    (printout t "Qual seu video game preferido?" crlf)
    (printout t "1 - Tony Hawk" crlf)
    (printout t "2 - Mario Kart" crlf)
    (printout t "3 - Mortal Kombat" crlf)
    (printout t "4 - God of War" crlf)
    (printout t "Digite o número da opção: ")
    (bind ?resposta (read))
    (if (= ?resposta 1) then
        (assert (Preferencias (video_game tony_hawk)))
    else if (= ?resposta 2) then
        (assert (Preferencias (video_game mario_kart)))
    else if (= ?resposta 3) then
        (assert (Preferencias (video_game mortal_kombat)))
    else if (= ?resposta 4) then
        (assert (Preferencias (video_game god_of_war)))
    else
        (assert (Preferencias (video_game mario_kart))))
)

(defrule GetAmbiente
    (declare (salience 9))
    =>
    (printout t "Que tipo de ambiente você prefere?" crlf)
    (printout t "1 - Calmo" crlf)
    (printout t "2 - Animado" crlf)
    (printout t "Digite o número da opção: ")
    (bind ?resposta (read))
    (if (= ?resposta 1) then
        (assert (Preferencias (ambiente calmo)))
    else if (= ?resposta 2) then
        (assert (Preferencias (ambiente animado)))
    else
        (assert (Preferencias (ambiente calmo))))
)

(defrule GetBudget
    (declare (salience 8))
    =>
    (printout t "Quanto você está disposto a gastar?" crlf)
    (printout t "1 - Baixo" crlf)
    (printout t "2 - Alto" crlf)
    (printout t "Digite o número da opção: ")
    (bind ?resposta (read))
    (if (= ?resposta 1) then
            (assert (Preferencias (budget baixo)))
        else if (= ?resposta 2) then
            (assert (Preferencias (budget alto)))
        else
            (assert (Preferencias (budget baixo))))
)

(defrule GetAreaEstudos
    (declare (salience 5))
    =>
    (printout t "Qual sua área de estudo?" crlf)
    (printout t "1 - Exatas" crlf)
    (printout t "2 - Humanas" crlf)
    (printout t "3 - Biológicas" crlf)
    (printout t "Digite o número da opção: ")
    (bind ?resposta (read))
    (if (= ?resposta 1) then
        (assert (Preferencias (area_estudo exatas)))
    else if (= ?resposta 2) then
        (assert (Preferencias (area_estudo humanas)))
    else if (= ?resposta 3) then
        (assert (Preferencias (area_estudo biologicas)))
    else
        (assert (Preferencias (area_estudo exatas))))
)

;;; =============================== ;;;
;;;  Regras para escolher o jogo    ;;;
;;; =============================== ;;;

(defrule Damas
	(and(Preferencias (ambiente calmo))
    (Preferencias (budget baixo))
    (Preferencias (area_estudo biologicas)))
	=>
	(assert (Jogo (nome Damas)))
    (assert (Preco (valor "R$ 20,00 - R$ 50,00")))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

(defrule Xadrez
	(and(Preferencias (ambiente calmo))
    (Preferencias (budget baixo))
    (Preferencias (area_estudo exatas)))
	=>
	(assert (Jogo (nome Xadrez)))
    (assert (Preco (valor "R$ 30,00 - R$ 70,00")))
	(printout t "Jogo sugerido: Xadrez. Um clássico que estimula a mente e a estratégia." crlf)
)

(defrule PalavraCruzada
	(and(Preferencias (video_game tony_hawk))
    (Preferencias (ambiente calmo))
    (Preferencias (budget baixo)))
	=>
	(assert (Jogo (nome PalavraCruzada)))
    (assert (Preco (valor "R$ 10,00 - R$ 30,00")))
	(printout t "Jogo sugerido: Palavra Cruzada. Ótimo para exercitar o vocabulário e a mente." crlf)
)

(defrule Resta1
	(and (Preferencias (video_game god_of_war))
    (Preferencias (ambiente calmo))
    (Preferencias (budget baixo)))
	=>
	(assert (Jogo (nome Resta1)))
    (assert (Preco (valor "R$ 20,00 - R$ 40,00")))
	(printout t "Jogo sugerido: Resta 1. Excelente para relaxar e desenvolver raciocínio lógico." crlf)
)

(defrule War
  (and (Preferencias (video_game god_of_war)) 
  (Preferencias (budget alto))
  (or (Preferencias (area_estudo humanas)) 
      (Preferencias (area_estudo exatas))))
  =>
  (assert (Jogo (nome War)))
  (assert (Preco (valor "R$ 200,00 - R$ 250,00")))
  (printout t "Jogo sugerido: War. Um clássico de estratégia e conquista." crlf)
)

(defrule TheMind
	and ((Preferencias (video_game mario_kart))
    (Preferencias (ambiente animado))
    (or (Preferencias (budget baixo))
        (Preferencias (area_estudo humanas))
        (Preferencias (area_estudo biologicas))))
	=>
	(assert (Jogo (nome TheMind)))
    (assert (Preco (valor "R$ 50,00 - R$ 70,00")))
	(printout t "Jogo sugerido: The Mind. Um jogo cooperativo que desafia a intuição e a comunicação." crlf)
)

(defrule ExplodingKittens
	and((Preferencias (video_game mario_kart))
    (Preferencias (ambiente animado))
    (Preferencias (budget baixo))
    (or (Preferencias (area_estudo humanas)) 
        (Preferencias (area_estudo biologicas))))
	=>
	(assert (Jogo (nome ExplodingKittens)))
    (assert (Preco (valor "R$ 50,00 - R$ 80,00")))
	(printout t "Jogo sugerido: Exploding Kittens. Um jogo de cartas para se divertir com amigos." crlf )
)

(defrule Hanabi
	and((Preferencias (ambiente calmo))
    (Preferencias (area_estudo exatas))
    (Preferencias (video_game mortal_kombat)))
	=>
	(assert (Jogo (nome Hanabi)))
    (assert (Preco (valor "R$ 60,00 - R$ 100,00")))
	(printout t "Jogo sugerido: Hanabi. Explore a cooperação e a comunicação em equipe." crlf)
)

(defrule Codenames
	(and(Preferencias (video_game tony_hawk))
    (Preferencias (ambiente animado))
    (Preferencias (budget baixo)))
	=>
	(assert (Jogo (nome Codenames)))
    (assert (Preco (valor "R$ 60,00 - R$ 100,00")))
	(printout t "Jogo sugerido: Codenames. Um jogo de palavras e dedução para grupos." crlf)
)

(defrule Operando
	(and( or(Preferencias (video_game mario_kart))
        (Preferencias (video_game tony_hawk)))
    (Preferencias (area_estudo biologicas))
    (Preferencias (budget alto)))
	=>
	(assert (Jogo (nome Operando)))
    (assert (Preco (valor "R$ 250,00 - R$ 350,00")))
	(printout t "Jogo sugerido: Operando. Teste sua habilidade e precisão com este jogo clássico." crlf)
)

(defrule Concept
	(and(or (Preferencias (video_game tony_hawk))
        (Preferencias (area_estudo humanas)))
    (Preferencias (ambiente animado))
    (Preferencias (budget alto)))
	=>
	(assert (Jogo (nome Concept)))
    (assert (Preco (valor "R$ 120,00 - R$ 200,00")))
	(printout t "Jogo sugerido: Concept. Um jogo de adivinhação baseado em conceitos e associações." crlf)
)

(defrule Monopoly
	(and(Preferencias (budget alto))
    (Preferencias (ambiente animado))
    (or (Preferencias (area_estudo humanas)) 
        (Preferencias (area_estudo exatas))))
	=>
	(assert (Jogo (nome Monopoly)))
    (assert (Preco (valor "R$ 200,00 - R$ 250,00")))
	(printout t "Jogo sugerido: Monopoly. O clássico jogo de compra e venda de propriedades." crlf)
)

;;; =============================== ;;;
;;;  Mostrar Resultado Final         ;;;
;;; =============================== ;;;

(defrule Fim
  (Jogo (nome ?jogo))
  (Preco (valor ?preco))
  =>
  (printout t crlf crlf)  
  (printout t "O jogo sugerido é: " ?jogo crlf)
  (printout t "Preço estimado: " ?preco crlf)
)

(defrule Titulo
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Sistema Especialista em Jogos de Cartas e Tabuleiros" crlf crlf))
