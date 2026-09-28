defmodule Validacion do
       @moduledoc """
  Modulo para validar las entregas de leche recibidas.
- Autores: Nicolás Arango Gutiérrez y Briyith Sanchez Alonso
- Fecha: Septiembre del 2026
- Licencia: GNU GPL V3
  """
  @doc """
  Función principal que valida una entrega aplicando secuencialmente las reglas.

  ## Parámetros
  - entrega: mapa con los  datos de la entrega
  - productores: lista con todos los mapas de los productores
  - tanques:  lista de los mapas de los tanques disponibles

  ## Ejemplo
  iex> Validacion.validar_entrega(%{productor: "P001", tanque: "T1", dia: 1, litros: 200, grasa: 3.5})
   {:ok, %{productor: "P001", tanque: "T1", dia: 1, litros: 200, grasa: 3.5}}

   o puede usar:
     %{productor: "P081", tanque: "T1", dia: 1, litros: 200, grasa: 3.5}
    |>  Validacion.validar_entrega(productores, tanques)
    # {:error, :productor_desconocido}
  """
  def validar_entrega(entrega, productores, tanques) do
    case validar_productor(entrega, productores) do
      false ->
        {:error, :productor_desconocido}

      true ->
        case validar_tanque(entrega, tanques) do
          false ->
            {:error, :tanque_desconocido}

          true ->
            case validar_dia(entrega) do
              false ->
                {:error, :dia_invalido}

              true ->
                case validar_litros(entrega) do
                  false ->
                    {:error, :litros_fuera_rango}

                  true ->
                    case validar_grasa(entrega) do
                      false -> {:error, :porcentaje_invalido}
                      true -> {:ok, entrega}
                    end
                end
            end
        end
    end
  end

  @doc """
  Función para comprobar si el codigo de un productor existe

  ##Parámetro
  -codigo: codigo del productor
  -produtores: lista de mapas con la información de los productores

  ## Ejemplo
  iex> Validacion.validar_productor("P001", productores)
  true

  """
  def validar_productor(codigo, productores) do
    case Enum.any?(productores, fn productor -> productores.codigo == codigo end) do
        true -> true
        false -> false
    end
  end

 @doc """
  Función para comprobar si el ID de un tanque existe

  ##Parámetro
  -id: codigo del tanque
  -tanques: lista de mapas con la información de los tanques

  ## Ejemplo
  iex> Validacion.validar_tanque("T1", tanques)
  true

  """
  def validar_tanque(id, tanques) do
    case Enum.any?(tanques, fn tanque -> tanques.id == id end) do
      true -> true
      false-> false
    end
  end


 @doc """
  Función para verificar si el dia ingresado es un entero entre 1 y 6

  ##Parámetro
  -dia: número entero correspondiente al dia

  ## Ejemplo
  iex> Validacion.validar_dia(3)
  true

  """
  def validar_dia(dia) do
    cond do
        not is_integer(dia) -> false
        dia < 1 -> false
        dia > 6  -> false
        true  -> true
    end
  end


 @doc """
  Función para verificar si los litros entregados están en el rango de 0 a 800

  ##Parámetro
  -litros: cantidad de litros ingresados en la entrega

  ## Ejemplo
  iex> Validacion.validar_litros(250)
  true

  """
  def validar_litros(litros) do
    cond do
      not is_number(litros) -> false
      litros <= 0 -> false
      litros > 800 -> false
      true-> true
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
      not is_number(grasa) -> false
      litros < 0 -> false
      litros > 15 -> false
      true-> true
    end
  end
end
