%itemLoja: nome, pre�o
:- dynamic itemLoja/2.

itemLoja("A�ucar", 1).
itemLoja("Caf�", 1).
itemLoja("Leite", 1).
itemLoja("Canela", 2).
itemLoja("Chocolate", 2).
itemLoja("Ortela", 2).

%estoque: produto, quantidade
:- dynamic estoque/2.

%itemCardapio: id, pre�o, tempo de preparo, nome
:- dynamic itemCardapio/3.

%livroReceitas: nome, lista de ingredientes
:- dynamic livroReceitas/2.

%adicionar RegistreDespesa
comprarIngrediente(Nome, Qtd) :-
    (
      itemLoja(Nome,_),
      (
        (
          estoque(Nome, QtdExistente),
          Aux is Qtd+QtdExistente,
          retract(estoque(Nome, QtdExistente)),
          assertz(estoque(Nome, Aux))
        );
          assertz(estoque(Nome, Qtd))
      ),
      format("Compra realizada com sucesso!"),true,!
    );
    format("O produto n�o est� dispon�vel na loja."),false,!.


usarIngrediente(Nome, Qtd) :-
    (
      %verifica se o ingrediente existe no estoque, se n�o existir, realiza a compra
      (
        estoque(Nome, QtdExistente),
        QtdExistente >= Qtd,
        Aux is QtdExistente - Qtd,
        retract(estoque(Nome, QtdExistente)),
        assertz(estoque(Nome, Aux))
      )
      ;
      (
        comprarIngrediente(Nome, Qtd),
        Aux is 0,
        retract(estoque(Nome, Qtd)),
        assertz(estoque(Nome, Aux))
      )
    ).

addItemCardapio(Preco, Tempo, Nome, Ingredientes) :-
    (
      Ingredientes = [],
      format("Voc� n�o pode fornecer uma lista vazia de ingredientes."),
      !
    );
    (
      (
        itemCardapio(_,_,Nome),
        retract(itemCardapio(_,_,Nome)),
        retract(livroReceitas(Nome, Ingredientes)),
        assertz(itemCardapio(Preco,Tempo,Nome)),
        assertz(livroReceitas(Nome, Ingredientes))
      )
      ;
      assertz(itemCardapio(Preco,Tempo,Nome)),
      assertz(livroReceitas(Nome, Ingredientes))
    ).
