; Preferencias do cliente para sugerir um jogo de tabuleiro ;


(deftemplate Preferencias
    (slot jogos-online) ; Tony Hawk, Mario Kart, Mortal Kombat, God of War
    (slot ambiente) ;calmo, animado
    (slot budget) ; baixo, alto
    (slot area-estudo)) ; exatas, humanas, biologicas

(deftemplate Jogo
    (slot nome)
    ;(slot tipo) ; carta, tabuleiro
    ;(slot categoria) ; estrategia, facil, cooperativo
    ;(slot jogadores) ; sozinho, dupla, multi
    ;(slot duracao) ; rapido, medio, longo
)

(deftemplate Preco
    (slot valor)
)

;;; =============================== ;;;

;;;     Perguntas ao usuario        ;;;

;;; =============================== ;;;

(defrule GetJogosOnline
    (declare (salience 9))
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
        (assert (Preferencias (video_game god_of_wars)))
    else
        (assert (Preferencias (video_game mario_kart))))
)

(defrule GetAmbiente
    (declare (salience 9))
    =>
    (printout t "Que tipo de ambiente você prefere?")
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
    (declare (alience 9))
    =>
    (printout t "Quanto você está disposto a gastar?")
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

   
(detfrule GetAreaEstudos
    (declare (alience 9))
    =>
    (printout t "Qual sua área de estudo?")
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
	(and(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

(defrule Xadrez
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

(defrule Palavra Cruzada
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)


(defrule Resta 1
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

(defrule War
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

(defrule The Mind
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEO

(defrule Exploding Kittens
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente ))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

(defrule Damas
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

(defrule Damas
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)

(defrule Damas
	(and(Preferencias (video_game mario_kart))(Preferencias (ambiente calmo))(Preferencias (budget baixo))(Preferencias (area_estudo biologicas)))
	=>
	(assert(Jogo (nome Damas)))
	(printout t "Jogo sugerido: Damas. Excelente para relaxar e desenvolver raciocínio lógico." crlf )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Cliente	           |

(deftemplate Cliente
	(slot come_carne)
	(slot tem_filho)
	(slot fumante)
	(slot rest_caro))

(deftemplate Restaurante
	(slot rest))

(deftemplate Endereco
	(slot ende))

(defrule GetComeCarne
	(declare (salience 9))
   =>
   (printout t "Voce come carne? (yes/no)" crlf)
   (bind ?resposta (read))
   (assert (Cliente (come_carne ?resposta))))
  
(defrule GetFilhos
   (declare (salience 9))
   =>
   (printout t "Voce tem filhos?(yes/no)")
   (bind ?resposta (read))
   (assert (Cliente (tem_filho ?resposta))))

 
(defrule GetFumante
	(declare (salience 9))
   =>
   (printout t "Voce fuma?(yes/no)")
   (bind ?resposta (read))
   (assert (Cliente (fumante ?resposta))))

   
(defrule GetRestCaro
	(declare (salience 9))
   =>
   (printout t "Quer ir a um restaurante caro?(yes/no)")
   (bind ?resposta (read))
   (assert (Cliente (rest_caro ?resposta))))


; Regras pra escolher o restaurante


(defrule Damas
	(and(Preferencias (come_carne yes))
	(Preferencias (fumante no))(Cliente (rest_caro no)))
	=>
	(assert(Jogo (rest mal_passada )))
	(printout t "Restaurante Sugerido: Mal Passada, Restaurante e Acogue" crlf ))


(defrule Espetinho
	(and (Cliente (come_carne yes))
	(Cliente(rest_caro yes))
	(Cliente(fumante no)))
	=>
	(assert(Restaurante(rest espetinho)))
	(printout t "Restaurante Sugerido: Espetinho de Ouro. Comida para adultos de gosto exotico." crlf ))
	

(defrule Poaceae
	(and (Cliente(come_carne no))(Cliente(rest_caro no)))
	=>
	(assert(Restaurante(rest poaceae)))
	(printout t "Restaurante Sugerido: Poaceae. Comida vegana de produção propria." crlf))
	

(defrule Neto
	(and(Cliente(come_carne no)) (Cliente(tem_filho yes)))
	=>
	(assert (Restaurante(rest neto)))
	(printout t "Restaurante Sugerido: Familia Neto, com otimo atendimento para crianças." crlf))

	
(defrule LuckyStrike
	(Cliente(fumante yes))
	=>
	(assert(Restaurante(rest lucky_strike)))
	(printout t "Restaurante Sugerido: O Lucky Strike, amplo espaço aberto para acelerar seu cancer." crlf))

	
(defrule Cuba
	(and(Cliente(fumante yes))(Cliente(rest_caro yes))(Cliente(tem_filho no)))
	=>
	(assert(Restaurante(rest cuba)))
	(printout t "Restaurante Sugerido: Cubano's, um excelente Arroz con pollo e degustação de charutos." crlf))

	
(defrule CigarrinhoTuttiFrutti
	(and(Cliente(fumante yes))(Cliente(tem_filho yes))(Cliente(come_carne yes)))
	=>
	(assert(Restaurante(rest cigarrinho_tuttifrutti)))
	(printout t "Restaurante Sugerido: Cigarrinho TuttiFrutti, carnes nobres e fumos de qualidade para as criancas!" crlf))
	

(defrule Aniston
    (and(Cliente(come_carne no))(Cliente(tem_filho no))(Cliente(fumante no))(Cliente(rest_caro yes)))
    =>
    (assert(Restaurante(rest aniston)))
    (printout t "Restaurante Sugerido: Aniston, restaurante vegetariano, sem fumaca nem criancas chorando." crlf))


(defrule BezosBurger
    (and(Cliente(come_carne yes))(Cliente(tem_filho yes))(Cliente(fumante yes))(Cliente(rest_caro yes)))
    =>
    (assert(Restaurante(rest bezos_burger)))
    (printout t "Restaurante Sugerido: Bezos Burger Hamburgueria! Comida cara, com espaço kids e  muitos cinzeiros." crlf))


;Enderecos


(defrule Uruguaiana
	(Restaurante(rest mal_passada))
	=>
	(assert(Endereco(ende uruguaiana)))
	(printout t "Endereco: Rua Uruguaiana, 3232" crlf crlf))


(defrule PortoAlegre
	(Restaurante(rest espetinho))
	=>
	(assert(Endereco(ende porto)))
	(printout t "Endereco: Av. Porto Alegre, 132" crlf crlf))


(defrule Hamilton
	(Restaurante(rest poaceae))
	=>
	(assert(Endereco(ende hamilton1)))
	(printout t "Endereco: Rua Hamilton, 1" crlf crlf))


(defrule Joio
	(Restaurante(rest neto))
	=>
	(assert(Endereco(ende Joio)))
	(printout t "Endereco: Rua do Joio, 50" crlf crlf))


(defrule Sampoerna
	(Restaurante(rest lucky_strike))
	=>
	(assert(Endereco(ende sampoerna)))
	(printout t "Endereco: Av. Sampoerna, 1913" crlf crlf))



(defrule SouzaCruz2
	(Restaurante(rest cuba))
	=>
	(assert(Endereco(ende tabaco666)))
	(printout t "Endereco: Rua Souza Cruz, 666" crlf crlf))


(defrule SouzaCruz
	(Restaurante(rest cigarrinho_tuttifrutti))
	=>
	(assert(Endereco(ende souza_cruz)))
	(printout t "Endereco: Rua Souza Cruz, 17" crlf crlf))


(defrule Jurere
    (Restaurante(rest nobre))
    =>
    (assert(Endereco(ende jurere)))
    (printout t "Endereco: Rua Jurere Internacional, 01" crlf crlf))


(defrule Buzios
    (Restaurante(rest bezos_burger))
    =>
    (assert(Endereco(ende deodo587)))
    (printout t "Endereco: Av. dos Buzios, 201 B" crlf crlf))

(defrule titulo
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Sistema Especialista - Restaurante")
  (printout t crlf crlf))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;
;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Sintomas
  (slot ardencia_ao_urinar)
  (slot vontade_frequente_de_urinar)
  (slot urina_odor_forte)
  (slot dor_no_abdomen)
  (slot febre)
  (slot coceira)
  (slot corrimento_branco)
  (slot dor_na_relacao_sexual)
  (slot corrimento_acinzentado)
  (slot dor_no_baixo_ventre)
  (slot colicas)
  (slot fluxo_menstrual_intenso)
  (slot constipacao)
  (slot pressao_na_bexiga)
  (slot ciclo_irregular)
  (slot acne)
  (slot infertilidade))

(deftemplate Doenca
  (slot nome))

(deftemplate Tratamento
  (slot nome))

; Perguntar sintomas
(defrule get_ardencia_ao_urinar
  (declare (salience 9))
  =>
  (printout t "Você sente ardência ao urinar? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (ardencia_ao_urinar ?resposta))))

(defrule get_vontade_frequente_de_urinar
  (declare (salience 9))
  =>
  (printout t "Você sente vontade frequente de urinar? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (vontade_frequente_de_urinar ?resposta))))

(defrule get_urina_odor_forte
  (declare (salience 9))
  =>
  (printout t "Você tem urina com odor forte? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (urina_odor_forte ?resposta))))

(defrule get_dor_no_abdomen
  (declare (salience 9))
  =>
  (printout t "Você tem dor no abdômen? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (dor_no_abdomen ?resposta))))

(defrule get_febre
  (declare (salience 9))
  =>
  (printout t "Você tem febre? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (febre ?resposta))))

(defrule get_coceira
  (declare (salience 9))
  =>
  (printout t "Você tem coceira na região íntima? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (coceira ?resposta))))

(defrule get_corrimento_branco
  (declare (salience 9))
  =>
  (printout t "Você está com corrimento branco? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (corrimento_branco ?resposta))))

(defrule get_dor_na_relacao_sexual
  (declare (salience 9))
  =>
  (printout t "Você sente dor na relação sexual? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (dor_na_relacao_sexual ?resposta))))

(defrule get_corrimento_acinzentado
  (declare (salience 9))
  =>
  (printout t "Você está com corrimento acinzentado? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (corrimento_acinzentado ?resposta))))

(defrule get_dor_no_baixo_ventre
  (declare (salience 9))
  =>
  (printout t "Você sente dor no baixo ventre? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (dor_no_baixo_ventre ?resposta))))

(defrule get_colicas
  (declare (salience 9))
  =>
  (printout t "Você está com colicas? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (colicas ?resposta))))

(defrule get_fluxo_menstrual_intenso
  (declare (salience 9))
  =>
  (printout t "Você tem notado seu fluxo menstrual intenso? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (fluxo_menstrual_intenso ?resposta))))

(defrule get_constipacao
  (declare (salience 9))
  =>
  (printout t "Você tem constipação? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (constipacao ?resposta))))

(defrule get_pressao_na_bexiga
  (declare (salience 9))
  =>
  (printout t "Você tem pressão na bexiga? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (pressao_na_bexiga ?resposta))))

(defrule get_ciclo_irregular
  (declare (salience 9))
  =>
  (printout t "Você tem notado ciclo menstrual irregular? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (ciclo_irregular ?resposta))))

(defrule get_acne
  (declare (salience 9))
  =>
  (printout t "Você tem acne? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (acne ?resposta))))

(defrule get_infertilidade
  (declare (salience 9))
  =>
  (printout t "Você tem infertilidade? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (infertilidade ?resposta))))


; Regras para diagnóstico de doenças e tratamento
(defrule diagnostico_infeccao_urinaria
  (and (Sintomas (ardencia_ao_urinar sim))
       (Sintomas (vontade_frequente_de_urinar sim))
       (Sintomas (urina_odor_forte sim))
       (Sintomas (dor_no_abdomen sim)))
  =>
  (assert (Doenca (nome "Infecção urinária")))
  (assert (Tratamento (nome "A folha de goiabeira, tanchagem, açafrão e o dente de leão ajudam no tratamento da infecção urinária. Métodos recomendados: chá quente de tanchagem e açafrão, banho de assento com infusão de folha de goiabeira e dente de leão.")))
  (printout t "Diagnóstico: Infecção urinária. Tratamento sugerido: A folha de goiabeira, tanchagem, açafrão e o dente de leão ajudam no tratamento da infecção urinária. Métodos recomendados: chá quente de tanchagem e açafrão, banho de assento com infusão de folha de goiabeira e dente de leão." crlf))

(defrule diagnostico_candidiase_vaginal
  (and (Sintomas (ardencia_ao_urinar sim))
       (Sintomas (coceira sim))
       (Sintomas (corrimento_branco sim))
       (Sintomas (dor_na_relacao_sexual sim)))
  =>
  (assert (Doenca (nome "Candidíase vaginal")))
  (assert (Tratamento (nome "A folha de goiabeira, lavanda, açafrão e tanchagem ajudam no tratamento da candidíase vaginal. Métodos recomendados: banho de assento com infusão de folha de goiabeira ou lavanda; compressas; chá de lavanda; açafrão e tanchagem.")))
  (printout t "Diagnóstico: Candidíase vaginal. Tratamento sugerido: A folha de goiabeira, lavanda, açafrão e tanchagem ajudam no tratamento da candidíase vaginal. Métodos recomendados: banho de assento com infusão de folha de goiabeira ou lavanda; compressas; chá de lavanda; açafrão e tanchagem." crlf))

(defrule diagnostico_vaginose_bacteriana
  (and (Sintomas (urina_odor_forte sim))
       (Sintomas (coceira sim))
	   (Sintomas (corrimento_acinzentado sim)))
  =>
  (assert (Doenca (nome "Vaginose bacteriana")))
  (assert (Tratamento (nome "A folha de goiabeira e lavanda ajudam no tratamento da vaginose bacteriana. Métodos recomendados: banho de assento com folha de goiabeira e lavanda; compressas com infusão morna.")))
  (printout t "Diagnóstico: Vaginose bacteriana. Tratamento sugerido: A folha de goiabeira e lavanda ajudam no tratamento da vaginose bacteriana. Métodos recomendados: banho de assento com folha de goiabeira e lavanda; compressas com infusão morna." crlf))

(defrule diagnostico_cistite
  (and (Sintomas (ardencia_ao_urinar sim))
       (Sintomas (vontade_frequente_de_urinar sim))
	   (Sintomas (dor_no_baixo_ventre sim)))
  =>
  (assert (Doenca (nome "Cistite")))
  (assert (Tratamento (nome "A tanchagem, a folha de goiabaiera e o dente de leão ajudam no tratamento da cistite. Métodos recomendados: chá quente de tanchagem e dente de leão; banho de assento com folha de goiabeira.")))
  (printout t "Diagnóstico: Cistite. Tratamento sugerido: A tanchagem, a folha de goiabaiera e o dente de leão ajudam no tratamento da cistite. Métodos recomendados: chá quente de tanchagem e dente de leão; banho de assento com folha de goiabeira." crlf))

(defrule diagnostico_sop
  (and (Sintomas (ciclo_irregular sim))
       (Sintomas (acne sim))
	   (Sintomas (infertilidade sim)))
  =>
  (assert (Doenca (nome "Síndrome do Ovário Policístico (SOP)")))
  (assert (Tratamento (nome "A folha de amora e sálvia ajudam no tratamento da SOP. Métodos recomendados: chá de folha de amora e sálvia; banho de assento com sálvia.")))
  (printout t "Diagnóstico: Síndrome do Ovário Policístico (SOP). Tratamento sugerido: A folha de amora e sálvia ajudam no tratamento da SOP. Métodos recomendados: chá de folha de amora e sálvia; banho de assento com sálvia." crlf))

(defrule diagnostico_miomas
  (and (Sintomas (colicas sim))
       (Sintomas (fluxo_menstrual_intenso sim))
       (Sintomas (pressao_na_bexiga sim))
	   (Sintomas (constipacao sim)))
  =>
  (assert (Doenca (nome "Miomas")))
  (assert (Tratamento (nome "A folha de amora, artemísia, camomila e sálvia ajudam no tratamento de miomas. Métodos recomendados: chá de folha de amora, camomila e artemísia; banho de assento com camomila ou folha de amora; sálvia.")))
  (printout t "Diagnóstico: Miomas. Tratamento sugerido: A folha de amora, artemísia, camomila e sálvia ajudam no tratamento de miomas. Métodos recomendados: chá de folha de amora, camomila e artemísia; banho de assento com camomila ou folha de amora; sálvia." crlf))

(defrule diagnostico_endometriose
  (and (Sintomas (dor_na_relacao_sexual sim))
       (Sintomas (colicas sim))
	   (Sintomas (infertilidade sim)))
  =>
  (assert (Doenca (nome "Endometriose")))
  (assert (Tratamento (nome "A folha de amora, camomila, lavanda e o dente de leão ajudam no tratamento da endometriose. Métodos recomendados: chá de folha de amora, camomila elavanda; banho de assento com camomila ou lavanda; compressas mornas na região pélvica; dente de leão.")))
  (printout t "Diagnóstico: Endometriose. Tratamento sugerido: A folha de amora, camomila, lavanda e o dente de leão ajudam no tratamento da endometriose. Métodos recomendados: chá de folha de amora, camomila elavanda; banho de assento com camomila ou lavanda; compressas mornas na região pélvica; dente de leão." crlf))

; Exibir resultado final
(defrule Fim
  (Doenca (nome ?doenca))
  (Tratamento (nome ?tratamento))
  =>
  (printout t crlf crlf)
  (printout t "A doença identificada é: " ?doenca crlf)
  (printout t "Tratamento: " ?tratamento crlf))

(defrule Titulo
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Sistema Especialista em Ginecologia Natural - Diagnóstico de Doenças e Tratamento" crlf crlf))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Sintomas
  (slot ardencia_ao_urinar)
  (slot vontade_frequente_de_urinar)
  (slot urina_odor_forte)
  (slot dor_no_abdomen)
  (slot febre)
  (slot coceira)
  (slot corrimento_branco)
  (slot dor_na_relacao_sexual)
  (slot corrimento_acinzentado)
  (slot dor_no_baixo_ventre)
  (slot colicas)
  (slot fluxo_menstrual_intenso)
  (slot constipacao)
  (slot pressao_na_bexiga)
  (slot ciclo_irregular)
  (slot acne)
  (slot infertilidade))

(deftemplate Doenca
  (slot nome))

(deftemplate Tratamento
  (slot nome))

; Perguntar sintomas
(defrule get_ardencia_ao_urinar
  (declare (salience 9))
  =>
  (printout t "Você sente ardência ao urinar? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (ardencia_ao_urinar ?resposta))))

(defrule get_vontade_frequente_de_urinar
  (declare (salience 9))
  =>
  (printout t "Você sente vontade frequente de urinar? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (vontade_frequente_de_urinar ?resposta))))

(defrule get_urina_odor_forte
  (declare (salience 9))
  =>
  (printout t "Você tem urina com odor forte? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (urina_odor_forte ?resposta))))

(defrule get_dor_no_abdomen
  (declare (salience 9))
  =>
  (printout t "Você tem dor no abdômen? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (dor_no_abdomen ?resposta))))

(defrule get_febre
  (declare (salience 9))
  =>
  (printout t "Você tem febre? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (febre ?resposta))))

(defrule get_coceira
  (declare (salience 9))
  =>
  (printout t "Você tem coceira na região íntima? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (coceira ?resposta))))

(defrule get_corrimento_branco
  (declare (salience 9))
  =>
  (printout t "Você está com corrimento branco? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (corrimento_branco ?resposta))))

(defrule get_dor_na_relacao_sexual
  (declare (salience 9))
  =>
  (printout t "Você sente dor na relação sexual? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (dor_na_relacao_sexual ?resposta))))

(defrule get_corrimento_acinzentado
  (declare (salience 9))
  =>
  (printout t "Você está com corrimento acinzentado? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (corrimento_acinzentado ?resposta))))

(defrule get_dor_no_baixo_ventre
  (declare (salience 9))
  =>
  (printout t "Você sente dor no baixo ventre? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (dor_no_baixo_ventre ?resposta))))

(defrule get_colicas
  (declare (salience 9))
  =>
  (printout t "Você está com colicas? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (colicas ?resposta))))

(defrule get_fluxo_menstrual_intenso
  (declare (salience 9))
  =>
  (printout t "Você tem notado seu fluxo menstrual intenso? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (fluxo_menstrual_intenso ?resposta))))

(defrule get_constipacao
  (declare (salience 9))
  =>
  (printout t "Você tem constipação? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (constipacao ?resposta))))

(defrule get_pressao_na_bexiga
  (declare (salience 9))
  =>
  (printout t "Você tem pressão na bexiga? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (pressao_na_bexiga ?resposta))))

(defrule get_ciclo_irregular
  (declare (salience 9))
  =>
  (printout t "Você tem notado ciclo menstrual irregular? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (ciclo_irregular ?resposta))))

(defrule get_acne
  (declare (salience 9))
  =>
  (printout t "Você tem acne? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (acne ?resposta))))

(defrule get_infertilidade
  (declare (salience 9))
  =>
  (printout t "Você tem infertilidade? (sim/nao)" crlf)
  (bind ?resposta (read))
  (assert (Sintomas (infertilidade ?resposta))))


; Regras para diagnóstico de doenças e tratamento
(defrule diagnostico_infeccao_urinaria
  (and (Sintomas (ardencia_ao_urinar sim))
       (Sintomas (vontade_frequente_de_urinar sim))
       (Sintomas (urina_odor_forte sim))
       (Sintomas (dor_no_abdomen sim)))
  =>
  (assert (Doenca (nome "Infecção urinária")))
  (assert (Tratamento (nome "A folha de goiabeira, tanchagem, açafrão e o dente de leão ajudam no tratamento da infecção urinária. Métodos recomendados: chá quente de tanchagem e açafrão, banho de assento com infusão de folha de goiabeira e dente de leão.")))
  (printout t "Diagnóstico: Infecção urinária. Tratamento sugerido: A folha de goiabeira, tanchagem, açafrão e o dente de leão ajudam no tratamento da infecção urinária. Métodos recomendados: chá quente de tanchagem e açafrão, banho de assento com infusão de folha de goiabeira e dente de leão." crlf))

(defrule diagnostico_candidiase_vaginal
  (and (Sintomas (ardencia_ao_urinar sim))
       (Sintomas (coceira sim))
       (Sintomas (corrimento_branco sim))
       (Sintomas (dor_na_relacao_sexual sim)))
  =>
  (assert (Doenca (nome "Candidíase vaginal")))
  (assert (Tratamento (nome "A folha de goiabeira, lavanda, açafrão e tanchagem ajudam no tratamento da candidíase vaginal. Métodos recomendados: banho de assento com infusão de folha de goiabeira ou lavanda; compressas; chá de lavanda; açafrão e tanchagem.")))
  (printout t "Diagnóstico: Candidíase vaginal. Tratamento sugerido: A folha de goiabeira, lavanda, açafrão e tanchagem ajudam no tratamento da candidíase vaginal. Métodos recomendados: banho de assento com infusão de folha de goiabeira ou lavanda; compressas; chá de lavanda; açafrão e tanchagem." crlf))

(defrule diagnostico_vaginose_bacteriana
  (and (Sintomas (urina_odor_forte sim))
       (Sintomas (coceira sim))
	   (Sintomas (corrimento_acinzentado sim)))
  =>
  (assert (Doenca (nome "Vaginose bacteriana")))
  (assert (Tratamento (nome "A folha de goiabeira e lavanda ajudam no tratamento da vaginose bacteriana. Métodos recomendados: banho de assento com folha de goiabeira e lavanda; compressas com infusão morna.")))
  (printout t "Diagnóstico: Vaginose bacteriana. Tratamento sugerido: A folha de goiabeira e lavanda ajudam no tratamento da vaginose bacteriana. Métodos recomendados: banho de assento com folha de goiabeira e lavanda; compressas com infusão morna." crlf))

(defrule diagnostico_cistite
  (and (Sintomas (ardencia_ao_urinar sim))
       (Sintomas (vontade_frequente_de_urinar sim))
	   (Sintomas (dor_no_baixo_ventre sim)))
  =>
  (assert (Doenca (nome "Cistite")))
  (assert (Tratamento (nome "A tanchagem, a folha de goiabaiera e o dente de leão ajudam no tratamento da cistite. Métodos recomendados: chá quente de tanchagem e dente de leão; banho de assento com folha de goiabeira.")))
  (printout t "Diagnóstico: Cistite. Tratamento sugerido: A tanchagem, a folha de goiabaiera e o dente de leão ajudam no tratamento da cistite. Métodos recomendados: chá quente de tanchagem e dente de leão; banho de assento com folha de goiabeira." crlf))

(defrule diagnostico_sop
  (and (Sintomas (ciclo_irregular sim))
       (Sintomas (acne sim))
	   (Sintomas (infertilidade sim)))
  =>
  (assert (Doenca (nome "Síndrome do Ovário Policístico (SOP)")))
  (assert (Tratamento (nome "A folha de amora e sálvia ajudam no tratamento da SOP. Métodos recomendados: chá de folha de amora e sálvia; banho de assento com sálvia.")))
  (printout t "Diagnóstico: Síndrome do Ovário Policístico (SOP). Tratamento sugerido: A folha de amora e sálvia ajudam no tratamento da SOP. Métodos recomendados: chá de folha de amora e sálvia; banho de assento com sálvia." crlf))

(defrule diagnostico_miomas
  (and (Sintomas (colicas sim))
       (Sintomas (fluxo_menstrual_intenso sim))
       (Sintomas (pressao_na_bexiga sim))
	   (Sintomas (constipacao sim)))
  =>
  (assert (Doenca (nome "Miomas")))
  (assert (Tratamento (nome "A folha de amora, artemísia, camomila e sálvia ajudam no tratamento de miomas. Métodos recomendados: chá de folha de amora, camomila e artemísia; banho de assento com camomila ou folha de amora; sálvia.")))
  (printout t "Diagnóstico: Miomas. Tratamento sugerido: A folha de amora, artemísia, camomila e sálvia ajudam no tratamento de miomas. Métodos recomendados: chá de folha de amora, camomila e artemísia; banho de assento com camomila ou folha de amora; sálvia." crlf))

(defrule diagnostico_endometriose
  (and (Sintomas (dor_na_relacao_sexual sim))
       (Sintomas (colicas sim))
	   (Sintomas (infertilidade sim)))
  =>
  (assert (Doenca (nome "Endometriose")))
  (assert (Tratamento (nome "A folha de amora, camomila, lavanda e o dente de leão ajudam no tratamento da endometriose. Métodos recomendados: chá de folha de amora, camomila elavanda; banho de assento com camomila ou lavanda; compressas mornas na região pélvica; dente de leão.")))
  (printout t "Diagnóstico: Endometriose. Tratamento sugerido: A folha de amora, camomila, lavanda e o dente de leão ajudam no tratamento da endometriose. Métodos recomendados: chá de folha de amora, camomila elavanda; banho de assento com camomila ou lavanda; compressas mornas na região pélvica; dente de leão." crlf))

; Exibir resultado final
(defrule Fim
  (Doenca (nome ?doenca))
  (Tratamento (nome ?tratamento))
  =>
  (printout t crlf crlf)
  (printout t "A doença identificada é: " ?doenca crlf)
  (printout t "Tratamento: " ?tratamento crlf))

(defrule Titulo
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Sistema Especialista em Ginecologia Natural - Diagnóstico de Doenças e Tratamento" crlf crlf))