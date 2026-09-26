defmodule Datos do
@moduledoc """
Modulo con Datos del Proyecto (Realizado con IA)
- Autores: Briyith Sanchez Alonso y Nicolás Arango Gutiérrez
- Fecha: Septiembre del 2026
- Licencia: GNU GPL V3
"""

  # Productores
  def productores do
    [
    %{codigo: "P001", nombre: "Finca El Roble", transporte: true},
    %{codigo: "P002", nombre: "Hacienda La Esperanza", transporte: true},
    %{codigo: "P003", nombre: "Finca San Miguel", transporte: false},
    %{codigo: "P004", nombre: "Hacienda El Porvenir", transporte: true},
    %{codigo: "P005", nombre: "Finca La Pradera", transporte: false},
    %{codigo: "P006", nombre: "Finca Los Andes", transporte: true},
    %{codigo: "P007", nombre: "Hacienda Santa Rosa", transporte: false},
    %{codigo: "P008", nombre: "Finca El Vergel", transporte: false},
    %{codigo: "P009", nombre: "Hacienda La Colina", transporte: true},
    %{codigo: "P010", nombre: "Finca La Arboleda", transporte: false}
    ]
  end

  # Tanques
  def tanques do
    [
    %{id: "T01", nombre: "Tanque Norte", capacidad: 5000},
    %{id: "T02", nombre: "Tanque Centro", capacidad: 6000},
    %{id: "T03", nombre: "Tanque Sur", capacidad: 7000},
    %{id: "T04", nombre: "Tanque Reserva", capacidad: 8000}
    ]
  end

  # Entregas
  #
  # Se incluyen:
  # - 90 entregas válidas
  # - Entregas para los 6 días
  # - Los 4 tanques
  # - Los 10 productores aparecen en los datos,
  #   aunque P010 se utiliza principalmente para probar
  #   situaciones de productores sin entregas válidas.

  def entregas do
    [
    # DÍA 1
    %{productor: "P001", tanque: "T01", dia: 1, litros: 520, grasa: 3.6},
    %{productor: "P002", tanque: "T02", dia: 1, litros: 480, grasa: 3.4},
    %{productor: "P003", tanque: "T03", dia: 1, litros: 390, grasa: 3.1},
    %{productor: "P004", tanque: "T04", dia: 1, litros: 460, grasa: 3.7},
    %{productor: "P005", tanque: "T01", dia: 1, litros: 310, grasa: 2.9},
    %{productor: "P006", tanque: "T02", dia: 1, litros: 550, grasa: 3.5},
    %{productor: "P007", tanque: "T03", dia: 1, litros: 275, grasa: 2.7},
    %{productor: "P008", tanque: "T04", dia: 1, litros: 430, grasa: 3.0},
    %{productor: "P009", tanque: "T01", dia: 1, litros: 510, grasa: 3.8},
    %{productor: "P001", tanque: "T02", dia: 1, litros: 180, grasa: 3.2},
    %{productor: "P002", tanque: "T03", dia: 1, litros: 220, grasa: 2.8},
    %{productor: "P003", tanque: "T04", dia: 1, litros: 340, grasa: 3.3},
    %{productor: "P004", tanque: "T01", dia: 1, litros: 290, grasa: 2.6},
    %{productor: "P005", tanque: "T02", dia: 1, litros: 365, grasa: 3.5},
    %{productor: "P006", tanque: "T03", dia: 1, litros: 410, grasa: 2.4},

    # DÍA 2
    %{productor: "P001", tanque: "T04", dia: 2, litros: 560, grasa: 3.7},
    %{productor: "P002", tanque: "T01", dia: 2, litros: 470, grasa: 3.3},
    %{productor: "P003", tanque: "T02", dia: 2, litros: 350, grasa: 3.0},
    %{productor: "P004", tanque: "T03", dia: 2, litros: 490, grasa: 3.6},
    %{productor: "P005", tanque: "T04", dia: 2, litros: 280, grasa: 2.8},
    %{productor: "P006", tanque: "T01", dia: 2, litros: 600, grasa: 3.9},
    %{productor: "P007", tanque: "T02", dia: 2, litros: 320, grasa: 2.6},
    %{productor: "P008", tanque: "T03", dia: 2, litros: 440, grasa: 3.1},
    %{productor: "P009", tanque: "T04", dia: 2, litros: 530, grasa: 3.5},
    %{productor: "P001", tanque: "T01", dia: 2, litros: 210, grasa: 3.4},
    %{productor: "P002", tanque: "T02", dia: 2, litros: 250, grasa: 2.7},
    %{productor: "P003", tanque: "T03", dia: 2, litros: 370, grasa: 3.2},
    %{productor: "P004", tanque: "T04", dia: 2, litros: 300, grasa: 2.9},
    %{productor: "P005", tanque: "T01", dia: 2, litros: 390, grasa: 3.6},
    %{productor: "P006", tanque: "T02", dia: 2, litros: 425, grasa: 2.5},

    # DÍA 3
    %{productor: "P001", tanque: "T03", dia: 3, litros: 500, grasa: 3.8},
    %{productor: "P002", tanque: "T04", dia: 3, litros: 460, grasa: 3.5},
    %{productor: "P003", tanque: "T01", dia: 3, litros: 380, grasa: 3.1},
    %{productor: "P004", tanque: "T02", dia: 3, litros: 520, grasa: 3.7},
    %{productor: "P005", tanque: "T03", dia: 3, litros: 290, grasa: 2.9},
    %{productor: "P006", tanque: "T04", dia: 3, litros: 570, grasa: 3.6},
    %{productor: "P007", tanque: "T01", dia: 3, litros: 340, grasa: 2.7},
    %{productor: "P008", tanque: "T02", dia: 3, litros: 450, grasa: 3.0},
    %{productor: "P009", tanque: "T03", dia: 3, litros: 540, grasa: 3.9},
    %{productor: "P001", tanque: "T04", dia: 3, litros: 170, grasa: 3.3},
    %{productor: "P002", tanque: "T01", dia: 3, litros: 240, grasa: 2.8},
    %{productor: "P003", tanque: "T02", dia: 3, litros: 360, grasa: 3.4},
    %{productor: "P004", tanque: "T03", dia: 3, litros: 280, grasa: 2.6},
    %{productor: "P005", tanque: "T04", dia: 3, litros: 400, grasa: 3.5},
    %{productor: "P006", tanque: "T01", dia: 3, litros: 415, grasa: 2.4},

    # DÍA 4
    %{productor: "P001", tanque: "T02", dia: 4, litros: 580, grasa: 3.6},
    %{productor: "P002", tanque: "T03", dia: 4, litros: 490, grasa: 3.4},
    %{productor: "P003", tanque: "T04", dia: 4, litros: 360, grasa: 3.0},
    %{productor: "P004", tanque: "T01", dia: 4, litros: 510, grasa: 3.8},
    %{productor: "P005", tanque: "T02", dia: 4, litros: 300, grasa: 2.7},
    %{productor: "P006", tanque: "T03", dia: 4, litros: 620, grasa: 3.7},
    %{productor: "P007", tanque: "T04", dia: 4, litros: 330, grasa: 2.5},
    %{productor: "P008", tanque: "T01", dia: 4, litros: 455, grasa: 3.2},
    %{productor: "P009", tanque: "T02", dia: 4, litros: 550, grasa: 3.9},
    %{productor: "P001", tanque: "T03", dia: 4, litros: 190, grasa: 3.1},
    %{productor: "P002", tanque: "T04", dia: 4, litros: 260, grasa: 2.9},
    %{productor: "P003", tanque: "T01", dia: 4, litros: 370, grasa: 3.5},
    %{productor: "P004", tanque: "T02", dia: 4, litros: 310, grasa: 2.6},
    %{productor: "P005", tanque: "T03", dia: 4, litros: 385, grasa: 3.3},
    %{productor: "P006", tanque: "T04", dia: 4, litros: 420, grasa: 2.4},

    # DÍA 5
    %{productor: "P001", tanque: "T01", dia: 5, litros: 540, grasa: 3.7},
    %{productor: "P002", tanque: "T02", dia: 5, litros: 500, grasa: 3.5},
    %{productor: "P003", tanque: "T03", dia: 5, litros: 370, grasa: 3.1},
    %{productor: "P004", tanque: "T04", dia: 5, litros: 480, grasa: 3.6},
    %{productor: "P005", tanque: "T01", dia: 5, litros: 315, grasa: 2.8},
    %{productor: "P006", tanque: "T02", dia: 5, litros: 590, grasa: 3.8},
    %{productor: "P007", tanque: "T03", dia: 5, litros: 280, grasa: 2.6},
    %{productor: "P008", tanque: "T04", dia: 5, litros: 460, grasa: 3.0},
    %{productor: "P009", tanque: "T01", dia: 5, litros: 525, grasa: 3.9},
    %{productor: "P001", tanque: "T02", dia: 5, litros: 200, grasa: 3.3},
    %{productor: "P002", tanque: "T03", dia: 5, litros: 235, grasa: 2.7},
    %{productor: "P003", tanque: "T04", dia: 5, litros: 345, grasa: 3.4},
    %{productor: "P004", tanque: "T01", dia: 5, litros: 295, grasa: 2.5},
    %{productor: "P005", tanque: "T02", dia: 5, litros: 375, grasa: 3.6},
    %{productor: "P006", tanque: "T03", dia: 5, litros: 430, grasa: 2.4},

    # DÍA 6
    %{productor: "P001", tanque: "T04", dia: 6, litros: 570, grasa: 3.8},
    %{productor: "P002", tanque: "T01", dia: 6, litros: 485, grasa: 3.4},
    %{productor: "P003", tanque: "T02", dia: 6, litros: 355, grasa: 3.1},
    %{productor: "P004", tanque: "T03", dia: 6, litros: 500, grasa: 3.7},
    %{productor: "P005", tanque: "T04", dia: 6, litros: 290, grasa: 2.9},
    %{productor: "P006", tanque: "T01", dia: 6, litros: 610, grasa: 3.6},
    %{productor: "P007", tanque: "T02", dia: 6, litros: 325, grasa: 2.7},
    %{productor: "P008", tanque: "T03", dia: 6, litros: 445, grasa: 3.0},
    %{productor: "P009", tanque: "T04", dia: 6, litros: 535, grasa: 3.9},
    %{productor: "P001", tanque: "T01", dia: 6, litros: 185, grasa: 3.2},
    %{productor: "P002", tanque: "T02", dia: 6, litros: 245, grasa: 2.8},
    %{productor: "P003", tanque: "T03", dia: 6, litros: 365, grasa: 3.5},
    %{productor: "P004", tanque: "T04", dia: 6, litros: 305, grasa: 2.6},
    %{productor: "P005", tanque: "T01", dia: 6, litros: 380, grasa: 3.3},
    %{productor: "P006", tanque: "T02", dia: 6, litros: 415, grasa: 2.4},

    # Entregas Invalidas con Finalidad Pruebas
    # 1. Productor desconocido
    %{productor: "P999", tanque: "T01", dia: 1, litros: 300, grasa: 3.2},
    %{productor: "P888", tanque: "T02", dia: 2, litros: 400, grasa: 3.5},

    # 2. Tanque desconocido
    %{productor: "P001", tanque: "T99", dia: 3, litros: 300, grasa: 3.2},
    %{productor: "P002", tanque: "T88", dia: 4, litros: 400, grasa: 3.5},

    # 3. Día inválido
    %{productor: "P003", tanque: "T01", dia: 0, litros: 300, grasa: 3.2},
    %{productor: "P004", tanque: "T02", dia: 7, litros: 400, grasa: 3.5},

    # 4. Litros fuera de rango
    %{productor: "P005", tanque: "T03", dia: 5, litros: 0, grasa: 3.2},
    %{productor: "P006", tanque: "T04", dia: 6, litros: 801, grasa: 3.5},

    # 5. Porcentaje de grasa inválido
    %{productor: "P007", tanque: "T01", dia: 2, litros: 300, grasa: -1},
    %{productor: "P008", tanque: "T02", dia: 3, litros: 400, grasa: 16}
    ]
  end
end
