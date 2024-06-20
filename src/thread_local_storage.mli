(** Thread local storage *)

type 'a t
(** A TLS slot for values of type ['a]. This allows the storage of a
    single value of type ['a] per thread. *)

val create : unit -> 'a t
(** Allocate a new TLS slot. The TLS slot starts uninitialised on each
    thread.

    Note: each TLS slot allocated consumes a word per thread, and it
    can never be deallocated. [create] should be called at toplevel to
    produce constants, do not use it in a loop. *)

val get : 'a t -> 'a
(** [get x] returns the value previously stored in the TLS slot [x]
    for the current thread.

    This function is safe to use from asynchronous callbacks without
    risks of races.

    @raise Failure if the TLS slot has not been initialised in the
    current thread. *)

val get_opt : 'a t -> 'a option
(** [get_opt x] returns [Some v] where v is the value previously
    stored in the TLS slot [x] for the current thread. It returns
    [None] if the TLS slot has not been initialised in the current
    thread.

    This function is safe to use from asynchronous callbacks without
    risks of races. *)

val get_default : default:(unit -> 'a) -> 'a t -> 'a
(** [get_default x ~default] returns the value previously stored in
    the TLS slot [x] for the current thread. If the TLS slot has not
    been initialised, [default ()] is called, and its result is
    returned instead, after being stored in the TLS slot [x].

    If the call to [default ()] raises an exception, then the TLS slot
    remains uninitialised. If [default] is a function that always
    raises, then this function is safe to use from asynchronous
    callbacks without risks of races.

    @raise Out_of_memory *)

val set : 'a t -> 'a -> unit
(** [set x v] stores [v] into the TLS slot [x] for the current
    thread.

    @raise Out_of_memory *)
