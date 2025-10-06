from typing import List, Dict, Tuple
from instance_reader import ETSPInstance
import math


class ElectricTSP:
    def __init__(self, instance: ETSPInstance, alpha: int = 100, beta: int = 5):
        """
        Inicializa o problema ETSP a partir de uma instância carregada
        
        Args:
            instance: Instância do ETSP carregada do arquivo
        """
        self.instance = instance
        
        # Conjuntos de vértices
        self.V = self._define_vertex_sets()
        
        # Funções de distancia e consumo
        self.w = self._get_distance_function()
        self.e = self._get_consumption_function()
        
        # Parâmetros do veículo
        self.B = instance.Q     # capacidade máxima da bateria
        self.b0 = instance.Q    # energia inicial no depósito

        self.alpha = alpha # Peso para violação de energia
        self.beta = beta   # Peso para paradas de recarga
        
    def _define_vertex_sets(self) -> Dict[str, List[int]]:
        """Define os conjuntos de vértices conforme a definição matemática"""
        # Todos os nós (IDs)
        all_nodes = [node['id'] for node in self.instance.nodes]
        
        # Depósito (vértice o)
        depot = all_nodes[0]
        
        # Clientes (C = {c1, ..., cn})
        customers = [node for node in all_nodes if 1 <= node <= self.instance.n]
        
        # Estações de recarga (R = {r1, ..., rm})
        stations = [node for node in all_nodes if node > self.instance.n]
        
        return {
            'all': all_nodes,
            'depot': depot,
            'customers': customers,
            'stations': stations,
            'C': customers,
            'R': stations,
            'o': depot
        }
    
    def _get_distance_function(self):
        """Retorna função de distancia w(u, v) para arco (u, v)"""
        def w(u: int, v: int) -> float:
            return self.instance.get_distance(u, v)
        return w
    
    def _get_consumption_function(self):
        """Retorna função de consumo e(u, v) para arco (u, v)"""
        # Assumindo que o consumo é proporcional à distância
        def e(u: int, v: int) -> float:
            distance = self.instance.get_distance(u, v)
            return distance * self.instance.h  # consumo = distância × taxa
        return e
    
    def get_travel_distance(self, u: int, v: int) -> float:
        """Retorna o custo de viagem para percorrer (u, v)"""
        return self.w(u, v)
    
    def get_energy_consumption(self, u: int, v: int) -> float:
        """Retorna o consumo de energia para percorrer (u, v)"""
        return self.e(u, v)
    
    def is_customer(self, node_id: int) -> bool:
        """Verifica se um nó é cliente"""
        return node_id in self.V['customers']
    
    def costumers_number(self) -> int:
        """Retorna quantidade de clientes"""
        return len(self.V['customers'])
    
    def is_station(self, node_id: int) -> bool:
        """Verifica se um nó é estação de recarga"""
        return node_id in self.V['stations']
    
    def is_depot(self, node_id: int) -> bool:
        """Verifica se um nó é depósito"""
        return node_id == self.V['depot']
    
    def get_costumer_route(self, route: List[int]) -> List[int]:
        """Retorna uma rota apenas com os depósitos e os clientes"""
        costumer_route = []
        for node in route:
            if not self.is_station(node):
                costumer_route.append(node)
        return costumer_route
    
    def get_route_statistics(self, route: List[int]) -> Dict:
        """Retorna estatísticas detalhadas de uma rota"""
        stats = {
            'total_distance': 0,
            'fitness': 0,
        }
        
        current_energy = self.b0
        stats['energy_levels'].append(current_energy)
        
        for i in range(len(route) - 1):
            u, v = route[i], route[i + 1]
            
            # Atualiza distância total
            distance = self.get_travel_distance(u, v)
            stats['total_distance'] += distance

        stats['grade'] = stats['total_distance'] ####

        return stats
    

    def __str__(self):
        return (f"Electric TSP Problem\n"
                f"Customers: {len(self.V['C'])}"
                f"Battery: {self.B}, Initial Energy: {self.b0}\n"
                f"Consumption Rate: {self.instance.h}")















# Exemplo de uso integrado
if __name__ == "__main__":
    # Carrega a instância
    instance = ETSPInstance("ETSPTW-Instances/tiny_one_santiago.txt")
    
    # Cria o problema ETSP
    etsp = ElectricTSP(instance)
    
    print(etsp)
    print()
    print(f"\nConjuntos de vértices:")
    print(f"Depósito: {etsp.V['depot']}")
    print(f"Clientes: {etsp.V['customers']}")
    print(f"Estações: {etsp.V['stations']}")
    print()
    
    # Exemplo de rota simples para teste
    test_route = [0, 2, 6, 1, 7, 5, 7, 4, 7, 3, 7 ,0]
    feasible, distance, energy = etsp.validate_route(test_route)

    print(f"\nTeste de rota: {test_route}")
    print(f"Viável: {feasible}, Distância: {distance:.2f}, Energia: {energy:.2f}")

    if not feasible:
        print("Rota inviável - necessidade de estações de recarga!")
    print()
    # Estatisticas da rota
    stats = etsp.get_route_statistics(test_route)
    for key, value in stats.items():
        print(f"{key}: {value}")
