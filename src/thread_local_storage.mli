(** Thread local storage *)

type 'a t
(** A TLS slot for values of type ['a]. This allows the storage of a
    single value of type ['a] per thread. *)

val create : unit -> 'a t
(** Allocate a new TLS slot. The TLS slot starts uninitialised on each
    thread.

    Note: each TLS slot allocated consumes a word per thread, and it
    can never be deallocated. [create] should be called at toplevel to
    produce constants, do not use it in a loop.

    @raise Failure if no more TLS slots can be allocated. *)

exception Not_set
(** Exception raised when accessing a slot that was not
    previously set on this thread *)

val get_exn : 'a t -> 'a
(** [get_exn x] returns the value previously stored in the TLS slot [x]
    for the current thread.

    This function is safe to use from asynchronous callbacks without
    risks of races.

    @raise Not_set if the TLS slot has not been initialised in the
    current thread. Do note that this uses [raise_notrace] for
    performance reasons, so make sure to always catch the
    exception as it will not carry a backtrace. *)

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
