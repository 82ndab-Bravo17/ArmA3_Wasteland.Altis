private ["_delete"];
_delete =
"
	accountToServerDelete = _this;
	publicVariableServer 'accountToServerDelete';
";

fn_deleteFromServer = compile _delete;
