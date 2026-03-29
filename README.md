# EP1 - Codificação de Huffman

Paradigmas de Linguagem de Programação 

Prof. Antonio Luiz Basile

| Aluno | RA |
| :--- | :--- |
| Fabyani Tiva Yan | 10431835 |
| Rafael Araujo Cabral Moreira | 10441919 |

## Introdução Teórica e Aprendizados
O algoritmo de Huffman é um método de compressão de dados sem perdas que se baseia na frequência de ocorrência de cada símbolo. Símbolos que aparecem com mais frequência recebem códigos binários menores, enquanto os menos frequentes recebem códigos maiores (prefix codes). Isso garante uma otimização no tamanho final do arquivo.

Neste projeto, implementar o algoritmo utilizando **Common Lisp** foi uma excelente oportunidade para aplicar os conceitos do paradigma funcional. Os principais pontos de aprendizado foram:
* **Recursão em Árvores:** A lógica de percorrer a árvore (esquerda e direita) para montar o dicionário de bits usando funções recursivas.
* **Estruturas de Dados Lisp:** O uso de `defstruct` para modelar os nós da árvore e `make-hash-table` para calcular as frequências de forma eficiente, substituindo as tradicionais variáveis de estado imperativas.
* **Manipulação de Listas:** A utilização do `loop` e funções de alta ordem (como `maphash` e `sort`) para tratar e ordenar as frequências antes da montagem da árvore.

## Pontos Relevantes do Código
O nosso código foi estruturado em passos lógicos seguindo a especificação do EP:
1. **Limpeza e Padronização (`limpar-txt`):** Removemos pontuações e acentos, mantendo apenas letras do alfabeto latino e números, transformando tudo em minúsculas para padronizar a contagem.
2. **Tabela de Frequência (`contar-freq`):** Utilizamos uma *Hash Table* para varrer o texto uma única vez, incrementando a contagem de cada caractere encontrado.
3. **Árvore de Huffman (`montar-arv`):** Convertendo a hash table em uma lista de nós, a função ordena os elementos pelas menores frequências e os agrupa de dois em dois, somando seus valores para formar os nós pais até obtermos a raiz da árvore.
4. **Geração e Escrita de Códigos (`gerar-cods-aux` e `codificar-txt`):** Uma travessia em profundidade mapeia os caminhos (0 para a esquerda, 1 para a direita) gerando a string final codificada.

## Testes Realizados
Para validar a eficácia do algoritmo e do programa, utilizamos os seguintes arquivos de teste:
* **Entrada:** `entrada.txt` contendo a mensagem "Ola mundo 123! Teste de Huffman." (25 caracteres após a limpeza).
* **Saída:** O algoritmo identificou as frequências (ex: a letra 'e' apareceu 3 vezes e ganhou o código `011`) e gerou o arquivo `saida.txt`.
* **Resultado da Compressão:** O texto original foi codificado em apenas **97 bits**, comprovando o sucesso na compressão de dados.

## Informações do Ambiente e Execução
O projeto foi desenvolvido e testado utilizando o ambiente de desenvolvimento do **GitHub Codespaces**, com as seguintes especificações técnicas:

### Detalhes do Ambiente (Hardware e SO)
* **Sistema Operacional:** Ubuntu Linux (Kernel 6.8.0-1044-azure)
* **Arquitetura:** x86_64
* **Processador:** AMD EPYC 7763 64-Core Processor
* **CPUs disponíveis:** 2 (com 2 Threads por núcleo)
* **Memória RAM:** ~7.8 GB

### Detalhes de Software
* **Linguagem:** Common Lisp
* **Compilador utilizado:** SBCL (Steel Bank Common Lisp)

### Instalação (Linux/Codespace)
Atualize os pacotes do sistema e instale o compilador:
```bash
sudo apt-get update
```
```bash
sudo apt-get install sbcl
```

### Como Executar
Com o compilador instalado, execute:
```bash
sbcl --script huffman_plp.lisp
```

O programa iniciará no terminal. Digite o nome do arquivo de entrada (ex: `entrada.txt`) e o nome do arquivo de saída que deseja gerar (ex: `saida.txt`).
