defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  test "start_link/1 - default state" do
    {:ok,pid} = Stack.start_link([])
    assert Stack.get_stack(pid) == []
  end

  test "start_link/1 - init state" do
    {:ok,pid} = Stack.start_link([state: ["3","2","1"]])
    assert Stack.get_stack(pid) == ["3","2","1"]
  end

  test "start_link/1 - default configuration" do
    {:ok,pid} = Stack.start_link([])
    assert Stack.get_stack(pid) == []
  end

  test "pop/1 - remove one element from stack" do
    {:ok,pid} = Stack.start_link([state: ["3","2","1"]])
    assert Stack.pop(pid) == "3"
    assert Stack.get_stack(pid) == ["2","1"]
  end

  test "pop/1 - remove multiple elements from stack" do
    {:ok,pid} = Stack.start_link([state: ["3","2","1"]])
    assert Stack.pop(pid) == "3"
    assert Stack.pop(pid) == "2"
    assert Stack.get_stack(pid) == ["1"]
  end

  test "pop/1 - remove element from empty stack" do
    {:ok,pid} = Stack.start_link([])
    assert Stack.pop(pid) == nil
    assert Stack.get_stack(pid) == []
  end

  test "push/2 - add element to empty stack" do
    {:ok,pid} = Stack.start_link([])
    Stack.push(pid,"1")
    assert Stack.get_stack(pid) == ["1"]
  end

  test "push/2 - add element to stack with multiple elements" do
    {:ok,pid} = Stack.start_link([])
    Stack.push(pid,"1")
    Stack.push(pid,"2")
    assert Stack.get_stack(pid) == ["2","1"]
  end
end
