; ==============================
; SISTEMA ESPECIALISTA - RECOMENDADOR DE JOGOS
; ==============================

(deftemplate Jogo
  (slot nome)
  (multislot tipo)
  (multislot categoria)
  (multislot participantes)
  (multislot tempo))

(deftemplate Contexto
  (slot nome))

(deftemplate Recomendacao
  (slot jogo)
  (slot motivo))

; ==============================
; REGRAS PARA PERGUNTAR SOBRE O CONTEXTO
; ==============================

(defrule titulo
  (declare (salience 100))
  =>
  (printout t crlf)
  (printout t "==================================" crlf)
  (printout t "SISTEMA ESPECIALISTA - RECOMENDADOR DE JOGOS" crlf)
  (printout t "==================================" crlf crlf))

(defrule perguntar-contexto
  (declare (salience 90))
  ?phase <- (phase inicio)
  =>
  (retract ?phase)
  (printout t "Para recomendar o jogo ideal, preciso saber o contexto:" crlf)
  (printout t "1 - Festa/Reuniao com amigos" crlf)
  (printout t "2 - Encontro rapido (ate 30 min)" crlf)
  (printout t "3 - Noite de jogos longa (+75 min)" crlf)
  (printout t "4 - Viagem" crlf)
  (printout t "5 - Em familia (com crianças)" crlf)
  (printout t "6 - Jogar sozinho" crlf)
  (printout t "7 - Sala de espera" crlf)
  (printout t crlf "Escolha uma opcao (1-7): ")
  (bind ?resposta (read))
  (if (or (< ?resposta 1) (> ?resposta 7))
    then 
      (printout t "Opcao invalida. Tente novamente." crlf)
      (assert (phase inicio))
    else
      (bind ?contexto (nth$ (- ?resposta 1) (create$ festa encontros-rapidos encontros-longos viagem familia com-criancas sala-de-espera sozinho)))
      (assert (Contexto (nome ?contexto)))
  )
)

; ==============================
; BASE DE CONHECIMENTO - JOGOS
; ==============================

(defrule inicializar-jogos
  (declare (salience 80))
  ?phase <- (phase carregar-jogos)
  =>
  (retract ?phase)
  ; Jogos de festa
  (assert (Jogo (nome "Uno") (tipo carta) (categoria facil infantil) (participantes 2-3 4-5 6-8 9-10) (tempo rapido)))
  (assert (Jogo (nome "Dobble") (tipo carta) (categoria facil infantil) (participantes 2-3 4-5 6-8) (tempo rapido)))
  (assert (Jogo (nome "Codenames") (tipo carta) (categoria facil estrategia cooperativo) (participantes 4-5 6-8 9-10) (tempo rapido)))
  (assert (Jogo (nome "Spyfall") (tipo carta) (categoria facil cooperativo) (participantes 4-5 6-8 9-10) (tempo rapido)))
  (assert (Jogo (nome "Black Stories") (tipo carta) (categoria facil cooperativo) (participantes 2-3 4-5 6-8) (tempo rapido)))
  (assert (Jogo (nome "Taco Gato Cabra Queijo Pizza") (tipo carta) (categoria facil infantil) (participantes 2-3 4-5) (tempo rapido)))

  ; Encontro rápidos
  (assert (Jogo (nome "Cara a Cara") (tipo tabuleiro) (categoria facil infantil) (participantes 2-3) (tempo rapido)))
  (assert (Jogo (nome "The Mind") (tipo carta) (categoria facil cooperativo infantil) (participantes 2-3 4-5 6-8 9-10) (tempo rapido)))
  (assert (Jogo (nome "Exploding Kittens") (tipo carta) (categoria facil) (participantes 2-3 4-5) (tempo rapido)))
  (assert (Jogo (nome "Dixit") (tipo tabuleiro) (categoria facil) (participantes 2-3 4-5 6-8) (tempo rapido)))
  
  ; Encontros longos
  (assert (Jogo (nome "Catan") (tipo tabuleiro) (categoria estrategia) (participantes 2-3 4-5) (tempo medio)))
  (assert (Jogo (nome "Terraforming Mars") (tipo tabuleiro) (categoria estrategia) (participantes 2-3 4-5) (tempo longo)))
  (assert (Jogo (nome "War") (tipo tabuleiro) (categoria estrategia) (participantes 2-3 4-5) (tempo longo)))
  (assert (Jogo (nome "7 wonders") (tipo tabuleiro) (categoria estrategia) (participantes 4-5 6-8) (tempo medio)))
  
  ; Jogos para viagem
  (assert (Jogo (nome "Hanabi") (tipo carta) (categoria facil cooperativo) (participantes 2-3 4-5) (tempo rapido)))
  (assert (Jogo (nome "Saboteur") (tipo carta) (categoria facil) (participantes 2-3 4-5 6-8) (tempo rapido)))
  
  ; Jogos familia

  ; Jogos com criancas
  (assert (Jogo (nome "Candy Land") (tipo tabuleiro) (categoria facil infantil) (participantes 2-3 4-5) (tempo rapido)))
  (assert (Jogo (nome "Operando") (tipo tabuleiro) (categoria facil infantil cooperativo) (participantes 2-3 4-5) (tempo rapido)))
  
  ; Jogos em sala de espera
  (assert (Jogo (nome "Spirit Island") (tipo tabuleiro) (categoria estrategia cooperativo) (participantes 1 2-3 4-5) (tempo longo)))
  (assert (Jogo (nome "Gloomhaven") (tipo tabuleiro) (categoria estrategia cooperativo) (participantes 1 2-3 4-5) (tempo longo)))
  
  ; Jogos solo

)

; ==============================
; REGRAS DE RECOMENDAÇÃO
; ==============================

; Festa
(defrule recomendar-festa
  (Contexto (nome festa))
  ?jogo <- (Jogo (nome ?nome) (categoria $?cat&:(member facil ?cat)) (participantes $?part&:(or (member 4-5 ?part) (member 6-8 ?part))) (tempo rapido))
  =>
  (assert (Recomendacao (jogo ?nome) (motivo "Otimo para festas: facil de aprender, rapido e para grupos medios/grandes"))))

; Encontros rapidos
(defrule recomendar-rapido
  (Contexto (nome encontros-rapidos))
  ?jogo <- (Jogo (nome ?nome) (tempo rapido) (participantes $?part&:(or (member 2-3 ?part) (member 4-5 ?part))))
  =>
  (assert (Recomendacao (jogo ?nome) (motivo "Perfeito para partidas rapidas: jogo curto e ideal para pequenos grupos"))))

; Encontros longos
(defrule recomendar-longo
  (Contexto (nome encontros-longos))
  ?jogo <- (Jogo (nome ?nome) (tempo longo) (categoria $?cat&:(member estrategia ?cat)))
  =>
  (assert (Recomendacao (jogo ?nome) (motivo "Ideal para noites longas: jogo estrategico e com duracao prolongada"))))

; Viagem
(defrule recomendar-viagem
  (Contexto (nome viagem))
  ?jogo <- (Jogo (nome ?nome) (tipo carta) (participantes $?part&:(or (member 2-3 ?part) (member 4-5 ?part))))
  =>
  (assert (Recomendacao (jogo ?nome) (motivo "Perfeito para viagens: jogo de cartas, portatil e para pequenos grupos"))))

; Familia com crianças
(defrule recomendar-familia
  (Contexto (nome familia))
  ?jogo <- (Jogo (nome ?nome) (categoria $?cat&:(and (member facil ?cat) (member infantil ?cat))) (participantes $?part&:(or (member 2-3 ?part) (member 4-5 ?part))))
  =>
  (assert (Recomendacao (jogo ?nome) (motivo "Otimo para familias com crianças: facil, divertido e adequado para todas as idades"))))

; Jogar sozinho
(defrule recomendar-sozinho
  (Contexto (nome sozinho))
  ?jogo <- (Jogo (nome ?nome) (participantes $?part&:(member 1 ?part)))
  =>
  (assert (Recomendacao (jogo ?nome) (motivo "Permite jogar sozinho: modo solo disponivel"))))

; Estrategia
(defrule recomendar-estrategia
  (Contexto (nome estrategia))
  ?jogo <- (Jogo (nome ?nome) (categoria $?cat&:(member estrategia ?cat)) (participantes $?part&:(or (member 2-3 ?part) (member 4-5 ?part))))
  =>
  (assert (Recomendacao (jogo ?nome) (motivo "Para mentes estrategicas: jogo desafiador que exige planejamento"))))

; ==============================
; MOSTRAR RECOMENDAÇÕES
; ==============================

(defrule mostrar-recomendacoes
  (declare (salience -10))
  ?contexto <- (Contexto (nome ?nome-contexto))
  =>
  (printout t crlf "==================================" crlf)
  (printout t "RECOMENDACOES PARA: " ?nome-contexto crlf)
  (printout t "==================================" crlf crlf)
  
  (bind ?recomendacoes (find-all-facts ((?r Recomendacao)) TRUE))
  
  (if (> (length ?recomendacoes) 0) then
    (foreach ?r ?recomendacoes
      (printout t "Jogo: " (fact-slot-value ?r jogo) crlf)
      (printout t "Motivo: " (fact-slot-value ?r motivo) crlf)
      (printout t "---" crlf crlf)
    )
  else
    (printout t "Nenhum jogo encontrado para este contexto." crlf)
  )
  
  (printout t crlf "Fim das recomendacoes." crlf)
)

; ==============================
; INICIALIZAR SISTEMA
; ==============================

(reset)
(assert (phase inicio))
(assert (phase carregar-jogos))
(run)