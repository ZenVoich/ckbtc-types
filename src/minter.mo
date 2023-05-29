// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
	public type Account = { owner : Principal; subaccount : ?[Nat8] };
	public type BitcoinAddress = {
		#p2sh : [Nat8];
		#p2wpkh_v0 : [Nat8];
		#p2pkh : [Nat8];
	};
	public type BtcNetwork = { #Mainnet; #Regtest; #Testnet };
	public type Event = {
		#received_utxos : { to_account : Account; utxos : [Utxo] };
		#sent_transaction : {
			change_output : ?{ value : Nat64; vout : Nat32 };
			txid : [Nat8];
			utxos : [Utxo];
			requests : [Nat64];
			submitted_at : Nat64;
		};
		#init : InitArgs;
		#upgrade : UpgradeArgs;
		#retrieve_btc_kyt_failed : {
			block_index : Nat64;
			uuid : Text;
			address : Text;
			amount : Nat64;
			kyt_provider : Principal;
		};
		#accepted_retrieve_btc_request : {
			received_at : Nat64;
			block_index : Nat64;
			address : BitcoinAddress;
			amount : Nat64;
			kyt_provider : ?Principal;
		};
		#checked_utxo : {
			clean : Bool;
			utxo : Utxo;
			uuid : Text;
			kyt_provider : ?Principal;
		};
		#removed_retrieve_btc_request : { block_index : Nat64 };
		#confirmed_transaction : { txid : [Nat8] };
		#ignored_utxo : { utxo : Utxo };
	};
	public type InitArgs = {
		kyt_principal : ?Principal;
		ecdsa_key_name : Text;
		mode : Mode;
		retrieve_btc_min_amount : Nat64;
		ledger_id : Principal;
		max_time_in_queue_nanos : Nat64;
		btc_network : BtcNetwork;
		min_confirmations : ?Nat32;
		kyt_fee : ?Nat64;
	};
	public type MinterArg = { #Upgrade : ?UpgradeArgs; #Init : InitArgs };
	public type Mode = {
		#RestrictedTo : [Principal];
		#DepositsRestrictedTo : [Principal];
		#ReadOnly;
		#GeneralAvailability;
	};
	public type RetrieveBtcArgs = { address : Text; amount : Nat64 };
	public type RetrieveBtcError = {
		#MalformedAddress : Text;
		#GenericError : { error_message : Text; error_code : Nat64 };
		#TemporarilyUnavailable : Text;
		#AlreadyProcessing;
		#AmountTooLow : Nat64;
		#InsufficientFunds : { balance : Nat64 };
	};
	public type RetrieveBtcOk = { block_index : Nat64 };
	public type RetrieveBtcStatus = {
		#Signing;
		#Confirmed : { txid : [Nat8] };
		#Sending : { txid : [Nat8] };
		#AmountTooLow;
		#Unknown;
		#Submitted : { txid : [Nat8] };
		#Pending;
	};
	public type UpdateBalanceError = {
		#GenericError : { error_message : Text; error_code : Nat64 };
		#TemporarilyUnavailable : Text;
		#AlreadyProcessing;
		#NoNewUtxos : {
			required_confirmations : Nat32;
			current_confirmations : ?Nat32;
		};
	};
	public type UpgradeArgs = {
		kyt_principal : ?Principal;
		mode : ?Mode;
		retrieve_btc_min_amount : ?Nat64;
		max_time_in_queue_nanos : ?Nat64;
		min_confirmations : ?Nat32;
		kyt_fee : ?Nat64;
	};
	public type Utxo = {
		height : Nat32;
		value : Nat64;
		outpoint : { txid : [Nat8]; vout : Nat32 };
	};
	public type UtxoStatus = {
		#ValueTooSmall : Utxo;
		#Tainted : Utxo;
		#Minted : { minted_amount : Nat64; block_index : Nat64; utxo : Utxo };
		#Checked : Utxo;
	};

	/// *Convert BTC to ckBTC*
	///
	/// Returns the bitcoin address to which the owner should send BTC
	/// before converting the amount to ckBTC using the [update_balance]
	/// endpoint.
	///
	/// If the owner is not set, it defaults to the caller's principal.
	public type get_btc_address = shared {
		owner : ?Principal;
		subaccount : ?[Nat8];
	} -> async Text;

	/// Mints ckBTC for newly deposited UTXOs.
	///
	/// If the owner is not set, it defaults to the caller's principal.
	///
	/// **Preconditions**
	///
	/// * The owner deposited some BTC to the address that the
	///   [get_btc_address] endpoint returns.
	public type update_balance = shared {
		owner : ?Principal;
		subaccount : ?[Nat8];
	} -> async { #Ok : [UtxoStatus]; #Err : UpdateBalanceError };


	/// *Convert ckBTC to BTC*
	///
	/// Returns an estimate of the user's fee (in Satoshi) for a
	/// retrieve_btc request based on the current status of the Bitcoin network.
	public type estimate_withdrawal_fee = shared query { amount : ?Nat64 } -> async {
		minter_fee : Nat64;
		bitcoin_fee : Nat64;
	};

	/// Returns the fee that the minter will charge for a bitcoin deposit.
	public type get_deposit_fee = shared query () -> async Nat64;

	/// Returns the account to which the caller should deposit ckBTC
	/// before withdrawing BTC using the [retrieve_btc] endpoint.
	public type get_withdrawal_account = shared () -> async Account;

	/// Submits a request to convert ckBTC to BTC.
	///
	/// **Note**
	///
	/// The BTC retrieval process is slow.  Instead of
	/// synchronously waiting for a BTC transaction to settle, this
	/// method returns a request ([block_index]) that the caller can use
	/// to query the request status.
	///
	/// **Preconditions**
	///
	/// * The caller deposited the requested amount in ckBTC to the account
	///   that the [get_withdrawal_account] endpoint returns.
	public type retrieve_btc = shared RetrieveBtcArgs -> async {
		#Ok : RetrieveBtcOk;
		#Err : RetrieveBtcError;
	};

	/// Returns the status of a [retrieve_btc] request.
	public type retrieve_btc_status = shared query { block_index : Nat64; } -> async RetrieveBtcStatus;

	/// *Event log*
	///
	/// The minter keeps track of all state modifications in an internal event log.
	///
	/// This method returns a list of events in the specified range.
	/// The minter can return fewer events than requested. The result is
	/// an empty vector if the start position is greater than the total
	/// number of events.
	///
	/// NOTE: this method exists for debugging purposes.
	/// The ckBTC minter authors do not guarantee backward compatibility for this method.
	public type get_events = shared query { start : Nat64; length : Nat64 } -> async [ Event ];

	public type Service = actor {
		get_btc_address : get_btc_address;
		update_balance : update_balance;
		estimate_withdrawal_fee : estimate_withdrawal_fee;
		get_deposit_fee : get_deposit_fee;
		get_withdrawal_account : get_withdrawal_account;
		retrieve_btc_status : retrieve_btc_status;
		/// The minter keeps track of all state modifications in an internal event log.
		///
		/// This method returns a list of events in the specified range.
		/// The minter can return fewer events than requested. The result is
		/// an empty vector if the start position is greater than the total
		/// number of events.
		///
		/// NOTE: this method exists for debugging purposes.
		/// The ckBTC minter authors do not guarantee backward compatibility for this method.
		get_events : get_events;
	};
	public type ServiceClass = MinterArg -> async Service;
}