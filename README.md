# Executando um Projeto Dune OCaml

## 1. Configurando o Ambiente

### Instalando OPAM

OPAM (OCaml Package Manager) é necessário para gerenciar instalações e dependências do OCaml. Instale-o usando:

```sh
sudo apt update
sudo apt install -y opam
```

### Instalando OCaml

Crie um novo switch OCaml com a versão desejada e carregue o ambiente:

```sh
opam switch create 5.2.0
eval $(opam env)
export PATH=$PATH:~/.opam/default/bin
```

### Instalando Dependências

Certifique-se de que todas as dependências necessárias estão instaladas:

```sh
opam install csv sqlite3 lwt cohttp-lwt-unix lwt_ssl
```

## 2. Construindo e Executando o Projeto

### Construindo o Projeto

Use o Dune, o sistema de build do OCaml, para compilar o projeto:

```sh
dune build
```

### Executando o Projeto

Execute o binário principal usando:

```sh
dune exec bin/main.exe
```

# Relatório do Projeto Ocaml ETL

## 1. Introdução

O objetivo deste projeto é realizar um processo completo de ETL - Extract, Transform e Load a partir de dados sobre pedidos e produtos. Dessa forma, gerar as saídas esperadas seguindo as três etapas citadas acima. Primeiramente, extrair dados vindos de CSVs que simulam tabelas de um banco de dados, em seguida, fazer as transformações necessárias e concluir salvando esses dados em novos CSVs.
Ao longo deste relatório serão discutidas a fundo as etapas, dificuldades e soluções para conclusão do ETL.

## 2. Leitura dos Dados

Nesta etapa serão abordados os processos de extração de dados, passando por abertura de documentos, tipagem e escrita de informações numa estrutura de dados adequada.

Para leitura de dados, foi necessário realizar uma análise dos datasets recebidos:

- `order.csv` - documento que contém ID de um pedido e informações sobre cliente, data e status.
- `order_item.csv` - documento com os produtos de cada compra. Possui informações como ID do pedido, quantidade, preço e taxa.

Com essas informações foram criados os tipos `order` e `item`, com seus respectivos campos e tipagens.

Com os dados devidamente categorizados, foi possível passar para a próxima etapa, instalar a biblioteca CSV e escrever as funções `read_csv` e `parse_row`, seguindo a estrutura main e helper functions. A primeira delas, `read_csv`, abre um arquivo, transforma as linhas do CSV em lista e aplica `parse_row` em cada uma delas. `parse_row` funciona como uma função auxiliar que mapeia os itens vindos da linha do CSV em um record, utilizando tipagem para cada campo. Exemplo `order_id: int`.

Esse processo foi realizado de forma igual para `orders` e `items`, escritos em arquivos separados `item_reader.ml` e `order_reader.ml`. Processos impuros, como abertura de documentos e exibição de erros, ficaram isolados devido ao uso de funções auxiliares.

Durante essa fase, foram testadas algumas abordagens de organização do projeto. A proposta inicial foi criar uma lib para cada tipo de funcionalidade, contudo, gerou problemas de importação dos módulos. A solução encontrada foi inserir todas as implementações na pasta `bin`, junto com o arquivo `main.ml`. Além disso, foi criado um arquivo `types.ml` para armazenar de forma única todos os tipos criados e importá-los quando necessário.

Como conclusão do processo de leitura, foi possível converter todos os dados da entrada em listas de records - `order` e `item`, para seguir para o processamento.

## 3. Processamento e Transformação dos Dados

### 3.1 Junção

Para essa etapa a proposta foi realizar um *inner join* entre os dados. Dessa forma, foi necessária a criação do tipo `combined`. Ele consiste em uma junção entre `order` e `item`, pois dessa forma evita repetição de código e contorna uma limitação do OCaml em lidar com tipos que tenham campos de mesmos nomes.

Internamente, o processo foi mapear a lista de `orders` em uma tupla `(order_id, order)` e realizar um `filter_map` em `item list`. Para cada item, encontrar seu respectivo `order` usando `assoc_opt` em `order_id` e criar um `Joined` entre eles.

### 3.2 Filtragem

Outra necessidade do cliente era parametrizar a saída de acordo com o `status` e `origin` específicos dos pedidos. Assim, foi criada a função `filter_by` que recebe as entradas pedidas e realiza um filtro na lista de dados combinados. Para essa função, a passagem de valores `status` e `origin` são opcionais, para os casos em que a filtragem não é necessária.

### 3.3 Processamento de Quantidade

Nesta etapa, foi necessário calcular o valor total e o montante de imposto para cada item. Para isso, a função `items_amount_processing` realiza um `map` em `combined` e, para cada item, multiplica sua quantidade pelo preço unitário, gerando o valor total. Da mesma forma, o imposto é calculado multiplicando o valor total pela taxa de imposto do item.

### 3.4 Agrupamento por ID do Pedido

Para a etapa final do processamento, foi necessário realizar a operação de agrupamento entre todos os `Joined { order, item }` da lista de `combined`. O processo escolhido foi utilizar o método `fold_left` com um acumulador - uma lista de tuplas `(order.id, combined)`. O retorno dessa função é um `combined` para manter a consistência entre funções.

Uma possível melhoria seria implementar um *hashmap* para otimizar a busca no acumulador, reduzindo a complexidade computacional.

## 4. Geração e Salvamento dos Resultados

Após o processamento dos dados, acontece a transformação da lista de `combined` em um formato adequado para a saída. As funções `generate_output` e `generate_monthly_output` convertem os dados combinados para o tipo `output`. Esses dados são então exportados para arquivos CSV por meio das funções `to_csv` e `to_csv_monthly`.

## 5. Requisitos Extras Atingidos

- Projeto realizado utilizando *Dune*;
- Todas as funções foram documentadas seguindo o formato *docstring*;
- Saída adicional contendo a média de receita e impostos pagos agrupados por mês e ano (`monthly_output.csv`);
- Outputs salvos em *SQLite3*;
- Leitura dos dados de entrada em um arquivo estático na internet (*exposto via HTTP*).

## 6. Conclusão

O projeto desenvolvido conseguiu implementar com sucesso uma pipeline completa de ETL utilizando OCaml. Durante o desenvolvimento, foram enfrentados desafios como a manipulação de tipos com campos de nomes repetidos e otimização do agrupamento de records. 

Como possíveis melhorias futuras, poderiam ser exploradas otimizações no agrupamento de dados, bem como a utilização de estruturas de dados mais eficientes como `Hashtbl` para melhorar o desempenho.

O projeto cumpriu seus objetivos ao demonstrar uma abordagem funcional para ETL utilizando OCaml, apresentando uma solução flexível e bem estruturada para processamento de dados tabulares.
