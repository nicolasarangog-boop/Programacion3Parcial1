defmodule Validacion do
  @moduledoc """
  Modulo para validar las entregas de leche recibidas.
  - Autores: Nicolás Arango Gutiérrez y Briyith Sanchez Alonso
  - Fecha: Septiembre del 2026
  - Licencia: GNU GPL V3
  """

  @doc """
  Función principal que valida una entrega encadenando las verificaciones con with.

  ## Parámetros
  - entrega: mapa con los datos de la entrega
  - productores: lista con todos los mapas de los productores
  - tanques: lista de los mapas de los tanques disponibles

  ## Ejemplo
      iex> Validacion.validar_entrega(%{productor: "P001", tanque: "T1", dia: 1, litros: 200, grasa: 3.5}, productores, tanques)
      {:ok, %{productor: "P001", tanque: "T1", dia: 1, litros: 200, grasa: 3.5}}

      iex> %{productor: "P081", tanque: "T1", dia: 1, litros: 200, grasa: 3.5}
      ...> |> Validacion.validar_entrega(productores, tanques)
      {:error, :productor_desconocido}
  """
  def validar_entrega(entrega, productores, tanques) do
    with :ok <- validar_productor(entrega.productor, productores),
         :ok <- validar_tanque(entrega.tanque, tanques),
         :ok <- validar_dia(entrega.dia),
         :ok <- validar_litros(entrega.litros),
         :ok <- validar_grasa(entrega.grasa) do
      {:ok, entrega}
    end
  end

  @doc """
  Función para validar las entregas

  ## Parámetros
  - entregas: lista de mapas con las entregas
  - productores: lista de mapas con los productores
  - tanques: lista de mapas con los tanques

  ## Ejemplo
    iex> entregas = [
    ...>   %{productor: "P001", tanque: "T1", dia: 1, litros: 200, grasa: 3.5},
    ...>   %{productor: "P999", tanque: "T1", dia: 1, litros: 200, grasa: 3.5}
    ...> ]
    iex> Validacion.validar_entregas(entregas, productores, tanques)
    [
      {:ok, %{productor: "P001", tanque: "T1", dia: 1, litros: 200, grasa: 3.5}},
      {:error, :productor_desconocido}
    ]
  """
  def validar_entregas(entregas, productores, tanques) do
    Enum.map(entregas, fn entrega ->
      case validar_entrega(entrega, productores, tanques) do
        {:ok, entrega_valida} -> {:ok, entrega_valida}
        {:error, motivo} -> {:error, motivo}
      end
    end)
  end

  @doc """
  Función para comprobar si el codigo de un productor existe

  ## Parámetro
  - codigo: codigo del productor
  - productores: lista de mapas con la información de los productores

  ## Ejemplo
  iex> Validacion.validar_productor("P001", productores)
  true
  """
  def validar_productor(codigo, productores) do
    case Enum.any?(productores, fn productor -> productor.codigo == codigo end) do
      true -> :ok
      false -> {:error, :productor_desconocido}
    end
  end

  @doc """
  Función para comprobar si el ID de un tanque existe

  ## Parámetro
  - id: codigo del tanque
  - tanques: lista de mapas con la información de los tanques

  ## Ejemplo
  iex> Validacion.validar_tanque("T1", tanques)
  true
  """
  def validar_tanque(id, tanques) do
    case Enum.any?(tanques, fn tanque -> tanque.id == id end) do
      true -> :ok
      false -> {:error, :tanque_desconocido}
    end
  end

  @doc """
  Función para verificar si el dia ingresado es un entero entre 1 y 6

  ## Parámetro
  - dia: número entero correspondiente al dia

  ## Ejemplo
  iex> Validacion.validar_dia(3)
  true
  """
  def validar_dia(dia) do
    cond do
      is_integer(dia) and dia >= 1 and dia <= 6 -> :ok
      true -> {:error, :dia_invalido}
    end
  end

  @doc """
  Función para verificar si los litros entregados están en el rango de 0 a 800

  ## Parámetro
  - litros: cantidad de litros ingresados en la entrega

  ## Ejemplo
  iex> Validacion.validar_litros(250)
  true
  """
  def validar_litros(litros) do
    cond do
      is_number(litros) and litros > 0 and litros <= 800 -> :ok
      true -> {:error, :litros_fuera_rango}
    end
  end

  @doc """
  Función para verificar si el porcentaje de grasa está en el rango de 0-15

  ##Parámetro
  -grasa: porcentaje de grasa

  ## Ejemplo
  iex> Validacion.validar_grasa(3.8)
  true
  """
  def validar_grasa(grasa) do
    cond do
      is_number(grasa) and grasa >= 0 and grasa <= 15 -> :ok
      true -> {:error, :porcentaje_invalido}
    end
  end
end
