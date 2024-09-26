defmodule Writer do
  alias Empresa.Employee

  @spec write_employee(Employee.t(), String.t()) :: :ok | {:error, term()}
  def write_employee(%Employee{} = employee, filename \\ "employees.json") do
    employees = read_employees(filename)
    new_id = get_next_id(employees)
    updated_employee = Map.put(employee, :id, new_id)
    updated_employees = [updated_employee | employees]

    json_data = Jason.encode!(updated_employees, pretty: true)
    File.write(filename, json_data)
  end

  @spec read_employees(String.t()) :: [Employee.t()]
  defp read_employees(filename) do
    case File.read(filename) do
      {:ok, contents} ->
        Jason.decode!(contents, keys: :atoms)
        |> Enum.map(&struct(Employee, &1))
      {:error, :enoent} -> []
    end
  end


  @spec get_next_id([Employee.t()]) :: integer()
  defp get_next_id(employees) do
    employees
    |> Enum.map(& &1.id)
    |> Enum.max(fn -> 0 end)
    |> Kernel.+(1)
  end

  @spec update_employee(integer(), map(), String.t()) :: :ok | {:error, :not_found}
  def update_employee(id, updates, filename \\ "employees.json") do
    employees = read_employees(filename)

    case Enum.find(employees, &(&1.id == id)) do
      nil ->
        {:error, :not_found}
      employee ->
        updated_employee = Map.merge(employee, updates)
        updated_employees = Enum.map(employees, fn emp ->
          if emp.id == id, do: updated_employee, else: emp
        end)

        json_data = Jason.encode!(updated_employees, pretty: true)
        File.write(filename, json_data)
        :ok
    end
  end

  @spec delete_employee(integer(), String.t()) :: :ok | {:error, :not_found}
  def delete_employee(id, filename \\ "employees.json") do
    employees = read_employees(filename)

    case Enum.find(employees, &(&1.id == id)) do
      nil ->
        {:error, :not_found}
      _employee ->
        updated_employees = Enum.filter(employees, &(&1.id != id))
        json_data = Jason.encode!(updated_employees, pretty: true)
        File.write(filename, json_data)
        :ok
    end
  end
end
