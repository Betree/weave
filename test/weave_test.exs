defmodule WeaveTest do
    use ExUnit.Case, async: :true
    use Weave

    weave "test_tuple", required: true,    handler: {:weave, :test_tuple}
    weave "test_list",  required: false,   handler: [{:weave, :test_list1}, {:weave, :test_list2}]
    weave "test_function", required: true, handler: fn(value) ->
      {:weave, :test_function, value}
    end

    test "it can store a map of required configurations" do
      assert @required -- ["test_tuple", "test_function"] == []
    end

    test "it provides a handler for tuple handlers" do
      assert {:weave, :test_tuple, "test_tuple_value"}
        = handle_configuration("test_tuple", "test_tuple_value")
    end

    test "it provides a handler for list handlers" do
      assert [{:weave, :test_list1, "test_list_value"}, {:weave, :test_list2, "test_list_value"}]
        = handle_configuration("test_list", "test_list_value")
    end

    test "it provides a handler for function handlers" do
      assert {:weave, :test_function, "test_function_value"}
        = handle_configuration("test_function", "test_function_value")
    end
end
