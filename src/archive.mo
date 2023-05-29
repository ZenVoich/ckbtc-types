// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
	public type Account = { owner : Principal; subaccount : ?[Nat8] };
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
			from : Account;
			memo : ?[Nat8];
			created_at_time : ?Nat64;
			amount : Nat;
		};
	};
	public type Service = actor {
		append_blocks : shared [[Nat8]] -> async ();
		get_transaction : shared query Nat64 -> async ?Transaction;
		get_transactions : shared query { start : Nat; length : Nat } -> async {
				transactions : [Transaction];
			};
		remaining_capacity : shared query () -> async Nat64;
	};
	public type ServiceClass = (Principal, Nat64, ?Nat64) -> async Service;
}