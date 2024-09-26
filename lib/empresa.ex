defmodule Empresa do
  defmodule Employee do

    @derive {Jason.Encoder, only: [:id, :name, :position, :email, :phone, :hire_date, :salary]}
    defstruct [:id, :name, :position, :email, :phone, :hire_date, :salary]


    @type t :: %__MODULE__{
      id: integer() | nil,
      name: String.t(),
      position: String.t(),
      email: String.t() | nil,
      phone: String.t() | nil,
      hire_date: Date.t() | nil,
      salary: float() | nil
    }


    def new(name, position, opts \\ []) do
      struct!(__MODULE__, [name: name, position: position] ++ opts)
    end
  end
end
