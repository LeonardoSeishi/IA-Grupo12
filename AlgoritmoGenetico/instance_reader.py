import numpy as np

class ETSPInstance:
    def __init__(self, file_path):
        self.file_path = file_path
        self.n = 0  # number of customers
        self.m = 0  # number of recharging stations
        self.Q = 0  # battery capacity
        self.h = 0.0  # consumption rate
        self.g = 0.0  # recharging rate
        self.nodes = []  # list of nodes: depot, customers, recharging stations
        self.distance_matrix = None
        
        self._read_instance()
    
    def _read_instance(self):
        with open(self.file_path, 'r') as file:
            lines = [line.strip() for line in file.readlines() if line.strip()]
            
        # Ler parametros
        self.n = int(lines[0])      # number of customers
        self.m = int(lines[1])      # number of recharging stations
        self.Q = float(lines[2])    # battery capacity
        self.h = float(lines[3])    # consumption rate
        self.g = float(lines[4])    # recharging rate
        
        # Calcular total de nos
        total_nodes = 1 + self.n + self.m
        
        # Ler informacoes dos nos
        nodes_start_i = 5
        nodes_end_i = nodes_start_i + total_nodes
        self.nodes = []
        
        for i in range(nodes_start_i, nodes_end_i):
            parts = lines[i].split()
            if len(parts) >= 5:
                node_id = int(parts[0]) # node ID
                x = float(parts[1])     # x coordinate
                y = float(parts[2])     # y coordinate
                e = float(parts[3])     # time window start
                l = float(parts[4])     # time window end
                self.nodes.append({
                    'id': node_id,
                    'x': x,
                    'y': y,
                    'e': e,
                    'l': l
                })
        
        # Ler distancias matrix
        matrix_lines = lines[nodes_end_i:]
        matrix_data = []
        
        for line in matrix_lines:
            row = [float(x) for x in line.split()]
            matrix_data.append(row)
        
        self.distance_matrix = np.array(matrix_data)
        
        # Validar tamanho matrix
        expected_size = total_nodes
        if self.distance_matrix.shape != (expected_size, expected_size):
            print(f"Warning: Expected matrix size {expected_size}x{expected_size}, "
                  f"got {self.distance_matrix.shape}")
    
    def get_node_info(self, node_id):
        """Get information for a specific node by ID"""
        for node in self.nodes:
            if node['id'] == node_id:
                return node
        return None
    
    def get_distance(self, from_id, to_id):
        """Get distance between two nodes by their IDs"""
        from_idx = self._get_matrix_index(from_id)
        to_idx = self._get_matrix_index(to_id)
        return self.distance_matrix[from_idx][to_idx]
    
    def _get_matrix_index(self, node_id):
        """Convert node ID to matrix index (0-based)"""
        for i, node in enumerate(self.nodes):
            if node['id'] == node_id:
                return i
        raise ValueError(f"Node ID {node_id} not found")
    
    def __str__(self):
        return (f"ETSP Instance: {self.n} customers, {self.m} recharging stations\n"
                f"Battery: {self.Q}, Consumption: {self.h}, Recharge: {self.g}\n"
                f"Total nodes: {len(self.nodes)}, Matrix shape: {self.distance_matrix.shape}")

if __name__ == "__main__":
    instance = ETSPInstance("G/n20w120s5/n20w120s5.1.txt")
    
    print(instance)
    print("\nFirst 5 nodes:")
    for i in range(min(5, len(instance.nodes))):
        print(f"  {instance.nodes[i]}")
    
    print(f"\nDistance matrix sample:")
    print(instance.distance_matrix[:4, :4])