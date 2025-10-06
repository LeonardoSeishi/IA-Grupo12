from typing import List, Dict, Tuple
from instance_reader import ETSPInstance
import math
import random
import numpy as np
import matplotlib.pyplot as plt


class TSPGeneticAlgorithm:
    def __init__(self, instance: ETSPInstance, population_size: int = 100, mutation_rate: float = 0.01, 
                 crossover_rate: float = 0.8, max_generations: int = 1000, elitism_count: int = 5):
        """
        Inicializa o algoritmo genético para TSP
        
        Args:
            instance: Instância do TSP carregada do arquivo
            population_size: Tamanho da população
            mutation_rate: Taxa de mutação
            crossover_rate: Taxa de cruzamento
            max_generations: Número máximo de gerações
            elitism_count: Número de indivíduos mantidos por elitismo
        """
        self.instance = instance
        
        # Parâmetros do AG
        self.population_size = population_size
        self.mutation_rate = mutation_rate
        self.crossover_rate = crossover_rate
        self.max_generations = max_generations
        self.elitism_count = elitism_count
        
        # Conjuntos de vértices (apenas clientes + depósito)
        self.cities = self._define_cities()
        self.distance_matrix = self._create_distance_matrix()
        
        # Estatísticas de execução
        self.best_fitness_history = []
        self.avg_fitness_history = []
        self.best_individual = None
        self.best_distance = float('inf')
        
    def _define_cities(self) -> List[int]:
        """Define as cidades (depósito + clientes) para o TSP clássico"""
        # Incluir apenas depósito e clientes (sem estações de recarga)
        cities = [0]  # Depósito sempre é o nó 0
        cities.extend([node['id'] for node in self.instance.nodes 
                      if 1 <= node['id'] <= self.instance.n])  # Apenas clientes
        return cities
    
    def _create_distance_matrix(self) -> np.ndarray:
        """Cria matriz de distâncias entre todas as cidades"""
        n_cities = len(self.cities)
        matrix = np.zeros((n_cities, n_cities))
        
        for i, city_i in enumerate(self.cities):
            for j, city_j in enumerate(self.cities):
                if i != j:
                    matrix[i][j] = self.instance.get_distance(city_i, city_j)
        
        return matrix
    
    def calculate_route_distance(self, route: List[int]) -> float:
        """Calcula a distância total de uma rota"""
        total_distance = 0.0
        
        for i in range(len(route) - 1):
            city_idx_from = self.cities.index(route[i])
            city_idx_to = self.cities.index(route[i + 1])
            total_distance += self.distance_matrix[city_idx_from][city_idx_to]
        
        return total_distance
    
    def fitness(self, individual: List[int]) -> float:
        """Função de fitness (inverso da distância total)"""
        distance = self.calculate_route_distance(individual)
        return 1.0 / distance if distance > 0 else 0.0
    
    def create_individual(self) -> List[int]:
        """Cria um indivíduo (rota) aleatório"""
        # Começar e terminar no depósito (0), embaralhar as outras cidades
        cities_to_visit = self.cities[1:]  # Excluir depósito
        random.shuffle(cities_to_visit)
        return [0] + cities_to_visit + [0]
    
    def create_population(self) -> List[List[int]]:
        """Cria a população inicial"""
        return [self.create_individual() for _ in range(self.population_size)]
    
    def tournament_selection(self, population: List[List[int]], tournament_size: int = 5) -> List[int]:
        """Seleção por torneio"""
        tournament = random.sample(population, tournament_size)
        return max(tournament, key=self.fitness)
    
    def order_crossover(self, parent1: List[int], parent2: List[int]) -> Tuple[List[int], List[int]]:
        """Cruzamento por ordem (OX)"""
        size = len(parent1) - 2  # Excluir depósitos inicial e final
        
        if size <= 2:
            return parent1.copy(), parent2.copy()
        
        # Selecionar dois pontos de corte aleatórios
        start, end = sorted(random.sample(range(1, size + 1), 2))
        
        # Criar filhos
        child1 = [0] + [None] * size + [0]
        child2 = [0] + [None] * size + [0]
        
        # Copiar segmento do pai 1 para filho 1 e pai 2 para filho 2
        child1[start:end] = parent1[start:end]
        child2[start:end] = parent2[start:end]
        
        # Completar os filhos
        self._complete_child(child1, parent2, start, end)
        self._complete_child(child2, parent1, start, end)
        
        return child1, child2
    
    def _complete_child(self, child: List[int], parent: List[int], start: int, end: int):
        """Completa o filho no cruzamento OX"""
        child_set = set(child[start:end])
        parent_genes = [gene for gene in parent[1:-1] if gene not in child_set]
        
        # Preencher posições vazias
        gene_idx = 0
        for i in range(1, len(child) - 1):
            if child[i] is None:
                child[i] = parent_genes[gene_idx]
                gene_idx += 1
    
    def mutate(self, individual: List[int]) -> List[int]:
        """Mutação por troca de duas cidades"""
        mutated = individual.copy()
        
        if random.random() < self.mutation_rate and len(mutated) > 4:
            # Escolher duas posições aleatórias (excluindo depósitos)
            i, j = random.sample(range(1, len(mutated) - 1), 2)
            mutated[i], mutated[j] = mutated[j], mutated[i]
        
        return mutated
    def evolve(self) -> Dict:
        """Executa o algoritmo genético"""
        population = self.create_population()
        
        for generation in range(self.max_generations):
            # Avaliar população
            fitness_scores = [(individual, self.fitness(individual)) for individual in population]
            fitness_scores.sort(key=lambda x: x[1], reverse=True)
            
            # Atualizar melhor indivíduo
            best_individual_gen = fitness_scores[0][0]
            best_distance_gen = self.calculate_route_distance(best_individual_gen)
            
            if best_distance_gen < self.best_distance:
                self.best_distance = best_distance_gen
                self.best_individual = best_individual_gen.copy()
            
            # Registrar estatísticas
            self.best_fitness_history.append(fitness_scores[0][1])
            avg_fitness = sum(score[1] for score in fitness_scores) / len(fitness_scores)
            self.avg_fitness_history.append(avg_fitness)
            
            # Critério de parada
            if generation % 100 == 0:
                print(f"Geração {generation}: Melhor distância = {self.best_distance:.2f}")
            
            # Criar nova população
            new_population = []
            
            # Elitismo
            for i in range(self.elitism_count):
                new_population.append(fitness_scores[i][0])
            
            # Gerar novos indivíduos
            while len(new_population) < self.population_size:
                parent1 = self.tournament_selection(population)
                parent2 = self.tournament_selection(population)
                
                if random.random() < self.crossover_rate:
                    child1, child2 = self.order_crossover(parent1, parent2)
                else:
                    child1, child2 = parent1.copy(), parent2.copy()
                
                child1 = self.mutate(child1)
                child2 = self.mutate(child2)
                
                new_population.extend([child1, child2])
            
            population = new_population[:self.population_size]
        
        return {
            'best_individual': self.best_individual,
            'best_distance': self.best_distance,
            'best_fitness_history': self.best_fitness_history,
            'avg_fitness_history': self.avg_fitness_history
        }
    
    def plot_convergence(self):
        """Plota gráfico de convergência do algoritmo"""
        plt.figure(figsize=(12, 5))
        
        plt.subplot(1, 2, 1)
        plt.plot(self.best_fitness_history, label='Melhor Fitness')
        plt.plot(self.avg_fitness_history, label='Fitness Médio')
        plt.xlabel('Geração')
        plt.ylabel('Fitness')
        plt.title('Convergência do Fitness')
        plt.legend()
        plt.grid(True)
        
        plt.subplot(1, 2, 2)
        best_distances = [1.0/f if f > 0 else float('inf') for f in self.best_fitness_history]
        plt.plot(best_distances)
        plt.xlabel('Geração')
        plt.ylabel('Distância')
        plt.title('Convergência da Melhor Distância')
        plt.grid(True)
        
        plt.tight_layout()
        plt.show()
    
    def __str__(self):
        return (f"TSP Genetic Algorithm\n"
                f"Cidades: {len(self.cities)}\n"
                f"População: {self.population_size}\n"
                f"Taxa de Mutação: {self.mutation_rate}\n"
                f"Taxa de Cruzamento: {self.crossover_rate}")















# Exemplo de uso do Algoritmo Genético para TSP
if __name__ == "__main__":
    # Carrega a instância
    instance = ETSPInstance("G/n20w120s5/n20w120s5.1.txt")
    
    # Cria o algoritmo genético para TSP
    tsp_ga = TSPGeneticAlgorithm(
        instance=instance,
        population_size=100,
        mutation_rate=0.02,
        crossover_rate=0.8,
        max_generations=500,
        elitism_count=5
    )
    
    print(tsp_ga)
    print(f"Cidades: {tsp_ga.cities}")
    print()
    
    # Executa o algoritmo genético
    print("Executando Algoritmo Genético...")
    results = tsp_ga.evolve()
    
    print(f"\nResultados finais:")
    print(f"Melhor rota: {results['best_individual']}")
    print(f"Melhor distância: {results['best_distance']:.2f}")
    
    # Plota convergência
    tsp_ga.plot_convergence()
    
    # Teste com uma rota manual
    test_route = [0] + list(range(1, len(tsp_ga.cities))) + [0]
    distance = tsp_ga.calculate_route_distance(test_route)
    print(f"\nTeste rota sequencial: {test_route}")
    print(f"Distância: {distance:.2f}")
