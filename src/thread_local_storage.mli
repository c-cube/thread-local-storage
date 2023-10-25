(** Thread local storage *)

type 'a key
(** A TLS key for values of type ['a]. This allows the
  storage of a single value of type ['a] per thread. *)

val new_key : (unit -> 'a) -> 'a key
(** Allocate a new, generative key.
    When the key is used for the first time on a thread,
    the function is called to produce it.

    This should only ever be called at toplevel to produce
    constants, do not use it in a loop. *)

val get : 'a key -> 'a
(** Get the value for the current thread. *)

val set : 'a key -> 'a -> unit
(** Set the value for the current thread. *)
