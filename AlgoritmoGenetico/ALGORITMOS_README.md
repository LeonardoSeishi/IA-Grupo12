# Algoritmo Genético para TSP

Este diretório contém a implementação do Algoritmo Genético para o Problema do Caixeiro Viajante (TSP) utilizando a biblioteca PyGAD.

## Arquivo Principal

### `tsp_ag.py` - Implementação com PyGAD
**Biblioteca:** [PyGAD](https://pygad.readthedocs.io/en/latest/)

**Instalação:**
```bash
# Opção 1: Instalação manual
pip install pygad numpy matplotlib

# Opção 2: Usando requirements.txt (recomendado)
pip install -r requirements.txt

# Opção 3: Versões mínimas
pip install -r requirements-minimal.txt
```
 
## Como Executar

Para testar o programa, temos arquivos de teste na pasta 'G'. Para executar, pode-se escolher entre as opções:

| Comando | Descrição |
|---------|-----------|
| `python3 tsp_ag.py` | Executa todas as instâncias de todos os diretórios |
| `python3 tsp_ag.py <arquivo.txt>` | Executa uma instância específica com visualização |
| `python3 tsp_ag.py <diretório>` | Executa todas as instâncias de um diretório |
| `python3 tsp_ag.py --help` | Mostra instruções de uso |

## Dependências

- `numpy` - Operações numéricas
- `matplotlib` - Visualizações (apenas para instância única)
- `pygad` - Algoritmo genético
- `instance_reader.py` - Leitor de instâncias ETSP (módulo local)
