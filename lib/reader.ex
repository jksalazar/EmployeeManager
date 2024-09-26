defmodule Reader do
  alias Empresa.Employee


  @spec read_all_employees(String.t()) :: [Employee.t()]
  def read_all_employees(filename \\ "employees.json") do
    case File.read(filename) do
      {:ok, contents} ->
        # Example of how Jason.decode! works:
        # If contents = '{"name": "John", "age": 30}'
        # Jason.decode!(contents, keys: :atoms) returns:
        # %{name: "John", age: 30}
        Jason.decode!(contents, keys: :atoms)
        |> Enum.map(&struct(Employee, &1))
      {:error, :enoent} -> []
    end
  end


  @spec read_employee_by_id(integer(), String.t()) :: {:ok, Employee.t()} | {:error, :not_found}
  def read_employee_by_id(id, filename \\ "employees.json") do
    employees = read_all_employees(filename)

    case Enum.find(employees, &(&1.id == id)) do
      nil -> {:error, :not_found}
      employee -> {:ok, employee}
    end
  end
end
