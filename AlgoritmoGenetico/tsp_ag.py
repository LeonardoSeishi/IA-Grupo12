import numpy as np
import matplotlib.pyplot as plt
import random
import pygad
from typing import List, Dict
from instance_reader import ETSPInstance
import os
import time

class TSPGeneticAlgorithm:
    def __init__(self, instance: ETSPInstance, population_size=50, mutation_rate=0.1, crossover_rate=0.8, generations=100):
        """
        Algoritmo Genético para Problema do Caixeiro Viajante usando PyGAD
        
        Args:
            instance: Instância do ETSP (ignorando estações de recarga)
            population_size: Tamanho da população
            mutation_rate: Taxa de mutação
            crossover_rate: Taxa de crossover
            generations: Número de gerações
        """
        self.instance = instance
        self.population_size = population_size
        self.mutation_rate = mutation_rate
        self.crossover_rate = crossover_rate
        self.generations = generations
        
        self.valid_nodes = [0] + list(range(1, instance.n + 1))
        self.num_nodes = len(self.valid_nodes)
        
        self.distance_matrix = self._build_reduced_distance_matrix()
        
        self.best_fitness_history = []
        self.avg_fitness_history = []
        
        self.ga_instance = None
        
    def _build_reduced_distance_matrix(self) -> np.ndarray:
        """Constrói matriz de distâncias apenas para depósito e clientes"""
        matrix = np.zeros((self.num_nodes, self.num_nodes))
        for i, node_i in enumerate(self.valid_nodes):
            for j, node_j in enumerate(self.valid_nodes):
                matrix[i][j] = self.instance.get_distance(node_i, node_j)
        return matrix
    
    def _get_node_index(self, node_id: int) -> int:
        """Retorna o índice na matriz reduzida para um ID de nó"""
        return self.valid_nodes.index(node_id)
    
    def fitness_function(self, ga_instance, solution, solution_idx):
        """
        Função de fitness para PyGAD
        PyGAD usa permutação dos índices dos clientes (sem depósito)
        """
        route = [0] + [self.valid_nodes[int(gene)] for gene in solution] + [0]
        
        total_distance = 0
        for i in range(len(route) - 1):
            from_idx = self._get_node_index(route[i])
            to_idx = self._get_node_index(route[i + 1])
            total_distance += self.distance_matrix[from_idx][to_idx]
        
        return -total_distance
    
    def on_generation(self, ga_instance):
        """Callback chamado a cada geração"""
        generation = ga_instance.generations_completed
        fitness = ga_instance.best_solution()[1]
        
        self.best_fitness_history.append(fitness)
        
        population_fitness = ga_instance.last_generation_fitness
        avg_fitness = np.mean(population_fitness)
        self.avg_fitness_history.append(avg_fitness)
        
        if hasattr(self, 'verbose') and self.verbose and generation % 10 == 0:
            distance = -fitness
            print(f"Geração {generation}: Melhor Fitness = {fitness:.2f}, "
                  f"Distância = {distance:.2f}")
    
    def calculate_distance(self, route: List[int]) -> float:
        """Calcula distância total de uma rota"""
        total_distance = 0
        for i in range(len(route) - 1):
            from_idx = self._get_node_index(route[i])
            to_idx = self._get_node_index(route[i + 1])
            total_distance += self.distance_matrix[from_idx][to_idx]
        return total_distance
    
    def run(self) -> Dict:
        if hasattr(self, 'verbose') and self.verbose:
            print("Executando Algoritmo Genético")
        
        num_genes = len(self.valid_nodes) - 1
        
        gene_space = list(range(1, num_genes + 1))
        
        self.ga_instance = pygad.GA(
            num_generations=self.generations,
            num_parents_mating=int(self.population_size * 0.5),
            fitness_func=self.fitness_function,
            sol_per_pop=self.population_size,
            num_genes=num_genes,
            gene_space=gene_space,
            parent_selection_type="tournament",
            K_tournament=3,
            crossover_type="single_point",
            mutation_type="swap",
            mutation_probability=self.mutation_rate,
            on_generation=self.on_generation,
            gene_type=int,
            allow_duplicate_genes=False,
            stop_criteria=["saturate_10"]
        )
        
        self.ga_instance.run()
        
        solution, solution_fitness, solution_idx = self.ga_instance.best_solution()
        
        best_route = [0] + [self.valid_nodes[int(gene)] for gene in solution] + [0]
        best_distance = -solution_fitness
        
        results = {
            'best_route': best_route,
            'best_fitness': solution_fitness,
            'best_distance': best_distance,
            'best_fitness_history': self.best_fitness_history,
            'avg_fitness_history': self.avg_fitness_history,
            'generations_completed': self.ga_instance.generations_completed
        }
        
        return results
    
    def plot_results(self, results: Dict):
        """Plota resultados da execução"""
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5))
        distances = [-f for f in results['best_fitness_history']]
        avg_distances = [-f for f in results['avg_fitness_history']]
        
        ax1.plot(distances, label='Melhor Distância', linewidth=2)
        ax1.plot(avg_distances, label='Distância Média', alpha=0.7)
        ax1.set_xlabel('Geração')
        ax1.set_ylabel('Distância')
        ax1.set_title('Convergência do Algoritmo Genético (PyGAD)')
        ax1.legend()
        ax1.grid(True, alpha=0.3)
        
        # Plot da melhor rota
        best_route = results['best_route']
        coordinates = []
        for node_id in best_route:
            node_info = self.instance.get_node_info(node_id)
            coordinates.append((node_info['x'], node_info['y']))
        
        x_coords = [coord[0] for coord in coordinates]
        y_coords = [coord[1] for coord in coordinates]
        
        ax2.plot(x_coords, y_coords, 'o-', markersize=8, linewidth=2)
        ax2.scatter(x_coords, y_coords, s=100, c='red', zorder=5)
        
        # Anotações
        for i, (x, y) in enumerate(coordinates):
            ax2.annotate(f'{best_route[i]}', (x, y), xytext=(5, 5), 
                        textcoords='offset points', fontweight='bold')
        
        ax2.set_xlabel('Coordenada X')
        ax2.set_ylabel('Coordenada Y')
        ax2.set_title(f'Melhor Rota - Distância: {results["best_distance"]:.2f}')
        ax2.grid(True, alpha=0.3)
        
        plt.tight_layout()
        plt.show()
    
    def print_detailed_results(self, results: Dict):
        """Imprime resultados detalhados"""
        print("\n" + "="*60)
        print("RESULTADOS FINAIS - ALGORITMO GENÉTICO (PyGAD)")
        print("="*60)
        print(f"Melhor rota encontrada: {results['best_route']}")
        print(f"Distância total: {results['best_distance']:.2f}")
        print(f"Fitness da melhor solução: {results['best_fitness']:.2f}")
        print(f"Gerações completadas: {results['generations_completed']}")
        print(f"Número de clientes: {self.instance.n}")
        print(f"Tamanho da população: {self.population_size}")
        print(f"Taxa de mutação: {self.mutation_rate}")
        print("Operadores utilizados:")
        print("  - Seleção: Tournament (K=3)")
        print("  - Crossover: Single Point")
        print("  - Mutação: Swap Mutation")
        print("  - Critério de parada: Estagnação por 10 gerações")

def run_multiple_instances():
    """Executa o algoritmo genético em múltiplas instâncias"""
    import os
    import time
    
    # Diretórios de instâncias disponíveis
    instance_dirs = [
        "G/n20w120s5",
        "G/n20w120s10", 
        "G/n20w140s5",
        "G/n20w140s10",
        "G/n20w160s5",
        "G/n20w160s10",
        "G/n20w180s5",
        "G/n20w180s10",
        "G/n20w200s5",
        "G/n20w200s10"
    ]
    
    # Configurações do algoritmo
    config = {
        'population_size': 50,
        'mutation_rate': 0.1,
        'crossover_rate': 0.85,
        'generations': 100
    }
    
    all_results = []
    total_start_time = time.time()
    
    print("="*80)
    print("TESTE DE MÚLTIPLAS INSTÂNCIAS - ALGORITMO GENÉTICO (PyGAD)")
    print("="*80)
    
    for instance_dir in instance_dirs:
        if not os.path.exists(instance_dir):
            print(f"Diretório {instance_dir} não encontrado, pulando...")
            continue
            
        print(f"Testando instâncias do diretório: {instance_dir}")
        print("-" * 60)
        
        instance_files = [f for f in os.listdir(instance_dir) if f.endswith('.txt')]
        instance_files.sort()
        
        dir_results = []
        
        for instance_file in instance_files:
            instance_path = os.path.join(instance_dir, instance_file)
            
            try:
                # Carrega a instância
                instance = ETSPInstance(instance_path)
                
                print(f"Processando: {instance_file}")
                print(f"   - Clientes: {instance.n}")
                print(f"   - Estações de recarga: {instance.m}")
                
                # Configura e executa o AG
                start_time = time.time()
                ga = TSPGeneticAlgorithm(
                    instance=instance,
                    **config
                )
                
                results = ga.run()
                end_time = time.time()
                
                # Salva informações da execução
                instance_result = {
                    'instance_file': instance_file,
                    'instance_path': instance_path,
                    'instance_dir': instance_dir,
                    'num_clients': instance.n,
                    'num_stations': instance.m,
                    'best_distance': results['best_distance'],
                    'best_route': results['best_route'],
                    'generations_completed': results['generations_completed'],
                    'execution_time': end_time - start_time,
                    'config': config.copy()
                }
                
                dir_results.append(instance_result)
                all_results.append(instance_result)
                
                print(f"   Distância: {results['best_distance']:.2f}")
                print(f"   Tempo: {end_time - start_time:.2f}s")
                print(f"   Gerações: {results['generations_completed']}")
                
            except Exception as e:
                print(f"   Erro ao processar {instance_file}: {str(e)}")
                continue
        
        # Estatísticas do diretório
        if dir_results:
            distances = [r['best_distance'] for r in dir_results]
            times = [r['execution_time'] for r in dir_results]
            
            print(f"Estatísticas do diretório {instance_dir}:")
            print(f"   - Instâncias processadas: {len(dir_results)}")
            print(f"   - Tempo médio: {np.mean(times):.2f}s ± {np.std(times):.2f}s")
    
    total_end_time = time.time()
    
    print("\n" + "="*80)
    print("RELATÓRIO FINAL")
    print("="*80)
    
    if all_results:
        print(f"Total de instâncias processadas: {len(all_results)}")
        print(f"Tempo total de execução: {total_end_time - total_start_time:.2f}s")
        
        all_distances = [r['best_distance'] for r in all_results]
        all_times = [r['execution_time'] for r in all_results]
        all_generations = [r['generations_completed'] for r in all_results]
        
        print(f"\nEstatísticas gerais:")
        print(f"   - Melhor distância global: {min(all_distances):.2f}")
        print(f"   - Pior distância global: {max(all_distances):.2f}")
        print(f"   - Distância média global: {np.mean(all_distances):.2f} ± {np.std(all_distances):.2f}")
        print(f"   - Tempo médio por instância: {np.mean(all_times):.2f}s ± {np.std(all_times):.2f}s")
        print(f"   - Gerações médias: {np.mean(all_generations):.1f} ± {np.std(all_generations):.1f}")
        
        # Salva resultados em arquivo CSV
        save_results_to_csv(all_results)
        
    else:
        print("Nenhuma instância foi processada com sucesso.")

def save_results_to_csv(results):
    """Salva os resultados em um arquivo CSV"""
    import csv
    from datetime import datetime
    
    filename = f"resultados_ag_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    
    try:
        with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = [
                'instance_file', 'instance_dir', 'num_clients', 'num_stations',
                'best_distance', 'generations_completed', 'execution_time',
                'population_size', 'mutation_rate', 'crossover_rate', 'max_generations'
            ]
            
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            
            for result in results:
                row = {
                    'instance_file': result['instance_file'],
                    'instance_dir': result['instance_dir'],
                    'num_clients': result['num_clients'],
                    'num_stations': result['num_stations'],
                    'best_distance': result['best_distance'],
                    'generations_completed': result['generations_completed'],
                    'execution_time': result['execution_time'],
                    'population_size': result['config']['population_size'],
                    'mutation_rate': result['config']['mutation_rate'],
                    'crossover_rate': result['config']['crossover_rate'],
                    'max_generations': result['config']['generations']
                }
                writer.writerow(row)
        
        print(f"Resultados salvos em: {filename}")
        
    except Exception as e:
        print(f"Erro ao salvar CSV: {str(e)}")

def run_single_instance(instance_path: str, verbose: bool = True):
    """Executa o algoritmo genético em uma única instância"""
    import os
    
    if not os.path.exists(instance_path):
        print(f"Arquivo não encontrado: {instance_path}")
        return
    
    try:
        # Carrega a instância
        instance = ETSPInstance(instance_path)
        
        print(f"Instância carregada: {instance_path}")
        print(f"- {instance.n} clientes")
        print(f"- {instance.m} estações de recarga (ignoradas)")
        print(f"- Total de nós válidos para TSP: {instance.n + 1} (depósito + clientes)")
        
        # Configura o AG
        ga = TSPGeneticAlgorithm(
            instance=instance,
            population_size=50,
            mutation_rate=0.1,
            crossover_rate=0.85,
            generations=100
        )
        
        ga.verbose = verbose
        
        results = ga.run()
        
        if verbose:
            ga.plot_results(results)
        
        ga.print_detailed_results(results)
        
        return results
        
    except Exception as e:
        print(f"Erro ao processar {instance_path}: {str(e)}")
        return None

def run_directory_instances(directory_path: str):
    """Executa o algoritmo genético em todas as instâncias de um diretório"""
    
    if not os.path.exists(directory_path):
        print(f"Diretório não encontrado: {directory_path}")
        return
    
    # Lista todos os arquivos .txt no diretório
    instance_files = [f for f in os.listdir(directory_path) if f.endswith('.txt')]
    
    if not instance_files:
        print(f"Nenhum arquivo .txt encontrado em: {directory_path}")
        return
    
    instance_files.sort()
    
    print(f"Testando {len(instance_files)} instâncias do diretório: {directory_path}")
    print("-" * 70)
    
    # Configurações do algoritmo
    config = {
        'population_size': 50,
        'mutation_rate': 0.1,
        'crossover_rate': 0.85,
        'generations': 100
    }
    
    results = []
    total_start_time = time.time()
    
    for instance_file in instance_files:
        instance_path = os.path.join(directory_path, instance_file)
        
        try:
            # Carrega a instância
            instance = ETSPInstance(instance_path)
            
            print(f"\nProcessando: {instance_file}")
            print(f"   - Clientes: {instance.n}")
            print(f"   - Estações de recarga: {instance.m}")
            
            start_time = time.time()
            ga = TSPGeneticAlgorithm(
                instance=instance,
                **config
            )
            
            ga.verbose = False
            result = ga.run()
            end_time = time.time()
            
            # Salva informações da execução
            instance_result = {
                'instance_file': instance_file,
                'instance_path': instance_path,
                'instance_dir': directory_path,
                'num_clients': instance.n,
                'num_stations': instance.m,
                'best_distance': result['best_distance'],
                'best_route': result['best_route'],
                'generations_completed': result['generations_completed'],
                'execution_time': end_time - start_time,
                'config': config.copy()
            }
            
            results.append(instance_result)
            
            print(f"   Distância: {result['best_distance']:.2f}")
            print(f"   Tempo: {end_time - start_time:.2f}s")
            print(f"   Gerações: {result['generations_completed']}")
            
        except Exception as e:
            print(f"   Erro ao processar {instance_file}: {str(e)}")
            continue
    
    total_end_time = time.time()
    
    if results:
        times = [r['execution_time'] for r in results]
        generations = [r['generations_completed'] for r in results]
        
        print(f"\n" + "="*70)
        print(f"ESTATÍSTICAS DO DIRETÓRIO: {directory_path}")
        print("="*70)
        print(f"Instâncias processadas: {len(results)}")
        print(f"Tempo total: {total_end_time - total_start_time:.2f}s")
        print(f"Tempo médio: {np.mean(times):.2f}s ± {np.std(times):.2f}s")
        print(f"Gerações médias: {np.mean(generations):.1f} ± {np.std(generations):.1f}")
        
        save_results_to_csv(results)
        
    return results

def print_help():
    """Imprime instruções de uso"""
    print("="*70)
    print("ALGORITMO GENÉTICO PARA TSP - INSTRUÇÕES DE USO")
    print("="*70)
    print("Uso:")
    print("  python tsp_ag.py                           # Executa todas as instâncias")
    print("  python tsp_ag.py <arquivo.txt>             # Executa uma instância específica")
    print("  python tsp_ag.py <diretório>               # Executa todas as instâncias de um diretório")
    print("  python tsp_ag.py --help                    # Mostra esta ajuda")
    print()
    print("Exemplos:")
    print("  python tsp_ag.py G/n20w120s5/n20w120s5.1.txt    # Instância específica")
    print("  python tsp_ag.py G/n20w120s5                    # Todas as instâncias do diretório")
    print("  python tsp_ag.py G/n20w140s10/n20w140s10.3.txt  # Outra instância específica")
    print()
    print("Diretórios disponíveis:")
    import os
    for dir_name in sorted(os.listdir('G') if os.path.exists('G') else []):
        if os.path.isdir(f'G/{dir_name}'):
            print(f"  - G/{dir_name}")

# Exemplo de uso
if __name__ == "__main__":
    import sys
    import os
    
    if len(sys.argv) == 1:
        print("Modo de execução: Múltiplas instâncias (todas)")
        print("Para ver outras opções, use: python tsp_ag.py --help")
        run_multiple_instances()
        
    elif len(sys.argv) == 2:
        arg = sys.argv[1]
        
        if arg in ["--help", "-h", "help"]:
            print_help()
            
        elif os.path.isfile(arg):
            print(f"Modo de execução: Instância única")
            run_single_instance(arg, verbose=True)
            
        elif os.path.isdir(arg):
            print(f"Modo de execução: Diretório específico")
            run_directory_instances(arg)
            
        else:
            print(f"Arquivo ou diretório não encontrado: {arg}")
            print("Use: python tsp_ag.py --help para ver as opções disponíveis")