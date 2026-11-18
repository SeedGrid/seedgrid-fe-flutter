## Não lançado — 2026-11-17

* Botão `danger` e cor `info` com texto BRANCO nos dois modos (fundo escurecido só o necessário, mesma fórmula do React); `onInfo` passa a ser branco. `maxWhiteTextSteps` sobe para 45.
* Vermelho de erro com texto BRANCO: `darkenForWhiteText` (novo) escurece a cor só o necessário para o branco alcançar 4,5:1, aplicado ao degrau 500 de `error` (`onError` passa a ser sempre branco, claro e escuro). Antes o número do selo `danger` saía preto sobre o vermelho. Mesma fórmula do React.
* A cor de destaque tem contraste mínimo de 4,5:1 garantido, com a mesma fórmula do React: texto sobre fundo, texto do contorno e anel de foco; o fundo cheio de botão usa a cor pura da semente.

## 0.0.1

* TODO: Describe initial release.
