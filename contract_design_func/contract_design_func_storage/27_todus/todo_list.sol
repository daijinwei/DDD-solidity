// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoListContract{
    struct ToDo{
        string text;
        bool completed;
    }

    ToDo[] public todos;

    function create(string calldata _text)external {
        todos.push(ToDo({text: _text, completed: false}));
    }

    function updateText(uint _index, string calldata _text)external{
        todos[_index].text = _text;
    }

    function toggleCompleted(uint _index)external {
        todos[_index].completed = !todos[_index].completed;
    }
}
