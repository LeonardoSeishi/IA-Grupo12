import numpy as np
import matplotlib.pyplot as plt
import random
from typing import List, Dict
from instance_reader import ETSPInstance

class TSPGeneticAlgorithm:
    def __init__(self, instance: ETSPInstance, population_size=50, mutation_rate=0.1, crossover_rate=0.8, generations=100):
        """
        Algoritmo Genético para Problema do Caixeiro Viajante
        
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
        
        # Definir nós válidos (apenas depósito e clientes)
        self.valid_nodes = [0] + list(range(1, instance.n + 1))
        self.num_nodes = len(self.valid_nodes)
        
        # Matriz de distâncias apenas para nós válidos
        self.distance_matrix = self._build_reduced_distance_matrix()
        
        # Histórico para plots
        self.best_fitness_history = []
        self.avg_fitness_history = []
        
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
    
    def create_individual(self) -> List[int]:
        """Cria um indivíduo (rota) aleatório"""
        # Pega apenas clientes (exclui depósito que será fixo no início e fim)
        customers = self.valid_nodes[1:]  # Remove o depósito (0)
        random.shuffle(customers)
        return [0] + customers + [0]  # Depósito no início e fim
    
    def create_population(self) -> List[List[int]]:
        """Cria população inicial"""
        return [self.create_individual() for _ in range(self.population_size)]
    
    def calculate_distance(self, route: List[int]) -> float:
        """Calcula distância total de uma rota"""
        total_distance = 0
        for i in range(len(route) - 1):
            from_idx = self._get_node_index(route[i])
            to_idx = self._get_node_index(route[i + 1])
            total_distance += self.distance_matrix[from_idx][to_idx]
        return total_distance
    
    def fitness_function(self, route: List[int]) -> float:
        """Função de fitness (maior é melhor)"""
        total_distance = self.calculate_distance(route)
        # Usamos o inverso da distância pois queremos minimizar
        return 1.0 / total_distance if total_distance > 0 else 0
    
    def tournament_selection(self, population: List[List[int]], fitness: List[float], k=3) -> List[int]:
        """Seleção por torneio"""
        selected = random.sample(list(zip(population, fitness)), k)
        selected.sort(key=lambda x: x[1], reverse=True)
        return selected[0][0]
    
    def ordered_crossover(self, parent1: List[int], parent2: List[int]) -> List[int]:
        """Crossover Orderd (OX) para TSP"""
        if random.random() > self.crossover_rate:
            return parent1.copy()
            
        # Remove depósitos duplicados no final
        p1 = parent1[1:-1]  # Apenas a parte dos clientes
        p2 = parent2[1:-1]
        
        size = len(p1)
        start, end = sorted(random.sample(range(size), 2))
        
        # Cria filho com segmento do parent1
        child = [-1] * size
        child[start:end+1] = p1[start:end+1]
        
        # Preenche com elementos do parent2 na ordem
        pointer = (end + 1) % size
        for gene in p2:
            if gene not in child:
                while child[pointer] != -1:
                    pointer = (pointer + 1) % size
                child[pointer] = gene
        
        # Adiciona depósito no início e fim
        return [0] + child + [0]
    
    def swap_mutation(self, individual: List[int]) -> List[int]:
        """Mutação por troca de duas cidades"""
        if random.random() > self.mutation_rate:
            return individual.copy()
            
        # Trabalha apenas com a parte dos clientes
        customers = individual[1:-1]
        if len(customers) < 2:
            return individual.copy()
            
        idx1, idx2 = random.sample(range(len(customers)), 2)
        customers[idx1], customers[idx2] = customers[idx2], customers[idx1]
        
        return [0] + customers + [0]
    
    def run(self) -> Dict:
        """Executa o algoritmo genético"""
        # Inicialização
        population = self.create_population()
        best_individual = None
        best_fitness = -float('inf')
        
        print("Executando Algoritmo Genético...")
        
        for generation in range(self.generations):
            # Calcula fitness
            fitness = [self.fitness_function(ind) for ind in population]
            
            # Estatísticas
            current_best_fitness = max(fitness)
            current_avg_fitness = sum(fitness) / len(fitness)
            
            self.best_fitness_history.append(current_best_fitness)
            self.avg_fitness_history.append(current_avg_fitness)
            
            # Atualiza melhor indivíduo
            if current_best_fitness > best_fitness:
                best_fitness = current_best_fitness
                best_individual = population[fitness.index(current_best_fitness)]
            
            # Critério de parada opcional (estagnação)
            if generation > 20 and len(set(self.best_fitness_history[-10:])) == 1:
                print(f"Parada antecipada na geração {generation} - Estagnação")
                break
            
            # Nova população
            new_population = []
            
            # Elitismo: mantém o melhor
            new_population.append(best_individual)
            
            # Preenche o restante da população
            while len(new_population) < self.population_size:
                # Seleção
                parent1 = self.tournament_selection(population, fitness)
                parent2 = self.tournament_selection(population, fitness)
                
                # Crossover
                child = self.ordered_crossover(parent1, parent2)
                
                # Mutação
                child = self.swap_mutation(child)
                
                new_population.append(child)
            
            population = new_population
            
            if generation % 10 == 0:
                print(f"Geração {generation}: Melhor Fitness = {current_best_fitness:.6f}, "
                      f"Distância = {1.0/current_best_fitness:.2f}")
        
        # Resultados finais
        best_distance = 1.0 / best_fitness
        
        results = {
            'best_route': best_individual,
            'best_fitness': best_fitness,
            'best_distance': best_distance,
            'best_fitness_history': self.best_fitness_history,
            'avg_fitness_history': self.avg_fitness_history,
            'generations_completed': len(self.best_fitness_history)
        }
        
        return results
    
    def plot_results(self, results: Dict):
        """Plota resultados da execução"""
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5))
        
        # Plot de convergência
        ax1.plot(results['best_fitness_history'], label='Melhor Fitness', linewidth=2)
        ax1.plot(results['avg_fitness_history'], label='Fitness Médio', alpha=0.7)
        ax1.set_xlabel('Geração')
        ax1.set_ylabel('Fitness')
        ax1.set_title('Convergência do Algoritmo Genético')
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
        print("\n" + "="*50)
        print("RESULTADOS FINAIS - ALGORITMO GENÉTICO")
        print("="*50)
        print(f"Melhor rota encontrada: {results['best_route']}")
        print(f"Distância total: {results['best_distance']:.2f}")
        print(f"Fitness da melhor solução: {results['best_fitness']:.6f}")
        print(f"Gerações completadas: {results['generations_completed']}")
        print(f"Número de clientes: {self.instance.n}")
        print(f"Tamanho da população: {self.population_size}")
        print(f"Taxa de mutação: {self.mutation_rate}")
        print(f"Taxa de crossover: {self.crossover_rate}")

# Exemplo de uso
if __name__ == "__main__":
    # Carrega a instância
    instance = ETSPInstance("ETSPTW-Instances/tiny_one_santiago.txt")
    
    print("Instância carregada:")
    print(f"- {instance.n} clientes")
    print(f"- {instance.m} estações de recarga (ignoradas)")
    print(f"- Total de nós válidos para TSP: {instance.n + 1} (depósito + clientes)")
    
    # Configura e executa o AG
    ga = TSPGeneticAlgorithm(
        instance=instance,
        population_size=50,
        mutation_rate=0.1,
        crossover_rate=0.85,
        generations=100
    )
    
    # Executa o algoritmo
    results = ga.run()
    
    # Plota resultados
    ga.plot_results(results)
    
    # Imprime resultados detalhados
    ga.print_detailed_results(results)