"""
Arquivo de testes e experimentos para o Algoritmo Genético do TSP
Trabalho de Inteligência Artificial - Grupo 12

Este arquivo contém experimentos e testes para o algoritmo genético
implementado para resolver o problema clássico do caixeiro viajante.
"""

from tsp import TSPGeneticAlgorithm
from instance_reader import ETSPInstance
import os
import time

def run_tsp_experiment(instance_file: str, config: dict):
    """
    Executa um experimento com o algoritmo genético
    
    Args:
        instance_file: Caminho para o arquivo da instância
        config: Configurações do algoritmo genético
    """
    print(f"\n{'='*60}")
    print(f"Executando experimento com: {os.path.basename(instance_file)}")
    print(f"{'='*60}")
    
    # Carregar instância
    instance = ETSPInstance(instance_file)
    
    # Criar algoritmo genético
    tsp_ga = TSPGeneticAlgorithm(
        instance=instance,
        population_size=config['population_size'],
        mutation_rate=config['mutation_rate'],
        crossover_rate=config['crossover_rate'],
        max_generations=config['max_generations'],
        elitism_count=config['elitism_count']
    )
    
    print(f"Configuração:")
    print(f"- Número de cidades: {len(tsp_ga.cities)}")
    print(f"- Tamanho da população: {config['population_size']}")
    print(f"- Taxa de mutação: {config['mutation_rate']}")
    print(f"- Taxa de cruzamento: {config['crossover_rate']}")
    print(f"- Máximo de gerações: {config['max_generations']}")
    print(f"- Elitismo: {config['elitism_count']}")
    
    # Executar algoritmo
    start_time = time.time()
    results = tsp_ga.evolve()
    execution_time = time.time() - start_time
    
    # Resultados
    print(f"\nResultados:")
    print(f"- Melhor distância encontrada: {results['best_distance']:.2f}")
    print(f"- Tempo de execução: {execution_time:.2f} segundos")
    print(f"- Melhor rota: {results['best_individual']}")
    
    return results, execution_time, tsp_ga

def compare_configurations():
    """Compara diferentes configurações do algoritmo genético"""
    
    # Configurações para testar
    configs = [
        {
            'name': 'Configuração Padrão',
            'population_size': 100,
            'mutation_rate': 0.02,
            'crossover_rate': 0.8,
            'max_generations': 300,
            'elitism_count': 5
        },
        {
            'name': 'População Maior',
            'population_size': 200,
            'mutation_rate': 0.02,
            'crossover_rate': 0.8,
            'max_generations': 200,
            'elitism_count': 10
        },
        {
            'name': 'Alta Mutação',
            'population_size': 100,
            'mutation_rate': 0.05,
            'crossover_rate': 0.8,
            'max_generations': 300,
            'elitism_count': 5
        },
        {
            'name': 'Baixa Mutação',
            'population_size': 100,
            'mutation_rate': 0.01,
            'crossover_rate': 0.9,
            'max_generations': 300,
            'elitism_count': 8
        }
    ]
    
    # Arquivo de teste
    test_file = "G/n20w120s5/n20w120s5.1.txt"
    
    if not os.path.exists(test_file):
        print(f"Arquivo de teste não encontrado: {test_file}")
        return
    
    results_summary = []
    
    for config in configs:
        print(f"\n{'*'*80}")
        print(f"TESTANDO: {config['name']}")
        print(f"{'*'*80}")
        
        try:
            results, exec_time, tsp_ga = run_tsp_experiment(test_file, config)
            
            results_summary.append({
                'config': config['name'],
                'best_distance': results['best_distance'],
                'execution_time': exec_time,
                'cities_count': len(tsp_ga.cities)
            })
            
        except Exception as e:
            print(f"Erro ao processar configuração {config['name']}: {e}")
    
    # Resumo comparativo
    print(f"\n{'='*80}")
    print("COMPARAÇÃO DE CONFIGURAÇÕES")
    print(f"{'='*80}")
    print(f"{'Configuração':<20} {'Melhor Distância':<15} {'Tempo (s)':<10} {'Cidades':<8}")
    print("-" * 80)
    
    for result in results_summary:
        print(f"{result['config']:<20} {result['best_distance']:<15.2f} "
              f"{result['execution_time']:<10.2f} {result['cities_count']:<8}")

def test_multiple_instances():
    """Testa o algoritmo em múltiplas instâncias"""
    
    # Configuração padrão
    config = {
        'population_size': 100,
        'mutation_rate': 0.02,
        'crossover_rate': 0.8,
        'max_generations': 300,
        'elitism_count': 5
    }
    
    # Arquivos de teste disponíveis
    test_files = [
        "G/n20w120s5/n20w120s5.1.txt",
        "G/n20w140s5/n20w140s5.1.txt", 
        "G/n20w160s5/n20w160s5.1.txt",
        "G/n20w180s5/n20w180s5.1.txt",
        "G/n20w200s5/n20w200s5.1.txt"
    ]
    
    results_summary = []
    
    print(f"\n{'='*80}")
    print("TESTE EM MÚLTIPLAS INSTÂNCIAS")
    print(f"{'='*80}")
    
    for test_file in test_files:
        if os.path.exists(test_file):
            try:
                results, exec_time, tsp_ga = run_tsp_experiment(test_file, config)
                
                results_summary.append({
                    'file': os.path.basename(test_file),
                    'best_distance': results['best_distance'],
                    'execution_time': exec_time,
                    'cities_count': len(tsp_ga.cities)
                })
                
            except Exception as e:
                print(f"Erro ao processar {test_file}: {e}")
        else:
            print(f"Arquivo não encontrado: {test_file}")
    
    # Resumo dos resultados
    print(f"\n{'='*80}")
    print("RESUMO - MÚLTIPLAS INSTÂNCIAS")
    print(f"{'='*80}")
    print(f"{'Instância':<25} {'Cidades':<8} {'Melhor Distância':<15} {'Tempo (s)':<10}")
    print("-" * 80)
    
    for result in results_summary:
        print(f"{result['file']:<25} {result['cities_count']:<8} "
              f"{result['best_distance']:<15.2f} {result['execution_time']:<10.2f}")

def demo_basic_usage():
    """Demonstração básica de uso do algoritmo"""
    
    print(f"\n{'='*80}")
    print("DEMONSTRAÇÃO BÁSICA - ALGORITMO GENÉTICO TSP")
    print(f"{'='*80}")
    
    # Usar primeira instância disponível
    test_files = [
        "G/n20w120s5/n20w120s5.1.txt",
        "G/n20w140s5/n20w140s5.1.txt"
    ]
    
    instance_file = None
    for file in test_files:
        if os.path.exists(file):
            instance_file = file
            break
    
    if not instance_file:
        print("Nenhuma instância de teste encontrada!")
        return
    
    # Carregar instância
    instance = ETSPInstance(instance_file)
    print(f"Instância carregada: {os.path.basename(instance_file)}")
    print(f"Número de clientes: {instance.n}")
    print(f"Número de estações de recarga (ignoradas): {instance.m}")
    
    # Criar e executar algoritmo genético
    tsp_ga = TSPGeneticAlgorithm(
        instance=instance,
        population_size=50,
        mutation_rate=0.02,
        crossover_rate=0.8,
        max_generations=200,
        elitism_count=5
    )
    
    print(f"\nCidades no TSP: {tsp_ga.cities}")
    print("Executando algoritmo genético...")
    
    start_time = time.time()
    results = tsp_ga.evolve()
    execution_time = time.time() - start_time
    
    print(f"\nResultados:")
    print(f"- Melhor rota: {results['best_individual']}")
    print(f"- Melhor distância: {results['best_distance']:.2f}")
    print(f"- Tempo de execução: {execution_time:.2f} segundos")
    
    # Plotar convergência
    try:
        tsp_ga.plot_convergence()
    except Exception as e:
        print(f"Erro ao plotar gráfico: {e}")

def main():
    """Função principal - menu de opções"""
    
    print("="*80)
    print("ALGORITMO GENÉTICO PARA TSP - MENU DE TESTES")
    print("="*80)
    print("1. Demonstração básica")
    print("2. Comparar configurações")
    print("3. Testar múltiplas instâncias")
    print("4. Executar todos os testes")
    
    try:
        choice = input("\nEscolha uma opção (1-4): ").strip()
        
        if choice == "1":
            demo_basic_usage()
        elif choice == "2":
            compare_configurations()
        elif choice == "3":
            test_multiple_instances()
        elif choice == "4":
            demo_basic_usage()
            compare_configurations()
            test_multiple_instances()
        else:
            print("Opção inválida! Executando demonstração básica...")
            demo_basic_usage()
            
    except KeyboardInterrupt:
        print("\n\nExecução interrompida pelo usuário.")
    except Exception as e:
        print(f"Erro durante execução: {e}")
        print("Executando demonstração básica como fallback...")
        demo_basic_usage()

if __name__ == "__main__":
    main()