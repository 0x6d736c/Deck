defmodule Cards do
  @moduledoc """
    Methods for creating, shuffling, dealing, and saving/loading a deck of cards to the filesystem
  """

  @doc """
    Return a list of strings representing a deck of cards
  """
  @spec create_deck :: list
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "King", "Queen", "Jack"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
        "#{value} of #{suit}"
    end
  end

  @doc """
    Return a tuple of lists with the first list representing the dealt cards (specified by `size`) and the second
    representing the remaining cards
  """
  @spec deal(any, integer) :: {list, list}
  def deal(deck, size) do
    Enum.split(deck, size)
  end

  @doc """
    Save the `deck` to the filesystem using a specified `filepath`
  """
  @spec save_deck(
          any,
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: :ok | {:error, atom}
  def save_deck(deck, filepath) do
    binary = :erlang.term_to_binary(deck)
    File.write(filepath, binary)
  end

  @doc """
    Load and return the `deck` from a specified `filepath`
  """
  @spec load_deck(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: any
  def load_deck(filepath) do
    case File.read(filepath) do
      {:ok, data} -> :erlang.binary_to_term(data)
      _ -> :error
    end
  end

  @doc """
    Shuffle the `deck` of cards and return a new shuffled `deck`
  """
  @spec shuffle(any) :: list
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Quick-start function to create a `deck`, shuffle it, and deal a hand based on `hand_size`
  """
  @spec initialize(integer) :: {list, list}
  def initialize(hand_size) do create_deck() |> shuffle() |> deal(hand_size) end

  @doc """
    Check if a `card` string is in the deck

  ## Examples

        iex> deck = Cards.create_deck
        iex> Cards.contains?(deck, "Seven of Diamonds")
        true
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
end
