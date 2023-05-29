// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
	public type Account = { owner : Principal; subaccount : ?[Nat8] };
	public type GetAccountTransactionsArgs = {
		max_results : Nat;
		start : ?TxId;
		account : Account;
	};
	public type GetTransactions = {
		transactions : [TransactionWithId];
		oldest_tx_id : ?TxId;
	};
	public type GetTransactionsErr = { message : Text };
	public type GetTransactionsResult = {
		#Ok : GetTransactions;
		#Err : GetTransactionsErr;
	};
	public type InitArgs = { ledger_id : Principal };
	public type ListSubaccountsArgs = { owner : Principal; start : ?SubAccount };
	public type SubAccount = [Nat8];
	public type Transaction = {
		burn : ?{
			from : Account;
			memo : ?[Nat8];
			created_at_time : ?Nat64;
			amount : Nat;
		};
		kind : Text;
		mint : ?{
			to : Account;
			memo : ?[Nat8];
			created_at_time : ?Nat64;
			amount : Nat;
		};
		timestamp : Nat64;
		transfer : ?{
			to : Account;
			fee : ?Nat;
			from : Account;
			memo : ?[Nat8];
			created_at_time : ?Nat64;
			amount : Nat;
		};
	};
	public type TransactionWithId = { id : TxId; transaction : Transaction };
	public type TxId = Nat;
	public type Service = actor {
		get_account_transactions : shared GetAccountTransactionsArgs -> async GetTransactionsResult;
		ledger_id : shared query () -> async Principal;
		list_subaccounts : shared query ListSubaccountsArgs -> async [SubAccount];
	};
	public type ServiceClass = InitArgs -> async Service;
}