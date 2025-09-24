; Preferencias do cliente para sugerir um jogo de tabuleiro ;

(deftemplate Preferencias
    (slot video_game) ; tony_hawk, mario_kart, mortal_kombat, god_of_war
    (slot ambiente)   ; calmo, animado
    (slot budget)     ; baixo, alto
    (slot area_estudo)) ; exatas, humanas, biologicas

(deftemplate Jogo
    (slot nome)
)

(deftemplate Loja
    (slot jogo)
)

;;; =============================== ;;;
;;;     Perguntas ao usuario        ;;;
;;; =============================== ;;;

(defrule GetJogosOnline
    (declare (salience 10))
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
    else (if (= ?resposta 2) then
        (assert (Preferencias (video_game mario_kart)))
    else (if (= ?resposta 3) then
        (assert (Preferencias (video_game mortal_kombat)))
    else (if (= ?resposta 4) then
        (assert (Preferencias (video_game god_of_war)))
    else
        (assert (Preferencias (video_game mario_kart)))))))
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
    else (if (= ?resposta 2) then
        (assert (Preferencias (ambiente animado)))
    else
        (assert (Preferencias (ambiente calmo)))))
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
    else (if (= ?resposta 2) then
        (assert (Preferencias (budget alto)))
    else
        (assert (Preferencias (budget baixo)))))
)

(defrule GetAreaEstudos
    (declare (salience 7))
    =>
    (printout t "Qual sua área de estudo?" crlf)
    (printout t "1 - Exatas" crlf)
    (printout t "2 - Humanas" crlf)
    (printout t "3 - Biológicas" crlf)
    (printout t "Digite o número da opção: ")
    (bind ?resposta (read))
    (if (= ?resposta 1) then
        (assert (Preferencias (area_estudo exatas)))
    else (if (= ?resposta 2) then
        (assert (Preferencias (area_estudo humanas)))
    else (if (= ?resposta 3) then
        (assert (Preferencias (area_estudo biologicas)))
    else
        (assert (Preferencias (area_estudo exatas))))))
)

;;; =============================== ;;;
;;;  Regras para escolher o jogo    ;;;
;;; =============================== ;;;

(defrule Damas
    (Preferencias (ambiente calmo))
    (Preferencias (budget baixo))
    (Preferencias (area_estudo biologicas))
    =>
    (assert (Jogo (nome Damas)))
    (assert (Loja (jogo Damas)))
    (printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf)
)

(defrule Xadrez
    (Preferencias (ambiente calmo))
    (Preferencias (budget baixo))
    (Preferencias (area_estudo exatas))
    (Preferencias (video_game mortal_kombat))
    =>
    (assert (Jogo (nome Xadrez)))
    (assert (Loja (jogo Xadrez)))
    (printout t "Jogo sugerido: Xadrez. Um clássico que estimula a mente e a estratégia." crlf)
)

(defrule PalavraCruzada
    (Preferencias (video_game tony_hawk))
    (Preferencias (ambiente calmo))
    (Preferencias (budget baixo))
    =>
    (assert (Jogo (nome PalavraCruzada)))
    (assert (Loja (jogo PalavraCruzada)))
    (printout t "Jogo sugerido: Palavra Cruzada. Ótimo para exercitar o vocabulário e a mente." crlf)
)

(defrule Resta1
    (Preferencias (video_game god_of_war))
    (Preferencias (ambiente calmo))
    (Preferencias (budget baixo))
    =>
    (assert (Jogo (nome Resta1)))
    (assert (Loja (jogo Resta1)))
    (printout t "Jogo sugerido: Resta 1. Excelente para relaxar e desenvolver raciocínio lógico." crlf)
)

(defrule War
    (Preferencias (video_game god_of_war))
    (Preferencias (budget alto))
    (or (Preferencias (area_estudo humanas))
        (Preferencias (area_estudo exatas)))
    =>
    (assert (Jogo (nome War)))
    (assert (Loja (jogo War)))
    (printout t "Jogo sugerido: War. Um clássico de estratégia e conquista." crlf)
)

(defrule TheMind
    (Preferencias (video_game mario_kart))
    (Preferencias (ambiente animado))
    (or (Preferencias (budget baixo))
        (Preferencias (area_estudo humanas))
        (Preferencias (area_estudo biologicas)))
    =>
    (assert (Jogo (nome TheMind)))
    (assert (Loja (jogo TheMind)))
    (printout t "Jogo sugerido: The Mind. Um jogo cooperativo que desafia a intuição e a comunicação." crlf)
)

(defrule ExplodingKittens
    (Preferencias (video_game mario_kart))
    (Preferencias (ambiente animado))
    (Preferencias (budget baixo))
    (or (Preferencias (area_estudo humanas))
        (Preferencias (area_estudo biologicas)))
    =>
    (assert (Jogo (nome ExplodingKittens)))
    (assert (Loja (jogo ExplodingKittens)))
    (printout t "Jogo sugerido: Exploding Kittens. Um jogo de cartas para se divertir com amigos." crlf)
)

(defrule Hanabi
    (Preferencias (ambiente calmo))
    (Preferencias (area_estudo exatas))
    (Preferencias (video_game mortal_kombat))
    =>
    (assert (Jogo (nome Hanabi)))
    (assert (Loja (jogo Hanabi)))
    (printout t "Jogo sugerido: Hanabi. Explore a cooperação e a comunicação em equipe." crlf)
)

(defrule Codenames
    (Preferencias (video_game tony_hawk))
    (Preferencias (ambiente animado))
    (Preferencias (budget baixo))
    =>
    (assert (Jogo (nome Codenames)))
    (assert (Loja (jogo Codenames)))
    (printout t "Jogo sugerido: Codenames. Um jogo de palavras e dedução para grupos." crlf)
)

(defrule Operando
    (Preferencias (video_game mario_kart))
    (Preferencias (area_estudo biologicas))
    (Preferencias (ambiente animado))
    (Preferencias (budget alto))
    =>
    (assert (Jogo (nome Operando)))
    (assert (Loja (jogo Operando)))
    (printout t "Jogo sugerido: Operando. Teste sua habilidade e precisão com este jogo clássico." crlf)
)

(defrule Concept
    (or (Preferencias (video_game tony_hawk))
        (Preferencias (area_estudo humanas)))
    (Preferencias (ambiente animado))
    (Preferencias (budget alto))
    =>
    (assert (Jogo (nome Concept)))
    (assert (Loja (jogo Concept)))
    (printout t "Jogo sugerido: Concept. Um jogo de adivinhação baseado em conceitos e associações." crlf)
)

(defrule Monopoly
    (Preferencias (budget alto))
    (Preferencias (ambiente animado))
    (or (Preferencias (area_estudo humanas))
        (Preferencias (area_estudo exatas)))
    =>
    (assert (Jogo (nome Monopoly)))
    (assert (Loja (jogo Monopoly)))
    (printout t "Jogo sugerido: Monopoly. O clássico jogo de compra e venda de propriedades." crlf)
)

;;; =============================== ;;;
;;; Mostrar Loja para compra do jogo ;;;
;;; =============================== ;;;

(defrule CasaDoDado
    (declare (salience -1))
    (or (Loja (jogo Damas)) (Loja (jogo Xadrez)))
    =>
    (printout t "Você pode comprar esse jogo na loja Casa do Dado." crlf)
)

(defrule CasteloDosJogos
    (declare (salience -1))
    (or (Loja (jogo PalavraCruzada)) (Loja (jogo Resta1)) (Loja (jogo War)))
    =>
    (printout t "Você pode comprar esse jogo na loja Castelo dos Jogos." crlf)
)

(defrule TabuleiroMagico
    (declare (salience -1))
    (or (Loja (jogo TheMind)) (Loja (jogo ExplodingKittens)) (Loja (jogo Hanabi)))
    =>
    (printout t "Você pode comprar esse jogo na loja Tabuleiro Mágico." crlf)
)

(defrule Ludica
    (declare (salience -1))
    (or (Loja (jogo Codenames)) (Loja (jogo Operando)))
    =>
    (printout t "Você pode comprar esse jogo na loja Lúdica." crlf)
)

(defrule EstrategiaECompanhia
    (declare (salience -1))
    (or (Loja (jogo Concept)) (Loja (jogo Monopoly)))
    =>
    (printout t "Você pode comprar esse jogo na loja Estratégia & Companhia." crlf)
)

;;; =============================== ;;;
;;;  Mostrar Resultado Final         ;;;
;;; =============================== ;;;

; (defrule Fim
;     (declare (salience -2))
;     (Jogo (nome ?jogo))
;     =>
;     (printout t crlf "===========================================" crlf)
;     (printout t "RESUMO: O jogo recomendado é " ?jogo crlf)
;     (printout t "===========================================" crlf crlf)
; )